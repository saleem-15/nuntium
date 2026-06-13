import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuntium/core/models/article.dart';
import 'package:nuntium/core/utils/app_logger.dart';
import 'package:nuntium/features/bookmarks/domain/entity/bookmark_event.dart';
import 'package:nuntium/features/bookmarks/domain/use_cases/watch_bookmarks_changes_use_case.dart';

import '../../../categories/domain/use_case/get_cateogories_use_case.dart';
import '../../domain/use_cases/fetch_news_use_case.dart';
import '../../domain/use_cases/search_news_use_case.dart';
import '../../domain/use_cases/toggle_bookmark_use_case.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  // ---Dependencies---
  final FetchNewsUseCase _fetchNewsUseCase;
  final SearchNewsUseCase _searchNewsUseCase;
  final ToggleBookmarkUseCase _toggleBookmarkUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;
  final WatchBookmarksChangesUseCase _watchBookmarksChangesUseCase;

  StreamSubscription? _bookmarksSubscription;

  static const int _pageSize = 40;

  HomeBloc({
    required FetchNewsUseCase fetchNewsUseCase,
    required SearchNewsUseCase searchNewsUseCase,
    required ToggleBookmarkUseCase toggleBookmarkUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
    required WatchBookmarksChangesUseCase watchBookmarksChangesUseCase,
  }) : _fetchNewsUseCase = fetchNewsUseCase,
       _searchNewsUseCase = searchNewsUseCase,
       _toggleBookmarkUseCase = toggleBookmarkUseCase,
       _getCategoriesUseCase = getCategoriesUseCase,
       _watchBookmarksChangesUseCase = watchBookmarksChangesUseCase,
       super(const HomeState()) {
    on<HomeStarted>(_onStarted);
    on<HomeNextPageRequested>(_onNextPageRequested, transformer: droppable());
    on<HomeCategoryChanged>(_onCategoryChanged);
    on<HomeSearchSubmitted>(_onSearchChanged);
    on<HomeBookmarkToggled>(_onBookmarkToggled);
    on<HomeRefreshRequested>(_onRefreshRequested);
    on<HomeBookmarkSyncRequested>(_onBookmarksSyncRequested);

    // Initial reactive listener setup
    _bookmarksSubscription = _watchBookmarksChangesUseCase.call().listen((
      event,
    ) {
      add(
        HomeBookmarkSyncRequested(
          articleId: event.article.id,
          isSaved: event.action == BookmarkAction.added,
        ),
      );
    });
  }

  /// Reactive Listener: Automatically sync saved status across the whole app.
  /// This handles the case where an article is bookmarked from the Details screen
  /// and the user returns to the Home feed.
  void _onBookmarksSyncRequested(
    HomeBookmarkSyncRequested event,
    Emitter<HomeState> emit,
  ) {
    final syncedArticles = state.articles.map((article) {
      if (article.id == event.articleId) {
        return article.copyWith(isSaved: event.isSaved);
      }
      return article;
    }).toList();

    emit(state.copyWith(articles: syncedArticles));
  }

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading, errorMessage: null));

    final categoriesResult = await _getCategoriesUseCase.call();

    if (categoriesResult.isLeft()) {
      final failure = categoriesResult.fold((f) => f, (_) => null);
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: failure?.message,
        ),
      );
      return;
    }

    final categories = categoriesResult.fold((_) => null, (c) => c)!;

    // Correctly update state with ALL categories and set the initial selected category
    emit(
      state.copyWith(
        categories: categories,
        selectedCategory: categories.first,
      ),
    );

    await _fetchPage(emit, page: 1, replace: true);
  }

  Future<void> _onNextPageRequested(
    HomeNextPageRequested event,
    Emitter<HomeState> emit,
  ) async {
    // droppable() handles the "already loading" case;
    // hasNextPage guard handles the "nothing more to load" case. They solve different problems.

    if (!state.hasNextPage) return; // Don't fetch if no more pages

    emit(state.copyWith(status: HomeStatus.loadingNextPage));
    await _fetchPage(emit, page: state.currentPage + 1, replace: false);
  }

  Future<void> _onCategoryChanged(
    HomeCategoryChanged event,
    Emitter<HomeState> emit,
  ) async {
    // CRITICAL: Update the state with the NEW category before calling _fetchPage
    emit(
      state.copyWith(
        selectedCategory: event.category,
        status: HomeStatus.loading,
        searchQuery: '',
        currentPage: 1,
        hasNextPage: true,
        articles: [], // Clear old articles for better UI transition
        errorMessage: null,
        
      ),
    );
    await _fetchPage(emit, page: 1, replace: true);
  }

  Future<void> _onSearchChanged(
    HomeSearchSubmitted event,
    Emitter<HomeState> emit,
  ) async {
    // CRITICAL: Update the state with the NEW query before calling _fetchPage
    emit(
      state.copyWith(
        searchQuery: event.query,
        status: HomeStatus.loading,
        currentPage: 1,
        hasNextPage: true,
        articles: [],
        errorMessage: null,
      ),
    );
    await _fetchPage(emit, page: 1, replace: true);
  }

  Future<void> _onBookmarkToggled(
    HomeBookmarkToggled event,
    Emitter<HomeState> emit,
  ) async {
    // Optimistic UI update: Toggle it locally first for instant feedback
    final optimisticArticles = state.articles.map((a) {
      if (a.id == event.article.id) {
        return a.copyWith(isSaved: !a.isSaved);
      }
      return a;
    }).toList();

    emit(state.copyWith(articles: optimisticArticles));

    // Call actual backend/storage
    await _toggleBookmarkUseCase.call(article: event.article);
  }

  Future<void> _onRefreshRequested(
    HomeRefreshRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading, errorMessage: null,));
    await _fetchPage(emit, page: 1, replace: true);
  }

  Future<void> _fetchPage(
    Emitter<HomeState> emit, {
    required int page,
    required bool replace,
  }) async {
    final isSearchMode = state.searchQuery.isNotEmpty;

    if (isSearchMode) {
      final searchResult = await _searchNewsUseCase.call(
        query: state.searchQuery,
        page: page,
        pageSize: _pageSize,
      );

      searchResult.fold(
        (failure) => emit(
          state.copyWith(
            status: HomeStatus.error,
            errorMessage: failure.message,
          ),
        ),
        (articles) => _emitLoaded(emit, articles, replace, page),
      );

      return;
    }

    final categoryId = state.selectedCategory?.id;

    final result = await _fetchNewsUseCase.call(
      category: categoryId,
      page: page,
      pageSize: _pageSize,
    );

    result.fold((failure) {
      emit(
        state.copyWith(status: HomeStatus.error, errorMessage: failure.message),
      );

      AppLogger.e(failure.message);
    }, (articles) => _emitLoaded(emit, articles, replace, page));
  }

  void _emitLoaded(
    Emitter<HomeState> emit,
    List<Article> articles,
    bool replace,
    int page,
  ) {
    final allArticles = replace ? articles : [...state.articles, ...articles];

    emit(
      state.copyWith(
        status: HomeStatus.loaded,
        articles: allArticles,
        currentPage: page,
        hasNextPage: articles.length == _pageSize,
      ),
    );
  }

  @override
  Future<void> close() {
    _bookmarksSubscription?.cancel();
    return super.close();
  }
}

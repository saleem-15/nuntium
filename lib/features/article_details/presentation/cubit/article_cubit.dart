import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuntium/core/entities/article.dart';
import 'package:nuntium/features/bookmarks/domain/entity/bookmark_event.dart';
import 'package:nuntium/features/bookmarks/domain/use_cases/toggle_bookmark_use_case.dart';
import 'package:nuntium/features/bookmarks/domain/use_cases/watch_bookmarks_changes_use_case.dart';

import 'article_state.dart';

class ArticleCubit extends Cubit<ArticleState> {
  final ToggleBookmarkUseCase _toggleBookmarkUseCase;
  final WatchBookmarksChangesUseCase _watchBookmarksUseCase;
  StreamSubscription? _bookmarkSubscription;

  ArticleCubit({
    required Article initialArticle,
    required ToggleBookmarkUseCase toggleBookmarkUseCase,
    required WatchBookmarksChangesUseCase watchBookmarksUseCase,
  })  : _toggleBookmarkUseCase = toggleBookmarkUseCase,
        _watchBookmarksUseCase = watchBookmarksUseCase,
        super(ArticleLoaded(initialArticle)) {
    _listenToBookmarkChanges();
  }

  void _listenToBookmarkChanges() {
    _bookmarkSubscription =
        _watchBookmarksUseCase.call().listen((BookmarkChangeEvent event) {
      if (state is ArticleLoaded) {
        final currentArticle = (state as ArticleLoaded).article;
        final isSaved = event.action == BookmarkAction.added;

        if (currentArticle.id == event.article.id) {
          emit(ArticleLoaded(currentArticle.copyWith(isSaved: isSaved)));
        }
      }
    });
  }

  Future<void> toggleBookmark() async {
    if (state is ArticleLoaded) {
      final currentArticle = (state as ArticleLoaded).article;
      
      // Optimistic update
      final optimisticArticle = currentArticle.copyWith(isSaved: !currentArticle.isSaved);
      emit(ArticleLoaded(optimisticArticle));

      try {
        final isSuccess = await _toggleBookmarkUseCase.call(article: currentArticle);
        if (!isSuccess) {
          // Revert on failure
          emit(ArticleLoaded(currentArticle));
        }
      } catch (_) {
        emit(ArticleLoaded(currentArticle));
      }
    }
  }

  @override
  Future<void> close() {
    _bookmarkSubscription?.cancel();
    return super.close();
  }
}

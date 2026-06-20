import 'package:equatable/equatable.dart';
import 'package:nuntium/core/entities/article.dart';
import 'package:nuntium/features/categories/domain/entities/category_entity.dart';

enum HomeStatus { initial, loading, loaded, loadingNextPage, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<Article> articles;
  final List<CategoryEntity> categories;
  final bool hasNextPage;
  final String? errorMessage;
  final CategoryEntity? selectedCategory;
  final String searchQuery;
  final int currentPage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.articles = const [],
    this.categories = const [],
    this.hasNextPage = true,
    this.errorMessage,
    this.selectedCategory,
    this.searchQuery = '',
    this.currentPage = 1,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<Article>? articles,
    List<CategoryEntity>? categories,
    bool? hasNextPage,
    String? errorMessage,
    CategoryEntity? selectedCategory,
    String? searchQuery,
    int? currentPage,
  }) {
    return HomeState(
      status: status ?? this.status,
      articles: articles ?? this.articles,
      categories: categories ?? this.categories,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      // Intentionally NOT using `?? this.errorMessage`. errorMessage is a
      // transient field only relevant when status == error. It auto-clears on
      // every copyWith call so stale errors don't leak into loading/loaded states.
      errorMessage: errorMessage,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        articles,
        categories,
        hasNextPage,
        errorMessage,
        selectedCategory,
        searchQuery,
        currentPage,
      ];
}

import 'package:equatable/equatable.dart';
import 'package:new_nuntium/core/models/article.dart';
import 'package:new_nuntium/features/categories/domain/entities/category_entity.dart';

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
      errorMessage: errorMessage ?? this.errorMessage,
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

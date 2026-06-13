import 'package:nuntium/core/models/article.dart';
import 'package:nuntium/features/categories/domain/entities/category_entity.dart';

sealed class HomeEvent {}

class HomeStarted extends HomeEvent {}

class HomeNextPageRequested extends HomeEvent {}

class HomeSearchSubmitted extends HomeEvent {
  final String query;
  HomeSearchSubmitted({required this.query});
}

class HomeCategoryChanged extends HomeEvent {
  final CategoryEntity category;
  HomeCategoryChanged({required this.category});
}

class HomeBookmarkToggled extends HomeEvent {
  final Article article;
  HomeBookmarkToggled({required this.article});
}

class HomeRefreshRequested extends HomeEvent {}

class HomeBookmarkSyncRequested extends HomeEvent {
  final String articleId;
  final bool isSaved;

  HomeBookmarkSyncRequested({required this.articleId, required this.isSaved});
}

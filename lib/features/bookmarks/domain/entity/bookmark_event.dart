import 'package:nuntium/core/entities/article.dart';

enum BookmarkAction { added, removed }

/// A wrapper class to describe what happened in the bookmarks
class BookmarkChangeEvent {
  final BookmarkAction action;
  final Article article;

  BookmarkChangeEvent({required this.action, required this.article});
}

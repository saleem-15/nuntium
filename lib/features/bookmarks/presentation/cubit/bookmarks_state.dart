import 'package:equatable/equatable.dart';
import 'package:nuntium/core/entities/article.dart';

sealed class BookmarksState extends Equatable {
  const BookmarksState();

  @override
  List<Object?> get props => [];
}

class BookmarksInitial extends BookmarksState {
  const BookmarksInitial();
}

class BookmarksLoading extends BookmarksState {
  const BookmarksLoading();
}

class BookmarksLoaded extends BookmarksState {
  final List<Article> articles;

  const BookmarksLoaded(this.articles);

  @override
  List<Object?> get props => [articles];
}

class BookmarksError extends BookmarksState {
  final String message;

  const BookmarksError(this.message);

  @override
  List<Object?> get props => [message];
}

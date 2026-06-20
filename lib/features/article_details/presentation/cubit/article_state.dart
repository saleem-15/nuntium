import 'package:equatable/equatable.dart';
import 'package:nuntium/core/entities/article.dart';

sealed class ArticleState extends Equatable {
  const ArticleState();

  @override
  List<Object?> get props => [];
}

class ArticleInitial extends ArticleState {
  const ArticleInitial();
}

class ArticleLoaded extends ArticleState {
  final Article article;

  const ArticleLoaded(this.article);

  @override
  List<Object?> get props => [article];
}

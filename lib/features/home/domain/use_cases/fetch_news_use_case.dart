import 'package:dartz/dartz.dart';
import 'package:nuntium/core/errors/failures.dart';
import 'package:nuntium/core/models/article.dart';
import 'package:nuntium/features/bookmarks/domain/repository/bookmark_repository.dart';
import 'package:nuntium/features/home/domain/repository/news_repository.dart';

/// Use Case responsible for fetching news.
/// It encapsulates the business logic for retrieving articles.
class FetchNewsUseCase {
  final NewsRepository _newsRepository;
  final BookmarkRepository _bookmarkRepository;

  FetchNewsUseCase(this._newsRepository, this._bookmarkRepository);

  /// Callable class method to execute the use case
  Future<Either<Failure, List<Article>>> call({
    required String? category,
    required int page,
    required int pageSize,
  }) async {
    final result = await _newsRepository.fetchNews(
      category: category,
      page: page,
      pageSize: pageSize,
    );

    return result.map(
      (news) => news.map((article) {
        return article.copyWith(
          isSaved: _bookmarkRepository.isArticleSaved(article.id),
        );
      }).toList(),
    );
  }
}

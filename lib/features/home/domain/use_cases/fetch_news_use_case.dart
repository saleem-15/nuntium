import 'package:dartz/dartz.dart';
import 'package:nuntium/core/errors/failures.dart';
import 'package:nuntium/core/entities/article.dart';
import 'package:nuntium/features/home/domain/repository/news_repository.dart';

/// Use Case responsible for fetching news.
/// It encapsulates the business logic for retrieving articles.
class FetchNewsUseCase {
  final NewsRepository _newsRepository;

  FetchNewsUseCase(this._newsRepository);

  /// Callable class method to execute the use case
  Future<Either<Failure, List<Article>>> call({
    required String? category,
    required int page,
    required int pageSize,
  }) async {
    return await _newsRepository.fetchNews(
      category: category,
      page: page,
      pageSize: pageSize,
    );
  }
}

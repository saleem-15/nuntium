import 'package:dartz/dartz.dart';
import 'package:nuntium/core/errors/failures.dart';
import 'package:nuntium/core/entities/article.dart';
import 'package:nuntium/features/home/domain/repository/news_repository.dart';

class SearchNewsUseCase {
  final NewsRepository _newsRepository;

  SearchNewsUseCase(this._newsRepository);

  Future<Either<Failure, List<Article>>> call({
    required String query,
    required int page,
    required int pageSize,
  }) async {
    return await _newsRepository.searchNews(
      query: query,
      page: page,
      pageSize: pageSize,
    );
  }
}

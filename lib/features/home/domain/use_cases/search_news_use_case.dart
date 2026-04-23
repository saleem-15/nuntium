import 'package:dartz/dartz.dart';
import 'package:new_nuntium/core/errors/failures.dart';
import 'package:new_nuntium/core/models/article.dart';
import 'package:new_nuntium/features/bookmarks/domain/repository/bookmark_repository.dart';
import 'package:new_nuntium/features/home/domain/repository/news_repository.dart';

class SearchNewsUseCase {
  final NewsRepository _newsRepository;
  final BookmarkRepository _bookmarkRepository;

  SearchNewsUseCase(this._newsRepository, this._bookmarkRepository);

  Future<Either<Failure, List<Article>>> call({
    required String query,
    required int page,
    required int pageSize,
  }) async {
    final result = await _newsRepository.searchNews(
      query: query,
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

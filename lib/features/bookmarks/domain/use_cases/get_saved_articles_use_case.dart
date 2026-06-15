import 'package:nuntium/core/entities/article.dart';
import 'package:nuntium/features/bookmarks/domain/repository/bookmark_repository.dart';

class GetSavedArticlesUseCase {
  final BookmarkRepository _bookmarkRepository;

  GetSavedArticlesUseCase(this._bookmarkRepository);

  List<Article> call() {
    return _bookmarkRepository.getSavedArticles();
  }
}
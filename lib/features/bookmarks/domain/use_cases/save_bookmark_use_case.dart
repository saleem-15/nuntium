import 'package:nuntium/core/models/article.dart';
import 'package:nuntium/features/bookmarks/domain/repository/bookmark_repository.dart';

class SaveBookmarkUseCase {
  final BookmarkRepository _bookmarkRepository;

  SaveBookmarkUseCase(this._bookmarkRepository);

  Future<void> call(Article article) async {
    return await _bookmarkRepository.saveBookmark(article);
  }
}
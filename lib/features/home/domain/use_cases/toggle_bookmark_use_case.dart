import 'package:nuntium/core/entities/article.dart';
import 'package:nuntium/features/bookmarks/domain/repository/bookmark_repository.dart';

class ToggleBookmarkUseCase {
  final BookmarkRepository _repository;

  ToggleBookmarkUseCase(this._repository);

  Future<bool> call({required Article article}) async {
    final prevState = article.isSaved;

    if (prevState) {
      await _repository.deleteBookmark(article);
    } else {
      await _repository.saveBookmark(article);
    }
    
    final currentState = _repository.isArticleSaved(article.id);
    final bool isSuccessfullyToggled = currentState != prevState;

    return isSuccessfullyToggled;
  }
}

import 'package:hive_flutter/hive_flutter.dart';

import '../models/article_hive_model.dart';

class StorageService {
  late Box<ArticleHiveModel> _bookmarkBox;
  static const String _bookmarkBoxName = 'bookmarks';

  /// Must be called when the app starts
  Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ArticleHiveModelAdapter());
    }

    await _initBookmarkBox();
  }

  Future<void> _initBookmarkBox() async {
    _bookmarkBox = await Hive.openBox<ArticleHiveModel>(_bookmarkBoxName);
  }

  Future<void> saveBookmark(ArticleHiveModel bookmark) async {
    await _bookmarkBox.put(bookmark.id, bookmark);
  }

  List<ArticleHiveModel> getAllBookmarks() {
    return _bookmarkBox.values.toList();
  }

  Future<void> deleteBookmark(String id) async {
    await _bookmarkBox.delete(id);
  }

  bool isArticleSaved(String id) {
    return _bookmarkBox.containsKey(id);
  }

  Future<void> clearAllBookmarks() async {
    await _bookmarkBox.clear();
  }
}

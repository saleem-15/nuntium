import 'package:dartz/dartz.dart';
import 'package:nuntium/core/errors/error_handler.dart';
import 'package:nuntium/core/errors/failures.dart';
import 'package:nuntium/core/entities/article.dart';
import 'package:nuntium/core/network/network_info.dart';
import 'package:nuntium/features/home/domain/repository/news_repository.dart';

import '../data_source/news_remote_data_source.dart';

/// Implementation of the NewsRepository interface.
/// This class coordinates between Remote Data Source (API) and Local Data Source (if any).
class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  NewsRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, List<Article>>> fetchNews({
    required String? category,
    required int page,
    required int pageSize,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Left(OfflineFailure());
    }

    try {
      final news = await _remoteDataSource.fetchTopHeadlines(
        category: category,
        page: page,
        pageSize: pageSize,
      );

      return Right(_cleanArticlesContent(news));
    } catch (error, stackTrace) {
      return Left(ErrorHandler.handle(error, stackTrace));
    }
  }

  @override
  Future<Either<Failure, List<Article>>> searchNews({
    required String query,
    required int page,
    required int pageSize,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Left(OfflineFailure());
    }
    try {
      final news = await _remoteDataSource.searchNews(
        query: query,
        page: page,
        pageSize: pageSize,
      );

      return Right(_cleanArticlesContent(news));
    } catch (error, stackTrace) {
      return Left(ErrorHandler.handle(error, stackTrace));
    }
  }

  List<Article> _cleanArticlesContent(List<Article> articles) {
    return articles.map((article) {
      return article.copyWith(content: _cleanContent(article.content));
    }).toList();
  }

  String _cleanContent(String content) {
    if (content.isEmpty) return content;

    // 1. Strip the NewsAPI truncation suffix: [+300 chars]
    var cleaned = content.replaceFirst(
      RegExp(r'\s*\[\+\d+\s+char(?:s|acters)?\]'),
      '',
    );

    // 2. Replace block HTML tags with spaces/newlines to prevent text clumping
    cleaned = cleaned.replaceAll(
      RegExp(r'</?(?:p|div|br|li|ul|ol)\s*/?>', caseSensitive: false),
      ' ',
    );

    // 3. Strip all other HTML tags
    cleaned = cleaned.replaceAll(RegExp(r'<[^>]*>'), '');

    // 4. Decode common HTML entities
    cleaned = cleaned
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&nbsp;', ' ');

    // 5. Clean up trailing truncated word fragments after an ellipsis (e.g. "... Vie" or "...\nView")
    cleaned = cleaned.replaceFirst(
      RegExp(r'(?:\.\.\.|…)\s*\w{1,4}\s*$'),
      '...',
    );

    // 6. Collapse multiple spaces and trim
    cleaned = cleaned.replaceAll(RegExp(r'[ \t]+'), ' ');

    return cleaned.trim();
  }
}

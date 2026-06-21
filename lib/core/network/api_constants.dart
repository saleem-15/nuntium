import '/core/env/env.dart';

class ApiConstants {
  // Private constructor to prevent instantiation
  ApiConstants._();

  // -- Base Configuration --
  static const String baseUrl = "https://newsapi.org/v2";
  static String apiKey = Env.apiKey;

  // -- Timeouts --
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // -- Endpoints --
  static const String topHeadlines = '/top-headlines';
  static const String everything = '/everything';

  // -- Params & Keys --
  static const String paramApiKey = 'apiKey';
  static const String paramQ = 'q';
  static const String paramCategory = 'category';
  static const String paramCountry = 'country';
  static const String paramPage = 'page';
  static const String paramPageSize = 'pageSize';

  // -- Default Values --
  static const int defaultPageSize = 20;
  static const String defaultCountry = 'us';
}

import 'package:json_annotation/json_annotation.dart';

import 'package:nuntium/config/constants.dart';
import 'package:nuntium/features/home/data/response/article_response.dart';

import 'source_response.dart';

part 'home_response.g.dart';

@JsonSerializable()
class HomeResopnse {
  @JsonKey(name: ApiConstants.status)
  String status;

  @JsonKey(name: ApiConstants.totalResults)
  int totalResults;

  @JsonKey(name: ApiConstants.source)
  SourceResponse? source;

  @JsonKey(name: ApiConstants.articles)
  List<ArticleResponse>? articles;

  HomeResopnse({
    required this.status,
    required this.articles,
    required this.source,
    required this.totalResults,
  });

  factory HomeResopnse.fromJson(Map<String, dynamic> json) => _$HomeResopnseFromJson(json);

  Map<String, dynamic> toJson() => _$HomeResopnseToJson(this);
}

import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final String id;
  final String title;
  final String category;
  final String sourceName;
  final String imageUrl;
  final bool isSaved;
  final String content;
  final String url;

   // ignore: prefer_const_constructors_in_immutables
   Article({
    required this.id,
    required this.title,
    required this.category,
    required this.sourceName,
    required this.imageUrl,
    this.isSaved = false,
    required this.content,
    required this.url,
  });


  Article copyWith({
    String? id,
    String? title,
    String? category,
    String? sourceName,
    String? imageUrl,
    bool? isSaved,
    String? content,
    String? url,
  }) {
    return Article(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      sourceName: sourceName ?? this.sourceName,
      imageUrl: imageUrl ?? this.imageUrl,
      isSaved: isSaved ?? this.isSaved,
      content: content ?? this.content,
      url: url ?? this.url,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    category,
    sourceName,
    imageUrl,
    isSaved,
    content,
    url,
  ];
}

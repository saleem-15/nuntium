import 'package:equatable/equatable.dart';

class SelectFavoriteTopicsState extends Equatable {
  final List<String> selectedTopics;
  const SelectFavoriteTopicsState({this.selectedTopics = const []});

  @override
  List<Object?> get props => [selectedTopics];
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuntium/core/resources/app_strings.dart';
import 'select_favorite_topics_state.dart';

class SelectFavoriteTopicsCubit extends Cubit<SelectFavoriteTopicsState> {
  final List<String> topics = [
    AppStrings.sports,
    AppStrings.politics,
    AppStrings.life,
    AppStrings.gaming,
    AppStrings.animals,
    AppStrings.nature,
    AppStrings.food,
    AppStrings.art,
    AppStrings.history,
    AppStrings.fashion,
  ];

  SelectFavoriteTopicsCubit() : super(const SelectFavoriteTopicsState());

  void toggleTopic(String topic) {
    final updatedList = List<String>.from(state.selectedTopics);
    if (updatedList.contains(topic)) {
      updatedList.remove(topic);
    } else {
      updatedList.add(topic);
    }
    emit(SelectFavoriteTopicsState(selectedTopics: updatedList));
  }
}

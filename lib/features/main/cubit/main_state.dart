import 'package:equatable/equatable.dart';

sealed class MainState extends Equatable {
  final int tabIndex;

  const MainState(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}

class MainInitial extends MainState {
  const MainInitial() : super(0);
}

class MainTabChanged extends MainState {
  const MainTabChanged(super.tabIndex);
}

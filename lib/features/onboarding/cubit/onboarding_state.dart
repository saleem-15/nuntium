import 'package:equatable/equatable.dart';

sealed class OnboardingState extends Equatable {
  final int index; // current index of the page (0, 1, 2)
  const OnboardingState(this.index);

  @override
  List<Object?> get props => [index];
}

class OnboardingInitial extends OnboardingState {
  const OnboardingInitial() : super(0);
}

class OnboardingPageChanged extends OnboardingState {
  const OnboardingPageChanged(super.index);
}

class OnboardingNavigateToWelcome extends OnboardingState {
  const OnboardingNavigateToWelcome(super.index);
}

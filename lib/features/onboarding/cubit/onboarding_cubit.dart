import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuntium/core/resources/app_strings.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingInitial());

  final List<String> titles = [
    AppStrings.onboardingTitle1,
    AppStrings.onboardingTitle2,
    AppStrings.onboardingTitle3,
  ];

  final List<String> subTitles = [
    AppStrings.onboardingSubtitle1,
    AppStrings.onboardingSubtitle2,
    AppStrings.onboardingSubtitle3,
  ];

  void onPageChanged(int index) {
    emit(OnboardingPageChanged(index));
  }

  void navigateToWelcome() {
    emit(OnboardingNavigateToWelcome(state.index));
  }
}

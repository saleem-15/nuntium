import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuntium/core/services/shared_prefrences.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final AppSharedPrefs _appSharedPref;

  SplashCubit(this._appSharedPref) : super(SplashInitial());

  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 2));

    // Checks if its the first time to open the app
    final isFirstTime = _appSharedPref.isFirstTime;

    // Persist the flag BEFORE navigating, so it's guaranteed to run
    // even though the Cubit gets closed when the route is removed from the tree.
    if (isFirstTime) {
      _appSharedPref.setIsFirstTimeToFalse();
    }

    final user = FirebaseAuth.instance.currentUser;
    final isUserLoggedIn = user != null;

    if (isFirstTime) {
      emit(SplashNavigateToOnboarding());
    } else if (isUserLoggedIn) {
      if (!user.emailVerified) {
        emit(SplashNavigateToVerification());
      } else {
        emit(SplashNavigateToMain());
      }
    } else {
      emit(SplashNavigateToSignUp());
    }
  }
}

import 'package:equatable/equatable.dart';

sealed class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {}

class SplashNavigateToOnboarding extends SplashState {}

class SplashNavigateToMain extends SplashState {}

class SplashNavigateToSignUp extends SplashState {}

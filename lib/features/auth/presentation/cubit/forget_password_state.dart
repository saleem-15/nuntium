import 'package:equatable/equatable.dart';

sealed class ForgetPasswordState extends Equatable {
  const ForgetPasswordState();

  @override
  List<Object?> get props => [];
}

class ForgetPasswordInitial extends ForgetPasswordState {
  const ForgetPasswordInitial();
}

class ForgetPasswordLoading extends ForgetPasswordState {
  const ForgetPasswordLoading();
}

class ForgetPasswordSuccess extends ForgetPasswordState {
  final String email;
  final int remainingSeconds;
  final bool isTimerRunning;

  const ForgetPasswordSuccess({
    required this.email,
    required this.remainingSeconds,
    required this.isTimerRunning,
  });

  @override
  List<Object?> get props => [email, remainingSeconds, isTimerRunning];
}

class ForgetPasswordError extends ForgetPasswordState {
  final String message;

  const ForgetPasswordError(this.message);

  @override
  List<Object?> get props => [message];
}

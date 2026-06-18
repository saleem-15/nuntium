import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuntium/features/auth/domain/use_cases/reset_password.dart';
import 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final ResetPasswordUseCase _resetPasswordUseCase;

  ForgetPasswordCubit({
    required ResetPasswordUseCase resetPasswordUseCase,
  })  : _resetPasswordUseCase = resetPasswordUseCase,
        super(const ForgetPasswordInitial());

  Timer? _timer;

  Future<void> sendPasswordResetEmail(String email) async {
    emit(const ForgetPasswordLoading());
    final result = await _resetPasswordUseCase.call(email);
    result.fold(
      (failure) => emit(ForgetPasswordError(failure.message)),
      (_) => _startTimer(email),
    );
  }

  void _startTimer(String email) {
    _timer?.cancel();
    int seconds = 30;
    emit(ForgetPasswordSuccess(
      email: email,
      remainingSeconds: seconds,
      isTimerRunning: true,
    ));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds == 0) {
        timer.cancel();
        emit(ForgetPasswordSuccess(
          email: email,
          remainingSeconds: 0,
          isTimerRunning: false,
        ));
      } else {
        seconds--;
        emit(ForgetPasswordSuccess(
          email: email,
          remainingSeconds: seconds,
          isTimerRunning: true,
        ));
      }
    });
  }

  void resendEmail(String email) {
    if (state is ForgetPasswordSuccess && !(state as ForgetPasswordSuccess).isTimerRunning) {
      sendPasswordResetEmail(email);
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuntium/features/auth/domain/use_cases/check_email_verified_use_case.dart';
import 'package:nuntium/features/auth/domain/use_cases/send_email_verification_use_case.dart';
import 'package:nuntium/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'email_verification_state.dart';

class EmailVerificationCubit extends Cubit<EmailVerificationState> {
  final SendEmailVerificationUseCase _sendEmailVerificationUseCase;
  final CheckEmailVerifiedUseCase _checkEmailVerifiedUseCase;
  final SignOutUseCase _signOutUseCase;

  EmailVerificationCubit({
    required SendEmailVerificationUseCase sendEmailVerificationUseCase,
    required CheckEmailVerifiedUseCase checkEmailVerifiedUseCase,
    required SignOutUseCase signOutUseCase,
  })  : _sendEmailVerificationUseCase = sendEmailVerificationUseCase,
        _checkEmailVerifiedUseCase = checkEmailVerifiedUseCase,
        _signOutUseCase = signOutUseCase,
        super(const EmailVerificationInitial());

  Timer? _timer;

  void startVerificationCheck() {
    _timer?.cancel();
    // Automatically poll Firebase every 3 seconds without user action.
    // WHY: Firebase doesn't push a stream event when only 'emailVerified' changes.
    //      Polling via reload() is the only reliable mechanism.
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  Future<void> checkEmailVerified() async {
    final result = await _checkEmailVerifiedUseCase.call();
    result.fold(
      (failure) {
        // Silently ignore polling failures (e.g. temporary network offline).
        // We only surface errors when the user explicitly presses 'check'.
      },
      (isVerified) {
        if (isVerified) {
          _timer?.cancel();
          emit(const EmailVerificationVerified());
        }
      },
    );
  }

  Future<void> sendVerificationEmail() async {
    emit(const EmailVerificationLoading());
    final result = await _sendEmailVerificationUseCase.call();
    result.fold(
      (failure) => emit(EmailVerificationError(failure.message)),
      (_) => emit(const EmailVerificationSentSuccess()),
    );
  }

  Future<void> logOut() async {
    _timer?.cancel();
    await _signOutUseCase.call();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

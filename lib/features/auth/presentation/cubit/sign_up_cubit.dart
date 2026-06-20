import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuntium/features/auth/domain/use_cases/signup_use_case.dart';
import 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final SignupUseCase _signUpUseCase;

  SignUpCubit({
    required SignupUseCase signUpUseCase,
  }) : _signUpUseCase = signUpUseCase,
       super(const SignUpInitial());

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(const SignUpLoading());

    final result = await _signUpUseCase.call(
      email.trim(),
      password.trim(),
      name.trim(),
    );

    result.fold(
      (failure) => emit(SignUpError(failure.message)),
      (right) async {
        try {
          await FirebaseAuth.instance.currentUser?.sendEmailVerification();
        } catch (_) {
          // Ignore verification email sending errors so we still proceed to signup success
        }
        emit(const SignUpSuccess());
      },
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuntium/features/auth/domain/use_cases/login_use_case.dart';
import 'package:nuntium/features/auth/domain/use_cases/sign_in_with_google_use_case.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;

  LoginCubit({
    required LoginUseCase loginUseCase,
    required SignInWithGoogleUseCase signInWithGoogleUseCase,
  }) : _loginUseCase = loginUseCase,
       _signInWithGoogleUseCase = signInWithGoogleUseCase,
       super(const LoginInitial());

  Future<void> signIn({required String email, required String password}) async {
    emit(const LoginLoading());

    final result = await _loginUseCase.call(email.trim(), password.trim());

    result.fold(
      (failure) => emit(LoginError(failure.message)),
      (right) => emit(const LoginSuccess()),
    );
  }

  Future<void> signInWithGoogle() async {
    emit(const LoginLoading());

    final result = await _signInWithGoogleUseCase.call();

    result.fold(
      (failure) => emit(LoginError(failure.message)),
      (right) => emit(const LoginSuccess()),
    );
  }
}

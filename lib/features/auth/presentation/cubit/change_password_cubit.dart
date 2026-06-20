import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuntium/features/auth/domain/use_cases/change_password_use_case.dart';
import 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePasswordUseCase _changePasswordUseCase;

  ChangePasswordCubit({
    required ChangePasswordUseCase changePasswordUseCase,
  })  : _changePasswordUseCase = changePasswordUseCase,
        super(const ChangePasswordInitial());

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(const ChangePasswordLoading());
    final result = await _changePasswordUseCase.call(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    result.fold(
      (failure) => emit(ChangePasswordError(failure.message)),
      (_) => emit(const ChangePasswordSuccess()),
    );
  }
}

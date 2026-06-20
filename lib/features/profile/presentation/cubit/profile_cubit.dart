import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuntium/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:nuntium/features/profile/domain/entities/user_entity.dart';
import 'package:nuntium/features/profile/domain/use_cases/get_user_data_use_case.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final SignOutUseCase _signOutUseCase;
  final GetUserDataUseCase _getUserDataUseCase;

  ProfileCubit({
    required SignOutUseCase signOutUseCase,
    required GetUserDataUseCase getUserDataUseCase,
  })  : _signOutUseCase = signOutUseCase,
        _getUserDataUseCase = getUserDataUseCase,
        super(const ProfileInitial());

  UserEntity? _user;
  bool _isNotificationsOn = true;

  void getUserData() {
    final result = _getUserDataUseCase.call();
    result.fold(
      (failure) {
        emit(ProfileLoaded(user: null, isNotificationsOn: _isNotificationsOn));
      },
      (userEntity) {
        _user = userEntity;
        emit(ProfileLoaded(user: userEntity, isNotificationsOn: _isNotificationsOn));
      },
    );
  }

  void toggleNotifications(bool value) {
    _isNotificationsOn = value;
    emit(ProfileLoaded(user: _user, isNotificationsOn: _isNotificationsOn));
  }

  Future<void> signOut() async {
    emit(const ProfileSignOutLoading());
    final result = await _signOutUseCase.call();
    result.fold(
      (failure) => emit(ProfileSignOutError(failure.message)),
      (_) => emit(const ProfileSignOutSuccess()),
    );
  }
}

import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoaded extends ProfileState {
  final UserEntity? user;
  final bool isNotificationsOn;

  const ProfileLoaded({
    this.user,
    required this.isNotificationsOn,
  });

  @override
  List<Object?> get props => [user, isNotificationsOn];
}

class ProfileSignOutLoading extends ProfileState {
  const ProfileSignOutLoading();
}

class ProfileSignOutSuccess extends ProfileState {
  const ProfileSignOutSuccess();
}

class ProfileSignOutError extends ProfileState {
  final String message;

  const ProfileSignOutError(this.message);

  @override
  List<Object?> get props => [message];
}

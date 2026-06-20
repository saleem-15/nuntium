import 'package:equatable/equatable.dart';

sealed class EmailVerificationState extends Equatable {
  const EmailVerificationState();

  @override
  List<Object?> get props => [];
}

class EmailVerificationInitial extends EmailVerificationState {
  const EmailVerificationInitial();
}

class EmailVerificationLoading extends EmailVerificationState {
  const EmailVerificationLoading();
}

class EmailVerificationSentSuccess extends EmailVerificationState {
  const EmailVerificationSentSuccess();
}

class EmailVerificationVerified extends EmailVerificationState {
  const EmailVerificationVerified();
}

class EmailVerificationError extends EmailVerificationState {
  final String message;

  const EmailVerificationError(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {}

class AuthErrorState extends AuthState {
  final String errorMessage;

  AuthErrorState(this.errorMessage);
}

class NfcAuthLoadingState extends AuthState {}

class NfcAuthSuccessState extends AuthState {}

class NfcAuthErrorState extends AuthState {
  final String errorMessage;

  NfcAuthErrorState(this.errorMessage);
}

class VerifyEmailLoading extends AuthState {}

class VerifyEmailSuccess extends AuthState {}

class VerifyEmailError extends AuthState {
  final String errorMessage;

  VerifyEmailError(this.errorMessage);
}

class VerifyOtpLoading extends AuthState {}

class VerifyOtpSuccess extends AuthState {}

class VerifyOtpError extends AuthState {
  final String errorMessage;

  VerifyOtpError(this.errorMessage);
}

class ResetPasswordLoading extends AuthState {}

class ResetPasswordSuccess extends AuthState {}

class ResetPasswordError extends AuthState {
  final String errorMessage;
  ResetPasswordError(this.errorMessage);
}

class EnableNfcLoading extends AuthState {}

class EnableNfcSuccess extends AuthState {}

class EnableNfcError extends AuthState {
  final String errorMessage;
  EnableNfcError(this.errorMessage);
}

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

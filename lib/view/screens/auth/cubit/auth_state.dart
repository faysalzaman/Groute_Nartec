import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final AuthStatus status;
  final String? errorMessage;

  const AuthState({this.status = AuthStatus.initial, this.errorMessage});

  @override
  List<Object?> get props => [status, errorMessage];

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    String? accessToken,
    String? gtrackToken,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
  bool get hasError => status == AuthStatus.error;
}

enum AuthStatus { initial, loading, authenticated, error, unauthenticated }

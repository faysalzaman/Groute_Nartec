import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groute_nartec/view/screens/auth/controller/auth_controller.dart';
import 'package:groute_nartec/view/screens/auth/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({AuthController? controller}) : super(AuthInitialState());

  final AuthController _authController = AuthController();

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      emit(AuthErrorState('Email and password cannot be empty'));
      return;
    }

    emit(AuthLoadingState());
    try {
      await _authController.login(email, password);

      emit(AuthSuccessState());
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  Future<void> loginWithNfc(String serialNumber) async {
    if (serialNumber.isEmpty) {
      emit(AuthErrorState('Serial number cannot be empty'));
      return;
    }

    emit(AuthLoadingState());
    try {
      await _authController.loginWithNfc("123123");

      emit(AuthSuccessState());
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }
}

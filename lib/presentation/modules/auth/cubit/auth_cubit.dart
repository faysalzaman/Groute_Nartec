import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groute_nartec/repositories/driver_repository.dart';
import 'package:groute_nartec/presentation/modules/auth/cubit/auth_state.dart';
import 'package:groute_nartec/presentation/modules/auth/models/driver_model.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({DriverRepositry? controller}) : super(AuthInitialState());

  final DriverRepositry _authController = DriverRepositry();

  Driver? driver;

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      emit(AuthErrorState('Email and password cannot be empty'));
      return;
    }

    emit(AuthLoadingState());
    try {
      driver = await _authController.login(email, password);

      emit(AuthSuccessState());
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  Future<void> loginWithNfc(String serialNumber) async {
    if (serialNumber.isEmpty) {
      emit(NfcAuthErrorState('Serial number cannot be empty'));
      return;
    }

    emit(NfcAuthLoadingState());
    try {
      driver = await _authController.loginWithNfc("123123");

      emit(NfcAuthSuccessState());
    } catch (e) {
      emit(NfcAuthErrorState(e.toString()));
    }
  }
}

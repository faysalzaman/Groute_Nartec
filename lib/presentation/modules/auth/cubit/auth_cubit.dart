import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groute_nartec/repositories/driver_repository.dart';
import 'package:groute_nartec/presentation/modules/auth/cubit/auth_state.dart';
import 'package:groute_nartec/presentation/modules/auth/models/driver_model.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({DriverRepositry? controller}) : super(AuthInitialState());

  final DriverRepositry _authController = DriverRepositry();
  String token = '';

  Driver? driver;

  static AuthCubit get(context) => BlocProvider.of(context);

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

  Future<void> verifyEmail(String email) async {
    if (email.isEmpty) {
      emit(VerifyEmailError('Email cannot be empty'));
      return;
    }

    emit(VerifyEmailLoading());
    try {
      // Simulate a network call
      await Future.delayed(const Duration(seconds: 2));

      token = await _authController.verifyEmail(email);
      emit(VerifyEmailSuccess());
    } catch (e) {
      emit(VerifyEmailError(e.toString()));
    }
  }

  Future<void> verifyOtp(String otp) async {
    if (otp.isEmpty) {
      emit(VerifyOtpError('OTP cannot be empty'));
      return;
    }

    emit(VerifyOtpLoading());
    try {
      // Simulate a network call
      await Future.delayed(const Duration(seconds: 2));

      await _authController.verifyOtp(otp, token);
      emit(VerifyOtpSuccess());
    } catch (e) {
      emit(VerifyOtpError(e.toString()));
    }
  }

  Future<void> resetPassword(String newPassword, String email) async {
    emit(ResetPasswordLoading());
    try {
      await _authController.resetPassword(newPassword, email, token);
      await Future.delayed(const Duration(seconds: 2));

      emit(ResetPasswordSuccess());
    } catch (e) {
      emit(ResetPasswordError(e.toString()));
    }
  }
}

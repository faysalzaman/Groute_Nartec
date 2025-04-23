import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groute_nartec/view/screens/auth/controller/auth_controller.dart';
import 'package:groute_nartec/view/screens/auth/cubit/auth_state.dart';
import 'package:groute_nartec/view/screens/auth/model/child_member.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({AuthController? controller}) : super(const AuthState());

  final AuthController _authController = AuthController();

  ChildMember? _childMember;
  ChildMember? get childMember => _childMember;

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Email and password are required',
        ),
      );
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final childMember = await _authController.login(email, password);
      _childMember = childMember;

      if (childMember != null) {
        emit(state.copyWith(status: AuthStatus.authenticated));
      } else {
        emit(
          state.copyWith(
            status: AuthStatus.error,
            errorMessage: 'Invalid email or password',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.error, errorMessage: e.toString()),
      );
    }
  }
}

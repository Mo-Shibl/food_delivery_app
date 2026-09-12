import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_app/core/helpers/session.dart';

import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;

  AuthCubit(this.repository) : super(const AuthInitial());

  Future<void> register({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    // Empty-field validation
    if (email.trim().isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      emit(const AuthError('Please fill in all fields.'));
      return;
    }

    // Confirm password validation
    if (password != confirmPassword) {
      emit(const AuthError('Passwords do not match.'));
      return;
    }

    emit(const AuthLoading());

    try {
      await repository.register(
        email: email.trim(),
        password: password,
      );

      emit(const AuthSuccess());
    } catch (e) {
      emit(AuthError(_getErrorMessage(e)));
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    // Empty-field validation
    if (email.trim().isEmpty || password.isEmpty) {
      emit(const AuthError('Please enter your email and password.'));
      return;
    }

    emit(const AuthLoading());

    try {
      await repository.login(
        email: email.trim(),
        password: password,
      );

      emit(const AuthSuccess());
    } catch (e) {
      // The API uses getusercode as the login endpoint.
      // If the credentials are rejected, show a readable message.
      emit(const AuthError('Invalid email or password.'));
    }
  }

  Future<void> logout() async {
    emit(const AuthLoading());
      try {
       await Session.clearSession();
         emit(const AuthLoggedOut());
    } catch (e) {

      emit(AuthError(_getErrorMessage(e)));
    }
  }

  Future<void> checkSession() async {
    emit(const AuthLoading());

    try {
      final session = await repository.getCurrentSession();

      if (session != null) {
        emit(const AuthSessionLoaded());
      } else {
        emit(const AuthNoSession());
      }
    } catch (e) {
      emit(const AuthNoSession());
    }
  }

  String _getErrorMessage(Object error) {
    final message = error.toString();

    if (message.startsWith('Exception: ')) {
      return message.replaceFirst('Exception: ', '');
    }

    return 'Something went wrong. Please try again.';
  }
}
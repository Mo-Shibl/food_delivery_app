abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  const AuthSuccess();
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);
}

class AuthLoggedOut extends AuthState {
  const AuthLoggedOut();
}

class AuthSessionLoaded extends AuthState {
  const AuthSessionLoaded();
}

class AuthNoSession extends AuthState {
  const AuthNoSession();
}
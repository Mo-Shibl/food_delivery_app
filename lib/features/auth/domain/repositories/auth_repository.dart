import '../entities/user_session.dart';

abstract class AuthRepository {
  Future<void> register({
    required String email,
    required String password,
  });

  Future<UserSession> login({
    required String email,
    required String password,
  });

 

  Future<UserSession?> getCurrentSession();
}
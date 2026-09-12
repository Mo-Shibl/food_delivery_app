import '../../../../core/helpers/session.dart';
import '../../../../core/networking/api_result.dart';
import '../../domain/entities/user_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../services/auth_remote_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteService remoteService;

  AuthRepositoryImpl(this.remoteService);

  @override
  Future<void> register({
    required String email,
    required String password,
  }) async {
    final result = await remoteService.register(
      email: email,
      password: password,
    );

    if (result case ApiFailure(:final message)) {
      throw Exception(message);
    }
  }

  @override
  Future<UserSession> login({
    required String email,
    required String password,
  }) async {
    final result = await remoteService.login(
      email: email,
      password: password,
    );

    if (result case ApiSuccess(:final data)) {
      final session = UserSession(
        userEmail: email,
        usercode: data,
      );

      await Session.saveSession(
        email: session.userEmail,
        usercode: session.usercode,
      );

      return session;
    }

    if (result case ApiFailure(:final message)) {
      throw Exception(message);
    }

    throw Exception('Login failed');
  }


  @override
  Future<UserSession?> getCurrentSession() async {
    final hasSession = await Session.hasSession();

    if (!hasSession) {
      return null;
    }

    final email = await Session.getEmail();
    final usercode = await Session.getUsercode();

    if (email == null || usercode == null) {
      return null;
    }

    return UserSession(
      userEmail: email,
      usercode: usercode,
    );
  }
}
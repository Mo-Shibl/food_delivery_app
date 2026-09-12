import '../../domain/entities/user_session.dart';

class UserSessionModel extends UserSession {
  const UserSessionModel({
    required super.userEmail,
    required super.usercode,
  });

  factory UserSessionModel.fromJson(
    Map<String, dynamic> json, {
    required String email,
  }) {
    return UserSessionModel(
      userEmail: email,
      usercode: json['usercode'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userEmail': userEmail,
      'usercode': usercode,
    };
  }
}
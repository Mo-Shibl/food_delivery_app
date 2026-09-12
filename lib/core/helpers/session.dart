import 'package:shared_preferences/shared_preferences.dart';

class Session {
  Session._();

  static const String _emailKey = 'user_email';
  static const String _usercodeKey = 'usercode';

  static Future<void> saveSession({
    required String email,
    required String usercode,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_emailKey, email);
    await prefs.setString(_usercodeKey, usercode);
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_emailKey);
  }

  static Future<String?> getUsercode() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_usercodeKey);
  }

  static Future<bool> hasSession() async {
    final email = await getEmail();
    final usercode = await getUsercode();

    return email != null &&
        email.isNotEmpty &&
        usercode != null &&
        usercode.isNotEmpty;
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_emailKey);
    await prefs.remove(_usercodeKey);
  }
}
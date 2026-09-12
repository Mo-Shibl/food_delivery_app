import 'dart:convert';
import 'package:dio/dio.dart';

class ProfileRemoteService {
  final Dio _dio;

  ProfileRemoteService(this._dio);

  Future<void> changePassword(String usercode, String newPassword) async {
    await _dio.put(
      '/api/User/$usercode',
      data: jsonEncode(newPassword), // Safely encode the password string
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  Future<String> verifyPassword(String email, String password) async {
    final response = await _dio.get(
      '/api/User/getusercode',
      queryParameters: {
        'UserEmail': email,
        'Password': password,
      },
    );
    
    if (response.data is Map && response.data.containsKey('usercode')) {
      return response.data['usercode'] as String;
    }
    throw Exception('Invalid response from server');
  }

  Future<void> deleteAccount(String usercode) async {
    await _dio.delete('/api/User/$usercode');
  }
}

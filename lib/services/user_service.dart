import 'package:dio/dio.dart';

class UserService {
  static final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));

  static Future<bool> login(String email, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });
      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> register(
      String email, String username, String password) async {
    try {
      final response = await _dio.post('/register', data: {
        'email': email,
        'username': username,
        'password': password,
      });
      return response.statusCode == 201;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

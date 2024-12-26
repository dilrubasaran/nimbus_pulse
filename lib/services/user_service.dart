import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const String baseUrl =
      'http://localhost:5000/api'; // .NET Core API base URL

  static Future<bool> register(
      String email, String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/User/Register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> login(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/User/Login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // Token yönetimi için yardımcı metod
  static String? _token;

  static void setToken(String token) {
    _token = token;
  }

  static String? getToken() {
    return _token;
  }

  static Map<String, String> getAuthHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${getToken()}',
    };
  }
}

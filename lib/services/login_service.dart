import 'package:dio/dio.dart';
import '../core/network/dio_client.dart';
import '../core/network/api_endpoints.dart';

class LoginService {
  final DioClient _dioClient;

  LoginService(this._dioClient);

  Future<Map<String, dynamic>> login(String email, String password) async {
    print('\n=== Starting Login Process ===');

    final endpoint = ApiEndpoints.login;
    final data = {
      'email': email,
      'password': password,
    };

    try {
      print('Attempting to login...');
      print('Full URL: ${ApiEndpoints.baseUrl}$endpoint');
      print('Request Data: $data');

      final response = await _dioClient.post(
        endpoint,
        data: data,
      );

      print('\n=== Login Response ===');
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');

      // API yanıtını kontrol et
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null) {
          if (response.data is Map<String, dynamic>) {
            // Token varsa kaydet
            if (response.data['token'] != null) {
              _dioClient.setAuthToken(response.data['token']);
            }
            return response.data;
          } else if (response.data is String) {
            // Eğer yanıt string ise ve başarılı ise
            return {'message': response.data};
          }
        }
        return {'message': 'Login successful'};
      }

      // Hata durumlarını kontrol et
      if (response.statusCode == 400) {
        final errorMessage = response.data is String
            ? response.data
            : response.data?['message'] ?? 'Invalid credentials';
        throw Exception(errorMessage);
      }

      if (response.statusCode == 401) {
        throw Exception('Invalid email or password');
      }

      if (response.statusCode == 404) {
        throw Exception('User not found');
      }

      throw Exception('Login failed. Please try again.');
    } on DioException catch (e) {
      print('\n=== Login Error ===');
      print('Error Type: ${e.type}');
      print('Error Message: ${e.message}');
      print('Error Response: ${e.response}');

      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          throw Exception(
              'Connection timeout. Please check your internet connection.');
        case DioExceptionType.sendTimeout:
          throw Exception('Send timeout. Please try again later.');
        case DioExceptionType.receiveTimeout:
          throw Exception('Receive timeout. Please try again later.');
        case DioExceptionType.connectionError:
          throw Exception('Connection failed. Please check:\n'
              '1. If the API is running\n'
              '2. Your network connection\n'
              '3. Windows firewall settings');
        default:
          if (e.response?.statusCode == 400) {
            final errorMessage = e.response?.data is String
                ? e.response?.data
                : e.response?.data?['message'] ?? 'Invalid credentials';
            throw Exception(errorMessage);
          } else if (e.response?.data != null) {
            throw Exception(e.response?.data['message'] ?? 'Login failed');
          }
          throw Exception('Unexpected error: ${e.message}');
      }
    } catch (e) {
      print('\n=== Unexpected Error ===');
      print('Error Type: ${e.runtimeType}');
      print('Error Details: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }
}

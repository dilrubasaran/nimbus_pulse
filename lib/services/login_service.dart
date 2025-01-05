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
            return {'message': response.data};
          }
        }
        return {'message': 'Giriş başarılı'};
      }

      // Hata durumlarını kontrol et
      if (response.statusCode == 400) {
        final errorMessage = response.data is String
            ? response.data
            : response.data?['message'] ?? 'Geçersiz giriş bilgileri';
        throw Exception(errorMessage);
      }

      if (response.statusCode == 401) {
        throw Exception('E-posta veya şifre hatalı');
      }

      if (response.statusCode == 404) {
        throw Exception('Kullanıcı bulunamadı');
      }

      throw Exception('Giriş başarısız. Lütfen tekrar deneyin.');
    } on DioException catch (e) {
      print('\n=== Login Error ===');
      print('Error Type: ${e.type}');
      print('Error Message: ${e.message}');
      print('Error Response: ${e.response}');

      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          throw Exception(
              'Bağlantı zaman aşımına uğradı. Lütfen internet bağlantınızı kontrol edin.');
        case DioExceptionType.sendTimeout:
          throw Exception('İstek zaman aşımına uğradı. Lütfen tekrar deneyin.');
        case DioExceptionType.receiveTimeout:
          throw Exception('Yanıt zaman aşımına uğradı. Lütfen tekrar deneyin.');
        case DioExceptionType.connectionError:
          throw Exception('Bağlantı hatası. Lütfen kontrol edin:\n'
              '1. API servisinin çalışır durumda olduğunu\n'
              '2. İnternet bağlantınızı\n'
              '3. Windows güvenlik duvarı ayarlarını');
        default:
          if (e.response?.statusCode == 401) {
            throw Exception('E-posta veya şifre hatalı');
          } else if (e.response?.statusCode == 400) {
            final errorMessage = e.response?.data is String
                ? e.response?.data
                : e.response?.data?['message'] ?? 'Geçersiz giriş bilgileri';
            throw Exception(errorMessage);
          } else if (e.response?.data != null) {
            throw Exception(e.response?.data['message'] ?? 'Giriş başarısız');
          }
          throw Exception('Beklenmeyen bir hata oluştu: ${e.message}');
      }
    } catch (e) {
      print('\n=== Unexpected Error ===');
      print('Error Type: ${e.runtimeType}');
      print('Error Details: $e');
      throw Exception('Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.');
    }
  }
}

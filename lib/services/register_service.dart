import 'package:dio/dio.dart';
import '../dtos/register_dto.dart';
import '../core/network/dio_client.dart';
import '../core/network/api_endpoints.dart';

class RegisterService {
  final DioClient _dioClient;

  RegisterService(this._dioClient);

  Future<bool> register(RegisterDTO registerDTO) async {
    print('\n=== Starting Registration Process ===');

    final endpoint = ApiEndpoints.register;
    final data = registerDTO.toJson();

    try {
      print('Attempting to connect to API...');
      print('Base URL: ${ApiEndpoints.baseUrl}');
      print('Endpoint: $endpoint');
      print('Full URL: ${ApiEndpoints.baseUrl}$endpoint');
      print('Request Data: $data');

      print('\nSending registration request...');
      final response = await _dioClient.post(
        endpoint,
        data: data,
      );

      print('\n=== Registration Response ===');
      print('Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Data: ${response.data}');

      if (response.statusCode == 400) {
        final errorMessage = response.data is String
            ? response.data
            : response.data['message'] ?? 'Registration failed';
        throw Exception(errorMessage);
      }

      final isSuccess =
          response.statusCode == 200 || response.statusCode == 201;
      print('Registration ${isSuccess ? "successful" : "failed"}');

      return isSuccess;
    } on DioException catch (e) {
      print('\n=== Registration Error ===');
      print('Error Type: ${e.type}');
      print('Error Message: ${e.message}');
      print('Error Response: ${e.response}');
      print('Request URL: ${e.requestOptions.uri}');
      print('Request Headers: ${e.requestOptions.headers}');
      print('Request Data: ${e.requestOptions.data}');

      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          throw Exception(
              'Bağlantı zaman aşımına uğradı. Lütfen internet bağlantınızı kontrol edin.');
        case DioExceptionType.sendTimeout:
          throw Exception(
              'Veri gönderimi zaman aşımına uğradı. Lütfen daha sonra tekrar deneyin.');
        case DioExceptionType.receiveTimeout:
          throw Exception(
              'Sunucu yanıtı zaman aşımına uğradı. Lütfen daha sonra tekrar deneyin.');
        case DioExceptionType.connectionError:
          throw Exception(
              'API bağlantısı başarısız oldu. Lütfen şunları kontrol edin:\n'
              '1. API projesinin çalışır durumda olduğunu\n'
              '2. API endpoint\'in doğru olduğunu ($endpoint)\n'
              '3. Ağ bağlantınızın stabil olduğunu\n'
              '4. Windows güvenlik duvarı ayarlarını');
        default:
          if (e.response?.statusCode == 400) {
            final errorMessage = e.response?.data is String
                ? e.response?.data
                : e.response?.data['message'] ?? 'Validation error occurred';
            throw Exception(errorMessage);
          } else if (e.response?.data != null) {
            throw Exception(
                'API Hatası: ${e.response?.data['message'] ?? 'Kayıt işlemi başarısız oldu'}');
          }
          throw Exception('Beklenmeyen bir hata oluştu: ${e.message}');
      }
    } catch (e) {
      print('\n=== Unexpected Error ===');
      print('Error Type: ${e.runtimeType}');
      print('Error Details: $e');
      throw Exception('Beklenmeyen bir hata oluştu: $e');
    }
  }

  Future<bool> checkEmailExists(String email) async {
    try {
      final response = await _dioClient.get(
        '${ApiEndpoints.checkEmail}/$email',
      );

      return response.data['exists'] ?? false;
    } on DioException catch (e) {
      throw Exception('Email kontrolü başarısız: ${e.message}');
    }
  }

  Future<bool> validateCompany(String companyName) async {
    try {
      final response = await _dioClient.get(
        '${ApiEndpoints.validateCompany}/$companyName',
      );

      return response.data['isValid'] ?? false;
    } on DioException catch (e) {
      throw Exception('Şirket doğrulama başarısız: ${e.message}');
    }
  }
}

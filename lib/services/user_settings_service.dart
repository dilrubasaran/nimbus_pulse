import 'package:dio/dio.dart';
import '../core/network/dio_client.dart';
import '../core/network/api_endpoints.dart';
import '../dtos/settings_dto.dart';

class UserSettingsService {
  final DioClient _dioClient;

  UserSettingsService(this._dioClient);

  // Profil bilgilerini güncelleme
  Future<bool> updateProfile(
      String userId, ProfileUpdateDTO profileData) async {
    try {
      print('\n=== Updating Profile ===');
      print('User ID: $userId');
      print('Profile Data: ${profileData.toJson()}');

      final response = await _dioClient.put(
        ApiEndpoints.settingsProfile(userId),
        data: profileData.toJson(),
      );

      print('\n=== Update Profile Response ===');
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');

      if (response.statusCode == 200) {
        return true;
      }

      throw Exception('Profil güncellenemedi: ${response.statusCode}');
    } on DioException catch (e) {
      print('\n=== Update Profile Error ===');
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
          if (e.response?.statusCode == 404) {
            throw Exception('Kullanıcı bulunamadı');
          } else if (e.response?.statusCode == 400) {
            final errorMessage = e.response?.data is String
                ? e.response?.data
                : e.response?.data?['message'] ?? 'Geçersiz profil bilgileri';
            throw Exception(errorMessage);
          }
          throw Exception('Profil güncellenirken hata oluştu: ${e.message}');
      }
    } catch (e) {
      print('\n=== Unexpected Error ===');
      print('Error Type: ${e.runtimeType}');
      print('Error Details: $e');
      throw Exception('Profil güncellenirken beklenmeyen bir hata oluştu: $e');
    }
  }

  // Şifre güncelleme
  Future<bool> updatePassword(
      String userId, PasswordChangeDTO passwordData) async {
    try {
      print('Password Update Request Data:');
      print(passwordData.toJson());

      final response = await _dioClient.put(
        ApiEndpoints.settingsPassword(userId),
        data: passwordData.toJson(),
      );

      print('Password Update Response:');
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(response.data.toString());
      }
    } on DioException catch (e) {
      print('Password Update Error:');
      print('Error Type: ${e.type}');
      print('Error Message: ${e.message}');
      print('Error Response: ${e.response}');

      if (e.response?.statusCode == 404) {
        throw Exception('Kullanıcı bulunamadı');
      } else if (e.response?.statusCode == 400) {
        throw Exception(e.response?.data.toString());
      }
      rethrow;
    }
  }

  // Tema ayarlarını güncelleme
  Future<bool> updateTheme(String userId, ThemeUpdateDTO themeData) async {
    try {
      final response = await _dioClient.put(
        ApiEndpoints.settingsTheme(userId),
        data: themeData.toJson(),
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Kullanıcı veya ayarlar bulunamadı');
      }
      print('Theme update error: $e');
      rethrow;
    }
  }

  // Güvenlik kodu güncelleme
  Future<bool> updateSecurityCode(
      String userId, SecurityCodeChangeDTO securityData) async {
    try {
      final response = await _dioClient.put(
        ApiEndpoints.settingsSecurityCode(userId),
        data: securityData.toJson(),
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Kullanıcı veya ayarlar bulunamadı');
      } else if (e.response?.statusCode == 400) {
        throw Exception(e.response?.data['message'] ??
            'Güvenlik kodu güncellenirken hata oluştu');
      }
      print('Security code update error: $e');
      rethrow;
    }
  }

  // Tema ayarlarını getirme
  Future<ThemeUpdateDTO> getThemeSettings(String userId) async {
    try {
      final response = await _dioClient.get(ApiEndpoints.settingsTheme(userId));
      return ThemeUpdateDTO.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Kullanıcı veya ayarlar bulunamadı');
      }
      print('Get theme settings error: $e');
      rethrow;
    }
  }

  // Güvenlik kodunu getirme
  Future<String> getSecurityCode(String userId) async {
    try {
      print('\n=== Getting Security Code ===');
      print('User ID: $userId');
      print('Endpoint: ${ApiEndpoints.settingsSecurityCode(userId)}');

      final response = await _dioClient.get(
        ApiEndpoints.settingsSecurityCode(userId),
      );

      print('\n=== Security Code Response ===');
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        return response.data['securityCode']?.toString() ?? '';
      }

      throw Exception('Güvenlik kodu alınamadı');
    } on DioException catch (e) {
      print('\n=== Get Security Code Error ===');
      print('Error Type: ${e.type}');
      print('Error Message: ${e.message}');
      print('Error Response: ${e.response}');

      if (e.response?.statusCode == 404) {
        throw Exception('Kullanıcı veya ayarlar bulunamadı');
      }
      throw Exception('Güvenlik kodu alınamadı: ${e.message}');
    } catch (e) {
      print('\n=== Unexpected Error ===');
      print('Error Type: ${e.runtimeType}');
      print('Error Details: $e');
      throw Exception('Güvenlik kodu alınamadı: $e');
    }
  }
}

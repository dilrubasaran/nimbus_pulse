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
      final response = await _dioClient.put(
        ApiEndpoints.settingsProfile(userId),
        data: profileData.toJson(),
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Kullanıcı bulunamadı');
      }
      print('Profile update error: $e');
      rethrow;
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

  // Profil bilgilerini getirme
  Future<ProfileUpdateDTO> getProfile(String userId) async {
    try {
      print('Requesting profile data for user ID: $userId');
      print('Endpoint: ${ApiEndpoints.settingsProfile(userId)}');

      // Boş bir profil oluştur
      final emptyProfile = ProfileUpdateDTO(
        firstName: '',
        surName: '',
        email: '',
        phoneNumber: '',
        profilePictureUrl: '',
      );

      // PUT isteği yap
      final response = await _dioClient.put(
        ApiEndpoints.settingsProfile(userId),
        data: emptyProfile.toJson(),
      );

      print('Profile API Response:');
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
      print('Response Data Type: ${response.data.runtimeType}');

      if (response.statusCode == 200) {
        // Başarılı yanıt, boş profili döndür
        return emptyProfile;
      } else {
        throw Exception('Profil bilgileri alınamadı: ${response.data}');
      }
    } on DioException catch (e) {
      print('Get profile error details:');
      print('Error type: ${e.type}');
      print('Error message: ${e.message}');
      print('Error response status: ${e.response?.statusCode}');
      print('Error response data: ${e.response?.data}');
      print('Request URL: ${e.requestOptions.uri}');
      print('Request method: ${e.requestOptions.method}');

      if (e.response?.statusCode == 404) {
        throw Exception('Kullanıcı bulunamadı');
      }
      throw Exception('Profil bilgileri alınamadı: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Profil bilgileri alınamadı: $e');
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
}

class ApiEndpoints {
  static const String baseUrl = 'https://10.0.2.2:7185/api';

  // Auth endpoints
  static const String register = '/User/Register';
  static const String login = '/User/Login';
  static const String logout = '/User/Logout';
  static const String refreshToken = '/User/RefreshToken';

  // User endpoints
  static const String checkEmail = '/users/check-email';
  static const String validateCompany = '/companies/validate';
  static const String userProfile = '/users/profile';
  static const String updateProfile = '/users/profile/update';
  static const String changePassword = '/users/change-password';

  // Device endpoints
  static const String devices = '/devices';
  static const String deviceDetails = '/devices/{id}';
  static const String deviceApplications = '/devices/{id}/applications';
  static const String deviceResources = '/devices/{id}/resources';
  static const String deviceRestart = '/devices/{id}/restart';

  // Helper method to replace path parameters
  static String withParams(String endpoint, Map<String, String> params) {
    String result = endpoint;
    params.forEach((key, value) {
      result = result.replaceAll('{$key}', value);
    });
    return result;
  }
}

class ApiEndpoints {
  static const String baseUrl = 'https://10.0.2.2:7185/api';

  // Auth endpoints
  static const String register = '/user/register';
  static const String login = '/user/login';
  static const String logout = '/User/Logout';
  static const String refreshToken = '/User/RefreshToken';

  // User endpoints
  static const String checkEmail = '/user/check-email';
  static const String validateCompany = '/user/validate-company';
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/update-profile';
  static const String changePassword = '/user/change-password';

  // Device endpoints
  static const String devices = '/device';
  static const String deviceDetails = '/device/details';
  static const String deviceApplications = '/device/{id}/applications';
  static const String deviceResources = '/device/{id}/resources';
  static const String deviceRestart = '/device/{id}/restart';

  // Helper method to replace path parameters
  static String withParams(String endpoint, Map<String, String> params) {
    String result = endpoint;
    params.forEach((key, value) {
      result = result.replaceAll('{$key}', value);
    });
    return result;
  }
}

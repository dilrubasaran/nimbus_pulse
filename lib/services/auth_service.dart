// import 'package:shared_preferences.dart';
// import '../core/network/dio_client.dart';
// import '../core/network/api_endpoints.dart';

// class AuthService {
//   static const String _userIdKey = 'user_id';
//   static const String _userNameKey = 'user_name';
//   final DioClient _dioClient;

//   // Singleton pattern
//   static final AuthService _instance = AuthService._internal(DioClient());
//   factory AuthService() => _instance;
//   AuthService._internal(this._dioClient);

//   Future<void> login(String email, String password) async {
//     try {
//       final response = await _dioClient.post(
//         ApiEndpoints.login,
//         data: {
//           'email': email,
//           'password': password,
//         },
//       );

//       if (response.statusCode == 200 && response.data != null) {
//         final userId = response.data['id'].toString();
//         final userName = response.data['name'].toString();
//         await saveUserData(userId, userName);
//       } else {
//         throw Exception('Giriş başarısız');
//       }
//     } catch (e) {
//       print('Login error: $e');
//       rethrow;
//     }
//   }

//   Future<void> logout() async {
//     try {
//       await _dioClient.post(ApiEndpoints.logout);
//       await clearUserData();
//     } catch (e) {
//       print('Logout error: $e');
//       rethrow;
//     }
//   }

//   Future<void> saveUserData(String userId, String userName) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_userIdKey, userId);
//     await prefs.setString(_userNameKey, userName);
//   }

//   Future<String?> getUserId() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_userIdKey);
//   }

//   Future<String?> getUserName() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_userNameKey);
//   }

//   Future<void> clearUserData() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_userIdKey);
//     await prefs.remove(_userNameKey);
//   }

//   Future<bool> isAuthenticated() async {
//     final userId = await getUserId();
//     return userId != null;
//   }
// }

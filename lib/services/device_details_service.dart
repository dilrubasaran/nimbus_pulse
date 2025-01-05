import 'package:dio/dio.dart';
import '../core/network/dio_client.dart';
import '../core/network/api_endpoints.dart';
import '../dtos/device_details_dto.dart';

class DeviceDetailsService {
  final DioClient _dioClient;

  DeviceDetailsService(this._dioClient);

  Future<DeviceDetailsDTO> getDeviceDetails(String deviceId) async {
    try {
      print('\n=== Getting Device Details ===');
      print('Requesting Device ID: $deviceId');
      final url = '/Device/details/$deviceId';
      print('Request URL: $url');

      final response = await _dioClient.get(url);

      print('Response Status: ${response.statusCode}');
      print('Response Data: ${response.data}');

      if (response.statusCode == 200) {
        return DeviceDetailsDTO.fromJson(response.data);
      }

      throw Exception('Failed to load device details');
    } on DioException catch (e) {
      print('\n=== Device Details Error ===');
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
          if (e.response?.statusCode == 404) {
            throw Exception('Device not found');
          } else if (e.response?.data != null) {
            throw Exception(
                e.response?.data['message'] ?? 'Failed to load device details');
          }
          throw Exception('Unexpected error: ${e.message}');
      }
    } catch (e) {
      print('\n=== Unexpected Error ===');
      print('Error Type: ${e.runtimeType}');
      print('Error Details: $e');
      throw Exception('Cihaz kapalı veya detay bilgileri yok');
    }
  }

  Future<bool> updateDeviceDetails(
      String deviceId, DeviceDetailsDTO details) async {
    try {
      print('\n=== Updating Device Details ===');
      final response = await _dioClient.put(
        '/Device/$deviceId/details',
        data: details.toJson(),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('\n=== Update Device Details Error ===');
      print('Error Details: $e');
      rethrow;
    }
  }
}

import 'package:dio/dio.dart';
import '../core/network/dio_client.dart';
import '../core/network/api_endpoints.dart';
import '../dtos/device_dto.dart';

class ServerService {
  final DioClient _dioClient;

  ServerService(this._dioClient);

  Future<List<DeviceDTO>> getDevices() async {
    try {
      print('\n=== Getting Devices ===');
      final response = await _dioClient.get(ApiEndpoints.devices);

      print('Response Status: ${response.statusCode}');
      print('Response Data: ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> devicesJson = response.data;
        return devicesJson.map((json) => DeviceDTO.fromJson(json)).toList();
      }

      throw Exception('Failed to load devices');
    } on DioException catch (e) {
      print('\n=== Device Fetch Error ===');
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
            throw Exception(e.response?.data['message'] ?? 'Bad request');
          } else if (e.response?.data != null) {
            throw Exception(
                e.response?.data['message'] ?? 'Failed to load devices');
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

  Future<DeviceDTO> addDevice(DeviceDTO device) async {
    try {
      print('\n=== Adding Device ===');
      final response = await _dioClient.post(
        ApiEndpoints.devices,
        data: device.toJson(),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Data: ${response.data}');

      if (response.statusCode == 201) {
        return DeviceDTO.fromJson(response.data);
      }

      throw Exception('Failed to add device');
    } catch (e) {
      print('\n=== Add Device Error ===');
      print('Error Details: $e');
      rethrow;
    }
  }

  Future<bool> deleteDevice(int deviceId) async {
    try {
      print('\n=== Deleting Device ===');
      final response = await _dioClient.delete('/Device/$deviceId');

      print('Response Status: ${response.statusCode}');
      if (response.statusCode == 204 || response.statusCode == 200) {
        return true;
      }
      throw Exception('Failed to delete device');
    } catch (e) {
      print('\n=== Delete Device Error ===');
      print('Error Details: $e');
      rethrow;
    }
  }

  Future<DeviceDTO> getDeviceDetails(String deviceId) async {
    try {
      print('\n=== Getting Device Details ===');
      final response = await _dioClient.get(
        '${ApiEndpoints.deviceDetails}/$deviceId',
      );

      print('Response Status: ${response.statusCode}');
      print('Response Data: ${response.data}');

      if (response.statusCode == 200) {
        return DeviceDTO.fromJson(response.data);
      }

      throw Exception('Failed to load device details');
    } catch (e) {
      print('\n=== Device Details Error ===');
      print('Error Details: $e');
      rethrow;
    }
  }

  Future<bool> restartDevice(String deviceId) async {
    try {
      print('\n=== Restarting Device ===');
      final response = await _dioClient.post(
        ApiEndpoints.withParams(ApiEndpoints.deviceRestart, {'id': deviceId}),
      );

      print('Response Status: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('\n=== Restart Device Error ===');
      print('Error Details: $e');
      rethrow;
    }
  }

  Future<List<DeviceDTO>> getDevicesOrdered(String orderBy) async {
    try {
      final response = await _dioClient.get('/Device/order/$orderBy');
      return (response.data as List)
          .map((json) => DeviceDTO.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load ordered devices: $e');
    }
  }
}

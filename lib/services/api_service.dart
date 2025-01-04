import 'dart:convert';
import 'package:http/http.dart' as http;
import '../dtos/device_dto.dart';
import '../dtos/application_dto.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5166/api';

  // Tüm cihazları getir
  Future<List<DeviceDTO>> getDevices() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/devices'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => DeviceDTO.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load devices');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  // Cihaz detaylarını getir
  Future<DeviceDTO> getDeviceDetails(String deviceId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/devices/$deviceId'));

      if (response.statusCode == 200) {
        return DeviceDTO.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load device details');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  // Yeni cihaz ekle
  Future<DeviceDTO> addDevice(DeviceDTO device) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/devices'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(device.toJson()),
      );

      if (response.statusCode == 201) {
        return DeviceDTO.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to add device');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  // Cihaz güncelle
  Future<DeviceDTO> updateDevice(String deviceId, DeviceDTO device) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/devices/$deviceId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(device.toJson()),
      );

      if (response.statusCode == 200) {
        return DeviceDTO.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update device');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  // Cihaz sil
  Future<bool> deleteDevice(String deviceId) async {
    try {
      final response =
          await http.delete(Uri.parse('$baseUrl/devices/$deviceId'));
      return response.statusCode == 204;
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  // Çalışan uygulamaları getir
  Future<List<ApplicationDTO>> getRunningApplications(String deviceId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/devices/$deviceId/applications'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ApplicationDTO.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load running applications');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  // Cihazı yeniden başlat
  Future<bool> restartDevice(String deviceId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/devices/$deviceId/restart'),
      );
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error restarting device: $e');
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/device.dart';

class ApiService {
  static const String baseUrl =
      'https://api.nimbuspulse.com/api'; // API base URL'inizi buraya ekleyin

  // Cihaz detaylarını getir
  Future<Map<String, dynamic>> getDeviceDetails(String deviceId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/devices/$deviceId'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load device details');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  // Kaynak kullanım verilerini getir
  Future<Map<String, List<dynamic>>> getResourceUsage(String deviceId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/devices/$deviceId/resources'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load resource usage');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  // Çalışan uygulamaları getir
  Future<List<dynamic>> getRunningApplications(String deviceId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/devices/$deviceId/applications'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load running applications');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  // Aktif uygulamaları getir
  Future<List<dynamic>> getActiveApplications(String deviceId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/devices/$deviceId/active-applications'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load active applications');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  // Cihazı yeniden başlat
  Future<bool> restartDevice(String deviceId) async {
    try {
      final response =
          await http.post(Uri.parse('$baseUrl/devices/$deviceId/restart'));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error restarting device: $e');
    }
  }
}

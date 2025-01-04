import 'package:dio/dio.dart';
import 'api_endpoints.dart';
import 'package:dio/io.dart';

class DioClient {
  late Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        validateStatus: (status) {
          return status! < 500;
        },
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // SSL sertifika doğrulamasını devre dışı bırak
    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };

    // İnterceptors
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
      logPrint: (object) {
        print('DIO LOG: $object');
      },
    ));

    // Retry interceptor ekle
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, handler) async {
          if (e.type == DioExceptionType.connectionError) {
            // Bağlantı hatası durumunda 3 kez tekrar dene
            for (var i = 0; i < 3; i++) {
              try {
                print('Retrying request attempt ${i + 1}');
                final response = await _dio.request(
                  e.requestOptions.path,
                  data: e.requestOptions.data,
                  options: Options(
                    method: e.requestOptions.method,
                    headers: e.requestOptions.headers,
                  ),
                );
                return handler.resolve(response);
              } catch (e) {
                if (i == 2) handler.reject(e as DioException);
              }
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  // GET isteği
  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // POST isteği
  Future<Response> post(String path, {dynamic data, Options? options}) async {
    try {
      final response = await _dio.post(path, data: data, options: options);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // PUT isteği
  Future<Response> put(String path, {dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // DELETE isteği
  Future<Response> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Token eklemek için
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Token kaldırmak için
  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio dio;

  ApiService()
      : dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.jestycrm.com',
      headers: {'Content-Type': 'application/json'},
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  ) {
    // 🔹 Add interceptor to attach token + log all requests
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Load token from SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          print('📤 [${options.method}] ${options.uri}');
          print('🔑 Token: ${token != null ? "Attached ✅" : "Missing ❌"}');
          print('📦 Body: ${options.data}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          print('⬅️ [${response.statusCode}] ${response.requestOptions.uri}');
          print('📨 Response: ${response.data}');
          handler.next(response);
        },
        onError: (e, handler) {
          print('❌ [Error ${e.response?.statusCode}] ${e.requestOptions.uri}');
          print('📭 Details: ${e.response?.data ?? e.message}');
          handler.next(e);
        },
      ),
    );
  }
}

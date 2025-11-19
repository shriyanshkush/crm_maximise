import 'package:dio/dio.dart';
import '../../features/auth/services/auth_local_storage.dart'; // adjust path if needed

class ApiService {
  final Dio dio;
  final AuthLocalStorage _authStorage = AuthLocalStorage();

  ApiService()
      : dio = Dio(
    BaseOptions(
      baseUrl: 'https://test.api.jestycrm.com',
      headers: {'Content-Type': 'application/json'},
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // ✅ Load token from shared AuthLocalStorage
          final token = await _authStorage.getToken();

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          print('📤 [${options.method}] ${options.uri}');
          print('🔑 Token: ${token != null ? "Attached ✅" : "Missing ❌"}');
          if (options.data != null) print('📦 Body: ${options.data}');

          handler.next(options);
        },
        onResponse: (response, handler) {
          print('⬅️ [${response.statusCode}] ${response.requestOptions.uri}');
          print('📨 Response: ${response.data}');
          handler.next(response);
        },
        onError: (DioException e, handler) async {
          print('❌ [Error ${e.response?.statusCode}] ${e.requestOptions.uri}');
          print('📭 Details: ${e.response?.data ?? e.message}');

          // ✅ Optional: handle token expiration
          if (e.response?.statusCode == 401) {
            final refreshed = await _tryRefreshToken();
            if (refreshed) {
              // Retry original request
              final token = await _authStorage.getToken();
              e.requestOptions.headers['Authorization'] = 'Bearer $token';
              final cloneReq = await dio.fetch(e.requestOptions);
              return handler.resolve(cloneReq);
            }
          }

          handler.next(e);
        },
      ),
    );
  }

  /// ✅ Optional: Auto token refresh logic
  Future<bool> _tryRefreshToken() async {
    try {
      final user = await _authStorage.getUser();
      if (user == null || user.refreshToken.isEmpty) return false;

      print('🔄 Refreshing token...');
      final response = await dio.post(
        '/auth/api/refresh-token',
        data: {'refreshToken': user.refreshToken},
      );

      final newToken = response.data['accessToken'];
      if (newToken != null && newToken.isNotEmpty) {
        await _authStorage.saveToken(newToken);
        print('✅ Token refreshed successfully');
        return true;
      }
    } catch (e) {
      print('❌ Token refresh failed: $e');
    }
    return false;
  }
}

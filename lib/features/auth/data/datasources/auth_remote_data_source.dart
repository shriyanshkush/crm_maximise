import 'package:dio/dio.dart';
import '../models/user_model.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';


abstract class AuthRemoteDataSource {
  Future<void> sendOtp(String email, String action);
  Future<UserModel> login(String email, String otp);
  Future<UserModel> register(String email, String otp, String name);
  Future<String> getGoogleAuthUrl();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  AuthRemoteDataSourceImpl(this.dio);

  // 📨 SEND OTP
  @override
  Future<void> sendOtp(String email, String action) async {
    try {
      print('📤 Sending OTP request => email: $email | action: $action');

      final response = await dio.post(
        '/auth/api/auth/send-otp',
        data: {
          'email': email,
          'action': action,
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
      );

      print('📨 OTP Response: ${response.data}');

      if (response.statusCode == 200 && response.data['success'] == true) {
        print('✅ OTP sent successfully');
        return;
      } else {
        throw Exception(response.data['message'] ?? 'Unknown error');
      }
    } on DioException catch (e) {
      print('❌ Dio Error (sendOtp): ${e.response?.data ?? e.message}');
      rethrow;
    } catch (e) {
      print('❌ General Error (sendOtp): $e');
      rethrow;
    }
  }

  // 🔐 LOGIN
  @override
  Future<UserModel> login(String email, String otp) async {
    try {
      print('📤 Logging in => email: $email | otp: $otp');

      final response = await dio.post(
        '/auth/api/auth/login',
        data: {
          'email': email,
          'otp': otp,
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
      );

      print('📨 Login Response: ${response.data}');

      if (response.statusCode == 200 && response.data['success'] == true) {
        print('✅ Login successful');
        return UserModel.fromJson(response.data);
      } else {
        throw Exception(response.data['message'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      print('❌ Dio Error (login): ${e.response?.data ?? e.message}');
      rethrow;
    } catch (e) {
      print('❌ General Error (login): $e');
      rethrow;
    }
  }

  // 🆕 REGISTER
  @override
  Future<UserModel> register(String email, String otp, String name) async {
    try {
      print('📤 Registering user => email: $email | otp: $otp | name: $name');

      final response = await dio.post(
        '/auth/api/auth/register',
        data: {
          'email': email,
          'otp': otp,
          'name': name,
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
      );

      print('📨 Register Response: ${response.data}');

      final data = response.data;

      // ✅ Validate structure first
      if (data is Map<String, dynamic> &&
          data['success'] == true &&
          data.containsKey('user')) {
        print('✅ Registration successful');
        return UserModel.fromJson(data);
      } else {
        final message = data['message'] ?? 'Unknown error';
        print('❌ Registration failed: $message');
        throw Exception(message);
      }
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? e.response?.data['message']
          : e.message;
      print('❌ Dio Error (register): $msg');
      rethrow;
    } catch (e) {
      print('❌ General Error (register): $e');
      rethrow;
    }
  }


  // 🔗 GET GOOGLE AUTH URL
  @override
  Future<String> getGoogleAuthUrl() async {
    try {
      print('🌐 Requesting Google OAuth URL...');

      final response = await dio.get(
        '/auth/api/oauth/google/url',
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
      );

      print('📨 Google URL Response: ${response.data}');

      if (response.statusCode == 200 && response.data['success'] == true) {
        print('✅ Google Auth URL retrieved');
        return response.data['authUrl'];
      } else {
        throw Exception(response.data['message'] ?? 'Failed to get auth URL');
      }
    } on DioException catch (e) {
      print('❌ Dio Error (getGoogleAuthUrl): ${e.response?.data ?? e.message}');
      rethrow;
    } catch (e) {
      print('❌ General Error (getGoogleAuthUrl): $e');
      rethrow;
    }
  }
}

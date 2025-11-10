import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<void> sendOtp(String email, String action);
  Future<UserEntity> login(String email, String otp);
  Future<UserEntity> register(String email, String otp,String name);
  Future<String> getGoogleAuthUrl();
}

// features/auth/data/repositories/auth_repository_impl.dart
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  AuthRepositoryImpl(this.remote);

  @override
  Future<void> sendOtp(String email, String action) =>
      remote.sendOtp(email, action);

  @override
  Future<UserEntity> login(String email, String otp) => remote.login(email, otp);

  @override
  Future<UserEntity> register(String email, String otp, String name) =>
      remote.register(email, otp,name);

  @override
  Future<String> getGoogleAuthUrl() => remote.getGoogleAuthUrl();
}

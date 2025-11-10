import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.accessToken,
    required super.refreshToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    final tokens = json['tokens'];
    return UserModel(
      id: user['id'] ?? '',
      email: user['email'] ?? '',
      name: user['name'] ?? '',
      accessToken: tokens['accessToken'] ?? '',
      refreshToken: tokens['refreshToken'] ?? '',
    );
  }
}

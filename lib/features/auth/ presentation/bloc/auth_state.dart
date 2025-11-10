import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// 🔹 Initial
class AuthInitial extends AuthState {}

// 🔹 While API is loading
class AuthLoading extends AuthState {}

// 🔹 OTP successfully sent
class OtpSent extends AuthState {}

// 🔹 Authentication successful
class AuthSuccess extends AuthState {
  final UserEntity user;

  const AuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

// 🔹 Google OAuth URL retrieved
class GoogleUrlLoaded extends AuthState {
  final String url;

  const GoogleUrlLoaded(this.url);

  @override
  List<Object?> get props => [url];
}

// 🔹 Logout successful
class AuthLoggedOut extends AuthState {}

// 🔹 Authentication error
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

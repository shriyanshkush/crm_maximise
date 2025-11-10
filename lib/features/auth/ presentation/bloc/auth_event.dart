// lib/features/auth/presentation/bloc/auth_event.dart
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SendOtpEvent extends AuthEvent {
  final String email;
  final String action;
  const SendOtpEvent({required this.email, required this.action});
  @override
  List<Object?> get props => [email, action];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String otp;
  const LoginEvent({required this.email, required this.otp});
  @override
  List<Object?> get props => [email, otp];
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String otp;
  final String name;

  const RegisterEvent({
    required this.email,
    required this.otp,
    required this.name,
  });

  @override
  List<Object?> get props => [email, otp, name];
}


class GetGoogleUrlEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}

/// ✅ ADD THIS:
class CheckAuthStatusEvent extends AuthEvent {}

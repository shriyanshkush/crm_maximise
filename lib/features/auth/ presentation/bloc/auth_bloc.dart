import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../services/auth_local_storage.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repo;
  final AuthLocalStorage localStorage;

  AuthBloc(this.repo, this.localStorage) : super(AuthInitial()) {
    // 🔹 Send OTP
    on<SendOtpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await repo.sendOtp(event.email, event.action);
        emit(OtpSent());
      } catch (e) {
        emit(AuthError("Failed to send OTP"));
      }
    });

    on<CheckAuthStatusEvent>((event, emit) async {
      final token = await localStorage.getToken();
      if (token != null && token.isNotEmpty) {
        emit(AuthSuccess(
          UserEntity(
            id: '',
            email: '',
            name: '',
            accessToken: token,
            refreshToken: '',
          ),
        ));
      } else {
        emit(AuthLoggedOut());
      }
    });


    // 🔹 Login
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await repo.login(event.email, event.otp);
        await localStorage.saveToken(user.accessToken);
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthError("Invalid OTP or server error"));
      }
    });

    // 🔹 Register
    on<RegisterEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await repo.register(event.email, event.otp, event.name);
        await localStorage.saveToken(user.accessToken);
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthError("Failed to register user"));
      }
    });

    // 🔹 Google Auth URL
    on<GetGoogleUrlEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final url = await repo.getGoogleAuthUrl();
        emit(GoogleUrlLoaded(url));
      } catch (e) {
        emit(AuthError("Failed to fetch Google login URL"));
      }
    });

    // 🔹 Logout
    on<LogoutEvent>((event, emit) async {
      await localStorage.clearToken();
      emit(AuthLoggedOut());
    });
  }
}

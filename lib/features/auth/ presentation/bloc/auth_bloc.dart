import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../services/auth_local_storage.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repo;
  final AuthLocalStorage localStorage;
  
  // 🧪 TEST MODE - Set to true to skip API calls
  static const bool testMode = true;

  AuthBloc(this.repo, this.localStorage) : super(AuthInitial()) {
    // 🔹 Send OTP
    on<SendOtpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        if (testMode) {
          // Skip API call in test mode
          print('🧪 TEST MODE: Skipping OTP send');
          await Future.delayed(const Duration(milliseconds: 500));
          emit(OtpSent());
          return;
        }
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
        if (testMode) {
          // Skip API call in test mode
          print('🧪 TEST MODE: Skipping login API');
          await Future.delayed(const Duration(milliseconds: 500));
          
          final mockUser = UserEntity(
            id: 'test-user-123',
            email: event.email,
            name: 'Test User',
            accessToken: 'mock-token-${DateTime.now().millisecondsSinceEpoch}',
            refreshToken: 'mock-refresh-token',
          );
          
          await localStorage.saveToken(mockUser.accessToken);
          emit(AuthSuccess(mockUser));
          return;
        }
        
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
        if (testMode) {
          // Skip API call in test mode
          print('🧪 TEST MODE: Skipping register API');
          await Future.delayed(const Duration(milliseconds: 500));
          
          final mockUser = UserEntity(
            id: 'test-user-${DateTime.now().millisecondsSinceEpoch}',
            email: event.email,
            name: event.name,
            accessToken: 'mock-token-${DateTime.now().millisecondsSinceEpoch}',
            refreshToken: 'mock-refresh-token',
          );
          
          await localStorage.saveToken(mockUser.accessToken);
          emit(AuthSuccess(mockUser));
          return;
        }
        
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

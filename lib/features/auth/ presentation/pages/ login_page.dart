import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_routes.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'otp_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  bool isRegister = false; // 🔹 toggle between login/register
  final nameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpSent) {
            // Go to OTP page and pass whether it's register or login
            context.push(
              AppRoutes.otp,
              extra: {
                'email': emailController.text.trim(),
                'isRegister': isRegister,
                'name': nameController.text.trim(), // ✅ added
              },
            );

          } else if (state is GoogleUrlLoaded) {
            launchUrl(Uri.parse(state.url),
                mode: LaunchMode.externalApplication);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is AuthSuccess) {
            context.go(AppRoutes.home);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FlutterLogo(size: 80),
                const SizedBox(height: 24),
                Text(
                  isRegister ? "Create Account 👋" : "Welcome Back 👋",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                if (isRegister) ...[
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                if (state is AuthLoading)
                  const CircularProgressIndicator()
                else ...[
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        SendOtpEvent(
                          email: emailController.text.trim(),
                          action: isRegister ? "register" : "login",
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: Text(isRegister ? "Register" : "Send OTP"),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.g_mobiledata, size: 32),
                    label: const Text("Continue with Google"),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    onPressed: () =>
                        context.read<AuthBloc>().add(GetGoogleUrlEvent()),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isRegister = !isRegister;
                      });
                    },
                    child: Text(
                      isRegister
                          ? "Already have an account? Login"
                          : "New user? Register here",
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../core/constants/app_routes.dart';
// import '../../services/auth_local_storage.dart';
// import '../bloc/auth_bloc.dart';
// import '../bloc/auth_event.dart';
// import '../bloc/auth_state.dart';
// import 'otp_page.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:go_router/go_router.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final emailController = TextEditingController();
//   bool isRegister = false; // 🔹 toggle between login/register
//   final nameController = TextEditingController();
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocConsumer<AuthBloc, AuthState>(
//         listener: (context, state) async {
//           if (state is OtpSent) {
//             // Go to OTP page and pass whether it's register or login
//             context.push(
//               AppRoutes.otp,
//               extra: {
//                 'email': emailController.text.trim(),
//                 'isRegister': isRegister,
//                 'name': nameController.text.trim(), // ✅ added
//               },
//             );
//
//           } else if (state is GoogleUrlLoaded) {
//             launchUrl(Uri.parse(state.url),
//                 mode: LaunchMode.externalApplication);
//           } else if (state is AuthError) {
//             ScaffoldMessenger.of(context)
//                 .showSnackBar(SnackBar(content: Text(state.message)));
//           } else if (state is AuthSuccess) {
//             final storage = AuthLocalStorage();
//             await storage.saveUser(state.user); // ✅ store user
//             await storage.saveToken(state.user.accessToken);
//
//             context.go(AppRoutes.home, extra: state.user); // ✅ pass user properly
//           }
//
//         },
//         builder: (context, state) {
//           return Padding(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const FlutterLogo(size: 80),
//                 const SizedBox(height: 24),
//                 Text(
//                   isRegister ? "Create Account 👋" : "Welcome Back 👋",
//                   style: const TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 TextField(
//                   controller: emailController,
//                   decoration: const InputDecoration(
//                     labelText: 'Email Address',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//
//                 if (isRegister) ...[
//                   TextField(
//                     controller: nameController,
//                     decoration: const InputDecoration(
//                       labelText: 'Full Name',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                 ],
//
//                 if (state is AuthLoading)
//                   const CircularProgressIndicator()
//                 else ...[
//                   ElevatedButton(
//                     onPressed: () {
//                       context.read<AuthBloc>().add(
//                         SendOtpEvent(
//                           email: emailController.text.trim(),
//                           action: isRegister ? "register" : "login",
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: const Size(double.infinity, 48),
//                     ),
//                     child: Text(isRegister ? "Register" : "Send OTP"),
//                   ),
//                   const SizedBox(height: 16),
//                   OutlinedButton.icon(
//                     icon: const Icon(Icons.g_mobiledata, size: 32),
//                     label: const Text("Continue with Google"),
//                     style: OutlinedButton.styleFrom(
//                       minimumSize: const Size(double.infinity, 48),
//                     ),
//                     onPressed: () =>
//                         context.read<AuthBloc>().add(GetGoogleUrlEvent()),
//                   ),
//                   const SizedBox(height: 16),
//                   TextButton(
//                     onPressed: () {
//                       setState(() {
//                         isRegister = !isRegister;
//                       });
//                     },
//                     child: Text(
//                       isRegister
//                           ? "Already have an account? Login"
//                           : "New user? Register here",
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool isSignUp = false;

  // Mapped styles
  TextStyle get titleStyle => AppTextStyles.headlineLarge.copyWith(color: Colors.white);
  TextStyle get bodyStyle => AppTextStyles.bodyLarge.copyWith(color: const Color(0xFF1C1C1C));
  TextStyle get hintStyle => AppTextStyles.bodySmall.copyWith(color: Colors.grey[400]);
  TextStyle get subheadlineWhite => AppTextStyles.bodySmall.copyWith(color: Colors.white);
  TextStyle get captionStyle => AppTextStyles.bodySmall.copyWith(fontSize: 12, color: Colors.white.withOpacity(.85));
  TextStyle get buttonLabelBlue => AppTextStyles.button.copyWith(
    fontSize: 17,
    color: const Color(0xFF056BE3),
    fontWeight: FontWeight.w600,
  );
  TextStyle get whiteUnderline => AppTextStyles.bodySmall.copyWith(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    decoration: TextDecoration.underline,
  );

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpSent) {
            context.push(
              AppRoutes.otp,
              extra: {
                'email': emailController.text.trim(),
                'isRegister': isSignUp,
                'name': nameController.text.trim(),
              },
            );
          } else if (state is GoogleUrlLoaded) {
            launchUrl(Uri.parse(state.url), mode: LaunchMode.externalApplication);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red[700],
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is AuthSuccess) {
            context.go(AppRoutes.home);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                // ---------------------------------------------
                // TOP HERO SECTION
                // ---------------------------------------------
                Expanded(
                  flex: 45,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFF8FBFF),
                          Colors.white,
                        ],
                      ),
                    ),
                    child: Center(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Image.asset('assets/icons/image.png'),
                        ),
                      ),
                    ),
                  ),
                ),

                // ---------------------------------------------
                // BOTTOM AUTH CARD
                // ---------------------------------------------
                Expanded(
                  flex: 55,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF056BE3),
                          const Color(0xFF0349A8),
                          const Color(0xFF023A8C).withOpacity(.95),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF056BE3).withOpacity(.3),
                          blurRadius: 24,
                          offset: const Offset(0, -8),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //-------------------------------------
                          // TITLE
                          //-------------------------------------
                          Text(isSignUp ? 'Create Account' : 'Log in or sign up', style: titleStyle),
                          const SizedBox(height: 28),

                          //-------------------------------------
                          // NAME (SIGNUP)
                          //-------------------------------------
                          if (isSignUp) ...[
                            _buildInputField(
                              controller: nameController,
                              hint: "Enter Full Name",
                              icon: Icons.person_outline,
                            ),
                            const SizedBox(height: 16),
                          ],

                          //-------------------------------------
                          // EMAIL
                          //-------------------------------------
                          _buildInputField(
                            controller: emailController,
                            hint: "Enter Email Address",
                            icon: Icons.email_outlined,
                            keyboard: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: 20),

                          //-------------------------------------
                          // CONTINUE / SIGNUP BUTTON
                          //-------------------------------------
                          SizedBox(
                            height: 56,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: state is AuthLoading
                                  ? null
                                  : () {
                                if (emailController.text.trim().isEmpty) {
                                  _showError("Please enter your email");
                                  return;
                                }
                                if (isSignUp && nameController.text.trim().isEmpty) {
                                  _showError("Please enter your name");
                                  return;
                                }
                                context.read<AuthBloc>().add(
                                  SendOtpEvent(
                                    email: emailController.text.trim(),
                                    action: isSignUp ? "register" : "login",
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF056BE3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: state is AuthLoading
                                  ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation(Color(0xFF056BE3)),
                                ),
                              )
                                  : Text(
                                isSignUp ? "Send OTP" : "Continue",
                                style: buttonLabelBlue,
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          //-------------------------------------
                          // OR DIVIDER
                          //-------------------------------------
                          Row(
                            children: [
                              Expanded(child: Divider(color: Colors.white.withOpacity(0.3))),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Text("or", style: subheadlineWhite),
                              ),
                              Expanded(child: Divider(color: Colors.white.withOpacity(0.3))),
                            ],
                          ),

                          const SizedBox(height: 28),

                          //-------------------------------------
                          // GOOGLE BUTTON
                          //-------------------------------------
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildSocialButton(
                                onTap: () => context.read<AuthBloc>().add(GetGoogleUrlEvent()),
                                child: Image.asset(
                                  'assets/icons/google.png',
                                  width: 28,
                                  height: 28,
                                  errorBuilder: (_, __, ___) => const FaIcon(
                                    FontAwesomeIcons.google,
                                    color: Color(0xFF4285F4),
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          //-------------------------------------
                          // TOGGLE LOGIN / SIGNUP
                          //-------------------------------------
                          Center(
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  isSignUp = !isSignUp;
                                  nameController.clear();
                                  emailController.clear();
                                });
                              },
                              child: RichText(
                                text: TextSpan(
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: Colors.white.withOpacity(.9),
                                  ),
                                  children: [
                                    TextSpan(text: isSignUp ? "Already have an account? " : "Don't have an account? "),
                                    TextSpan(text: isSignUp ? "Log in" : "Sign up", style: whiteUnderline),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          //-------------------------------------
                          // TERMS
                          //-------------------------------------
                          Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: captionStyle,
                                children: [
                                  const TextSpan(text: "By continuing, you agree to our\n"),
                                  TextSpan(text: "Terms of Service", style: whiteUnderline),
                                  const TextSpan(text: "  "),
                                  TextSpan(text: "Privacy Policy", style: whiteUnderline),
                                  const TextSpan(text: "  "),
                                  TextSpan(text: "Content Policies", style: whiteUnderline),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // -------------------------------------------------------
  // INPUT FIELD BUILDER
  // -------------------------------------------------------
  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboard = TextInputType.name,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.03), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        style: bodyStyle,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: hintStyle,
          prefixIcon: Icon(icon, size: 22, color: Colors.grey[600]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // SOCIAL BUTTON
  // -------------------------------------------------------
  Widget _buildSocialButton({required VoidCallback onTap, required Widget child}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[300]!, width: 1.5),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.03), blurRadius: 10, offset: const Offset(0, 2)),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}

// CUSTOM LOGO PAINTER ------------------------------------
class JLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1C1C1C)
      ..style = PaintingStyle.fill;

    final path = Path();
    final w = size.width;
    final h = size.height;

    path.moveTo(w * 0.65, h * 0.2);
    path.lineTo(w * 0.65, h * 0.65);
    path.quadraticBezierTo(w * 0.65, h * 0.85, w * 0.45, h * 0.85);
    path.quadraticBezierTo(w * 0.25, h * 0.85, w * 0.25, h * 0.65);
    path.lineTo(w * 0.25, h * 0.58);
    path.quadraticBezierTo(w * 0.25, h * 0.73, w * 0.40, h * 0.73);
    path.quadraticBezierTo(w * 0.53, h * 0.73, w * 0.53, h * 0.65);
    path.lineTo(w * 0.53, h * 0.2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

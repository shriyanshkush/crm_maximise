import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/ios_typography.dart';
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
  bool isSignUp = false; // Toggle between login and signup

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
    final size = MediaQuery.of(context).size;
    
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
            launchUrl(Uri.parse(state.url),
                mode: LaunchMode.externalApplication);
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
                // Top section with premium gradient
                Expanded(
                  flex: 45,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFF8FBFF), // Very light blue
                          Color(0xFFFFFFFF), // White
                        ],
                      ),
                    ),
                    child: Center(
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Image.asset(
                                'assets/icons/image.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                  ),
                ),
                // Bottom section with premium iOS-style gradient
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
                          const Color(0xFF023A8C).withOpacity(0.95),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF056BE3).withOpacity(0.3),
                          blurRadius: 24,
                          offset: const Offset(0, -8),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            isSignUp ? 'Create Account' : 'Log in or sign up',
                            style: IOSTypography.title1(
                              color: Colors.white,
                              weight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 28),
                          
                          // Name input field (only for signup)
                          if (isSignUp) ...[
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: nameController,
                                keyboardType: TextInputType.name,
                                textCapitalization: TextCapitalization.words,
                                style: IOSTypography.body(
                                  color: const Color(0xFF1C1C1C),
                                  weight: FontWeight.w400,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Enter Full Name',
                                  hintStyle: IOSTypography.body(
                                    color: Colors.grey[400]!,
                                    weight: FontWeight.w400,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.person_outline,
                                    color: Colors.grey[600],
                                    size: 22,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 18,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          
                          // Email input field
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: IOSTypography.body(
                                color: const Color(0xFF1C1C1C),
                                weight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter Email Address',
                                hintStyle: IOSTypography.body(
                                  color: Colors.grey[400]!,
                                  weight: FontWeight.w400,
                                ),
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: Colors.grey[600],
                                  size: 22,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Continue button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: state is AuthLoading
                                  ? null
                                  : () {
                                      if (emailController.text.trim().isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Please enter your email',
                                              style: IOSTypography.subheadline(color: Colors.white),
                                            ),
                                            backgroundColor: Colors.red[700],
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                        return;
                                      }
                                      if (isSignUp && nameController.text.trim().isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Please enter your name',
                                              style: IOSTypography.subheadline(color: Colors.white),
                                            ),
                                            backgroundColor: Colors.red[700],
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
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
                                shadowColor: Colors.transparent,
                              ),
                              child: state is AuthLoading
                                    ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Color(0xFF056BE3),
                                        ),
                                      ),
                                    )
                                  : Text(
                                      isSignUp ? 'Send OTP' : 'Continue',
                                      style: IOSTypography.headline(
                                        color: const Color(0xFF056BE3),
                                        weight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          
                          // OR divider
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  'or',
                                  style: IOSTypography.subheadline(
                                    color: Colors.white,
                                    weight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          
                          // Social login buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Google button
                              _buildSocialButton(
                                onTap: () {
                                  context.read<AuthBloc>().add(GetGoogleUrlEvent());
                                },
                                child: Image.asset(
                                  'assets/icons/google.png',
                                  width: 28,
                                  height: 28,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    // Fallback to FontAwesome icon if image not found
                                    return const FaIcon(
                                      FontAwesomeIcons.google,
                                      size: 24,
                                      color: Color(0xFF4285F4),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          
                          // Toggle between Login and Sign Up
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
                                  style: IOSTypography.subheadline(
                                    color: Colors.white.withOpacity(0.9),
                                    weight: FontWeight.w400,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: isSignUp
                                          ? 'Already have an account? '
                                          : 'Don\'t have an account? ',
                                    ),
                                    TextSpan(
                                      text: isSignUp ? 'Log in' : 'Sign up',
                                      style: IOSTypography.subheadline(
                                        color: Colors.white,
                                        weight: FontWeight.w700,
                                      ).copyWith(
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Terms and privacy policy
                          Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: IOSTypography.caption1(
                                  color: Colors.white.withOpacity(0.85),
                                  weight: FontWeight.w400,
                                ),
                                children: [
                                  const TextSpan(
                                    text: 'By continuing, you agree to our\n',
                                  ),
                                  TextSpan(
                                    text: 'Terms of Service',
                                    style: IOSTypography.caption1(
                                      color: Colors.white,
                                      weight: FontWeight.w600,
                                    ).copyWith(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  const TextSpan(text: '  '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: IOSTypography.caption1(
                                      color: Colors.white,
                                      weight: FontWeight.w600,
                                    ).copyWith(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  const TextSpan(text: '  '),
                                  TextSpan(
                                    text: 'Content Policies',
                                    style: IOSTypography.caption1(
                                      color: Colors.white,
                                      weight: FontWeight.w600,
                                    ).copyWith(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
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

  Widget _buildCustomLogo() {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey[200]!,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Custom J logo
          CustomPaint(
            size: const Size(85, 85),
            painter: JLogoPainter(),
          ),
          // Star accent
          Positioned(
            top: 18,
            right: 22,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2196F3).withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Icon(
                Icons.star,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}

// Custom painter for the "J" logo
class JLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1C1C1C)
      ..style = PaintingStyle.fill;

    final path = Path();
    
    final width = size.width;
    final height = size.height;
    
    // Create the J shape
    path.moveTo(width * 0.65, height * 0.2);
    path.lineTo(width * 0.65, height * 0.65);
    
    path.quadraticBezierTo(
      width * 0.65, height * 0.85,
      width * 0.45, height * 0.85,
    );
    
    path.quadraticBezierTo(
      width * 0.25, height * 0.85,
      width * 0.25, height * 0.65,
    );
    
    path.lineTo(width * 0.25, height * 0.58);
    
    path.quadraticBezierTo(
      width * 0.25, height * 0.73,
      width * 0.40, height * 0.73,
    );
    
    path.quadraticBezierTo(
      width * 0.53, height * 0.73,
      width * 0.53, height * 0.65,
    );
    
    path.lineTo(width * 0.53, height * 0.2);
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

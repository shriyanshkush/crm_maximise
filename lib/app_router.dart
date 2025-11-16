import 'package:go_router/go_router.dart';
import 'core/constants/app_routes.dart';
import 'features/auth/ presentation/pages/ login_page.dart';
import 'features/auth/ presentation/pages/otp_page.dart';
import 'features/auth/ presentation/pages/splash_page.dart';
import 'features/auth/ presentation/pages/welcome_screen.dart';
import 'features/auth/ presentation/pages/onboarding_questionnaire.dart';
import 'features/auth/services/auth_local_storage.dart';
import 'features/home/presentationpages/home_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  redirect: (context, state) async {
    final storage = AuthLocalStorage();
    final token = await storage.getToken();

    final currentPath = state.matchedLocation;

    final loggingIn = currentPath == AppRoutes.login || currentPath == AppRoutes.otp;

    if (token == null && !loggingIn) {
      return AppRoutes.login;
    }

    // if (token != null && loggingIn) {
    //   return AppRoutes.dashboard;
    // }
    if (token != null && loggingIn) {
      return AppRoutes.home;
    }

    return null;
  },

  routes: [
    // 🔹 Splash Page (initial)
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashPage(),
    ),

    // 🔹 Login Page
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),

    // 🔹 OTP Page
    GoRoute(
      path: AppRoutes.otp,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>?;
        return OtpPage(
          email: data?['email'] ?? '',
          isRegister: data?['isRegister'] ?? false,
          name: data?['name'] ?? '',
        );
      },
    ),

    // 🔹 Welcome Screen (After signup)
    GoRoute(
      path: '/welcome',
      builder: (context, state) {
        final name = state.extra as String? ?? '';
        return WelcomeScreen(name: name);
      },
    ),

    // 🔹 Onboarding Questionnaire
    GoRoute(
      path: '/onboarding/profile',
      builder: (context, state) => const OnboardingQuestionnaire(),
    ),

    // Home Page
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomePage(),
    ),

    // 🔹 Dashboard
    // GoRoute(
    //   path: AppRoutes.dashboard,
    //   builder: (context, state) => const DashboardPage(),
    // ),
    //
    // // Leads
    // GoRoute(path: AppRoutes.leads, builder: (context, state) => const LeadsPage()),
    //
    // // Teams
    // GoRoute(path: AppRoutes.teams, builder: (context, state) => const TeamsPage()),
  ],
);

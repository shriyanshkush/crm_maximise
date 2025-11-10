import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import 'app_router.dart';
import 'common/services/api_service.dart';
import 'core/theme/app_theme.dart';

// Auth imports
import 'features/auth/ presentation/bloc/auth_bloc.dart';
import 'features/auth/services/auth_local_storage.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';

// Dashboard imports
import 'features/dashboard/presentation/ bloc/dashboard_bloc.dart';
import 'features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'features/leads/data/datasources/leads_remote_data_source.dart';
import 'features/leads/data/repositories/leads_repository_impl.dart';
import 'features/leads/presentation/bloc/leads_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔹 Initialize Dio with token interceptor
  final apiService = ApiService();
  final dio = apiService.dio;

  // 🔹 Initialize Auth dependencies
  final authRepo = AuthRepositoryImpl(AuthRemoteDataSourceImpl(dio));
  final localStorage = AuthLocalStorage();

  // 🔹 Initialize Dashboard dependencies
  final dashboardRepo = DashboardRepositoryImpl(DashboardRemoteDataSourceImpl(dio));

  // 🔹 Initialize Leadmanagement dependencies
  final leadsRepo = LeadsRepositoryImpl(LeadsRemoteDataSourceImpl(dio));


  runApp(MyApp(
    authRepo: authRepo,
    localStorage: localStorage,
    dashboardRepo: dashboardRepo,
    leadsRepo: leadsRepo,
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl authRepo;
  final AuthLocalStorage localStorage;
  final DashboardRepositoryImpl dashboardRepo;
  final LeadsRepositoryImpl leadsRepo;

  const MyApp({
    super.key,
    required this.authRepo,
    required this.localStorage,
    required this.dashboardRepo,
    required this.leadsRepo,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // 🔹 Auth Bloc
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(authRepo, localStorage),
        ),

        // 🔹 Dashboard Bloc
        BlocProvider<DashboardBloc>(
          create: (_) => DashboardBloc(dashboardRepo),
        ),

        // Lead Management
        BlocProvider<LeadsBloc>(
            create: (_) => LeadsBloc(leadsRepo)
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Sales Tracker',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: appRouter,
      ),
    );
  }
}

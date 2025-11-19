import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import 'app_router.dart';
import 'common/services/api_service.dart';
import 'core/theme/app_theme.dart';

// 🔹 Auth imports
import 'features/auth/ presentation/bloc/auth_bloc.dart';
import 'features/auth/services/auth_local_storage.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';

// 🔹 Dashboard imports
import 'features/dashboard/presentation/ bloc/dashboard_bloc.dart';
import 'features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'features/dashboard/data/repositories/dashboard_repository_impl.dart';

// 🔹 Leads imports
import 'features/dashboard/presentation/ bloc/filter_blocs/dashboard_filter_bloc.dart';
import 'features/leads/data/datasources/leads_remote_data_source.dart';
import 'features/leads/data/repositories/leads_repository_impl.dart';
import 'features/leads/presentation/bloc/leads_bloc.dart';
import 'features/leads/presentation/bloc/lead_detail/lead_detail_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔹 Setup Dio + API service
  final apiService = ApiService();
  final dio = apiService.dio;

  // 🔹 Initialize repositories
  final authRepo = AuthRepositoryImpl(AuthRemoteDataSourceImpl(dio));
  final dashboardRepo = DashboardRepositoryImpl(DashboardRemoteDataSourceImpl(dio));
  final leadsRepo = LeadsRepositoryImpl(LeadsRemoteDataSourceImpl(dio));
  final localStorage = AuthLocalStorage();

  // 🔹 Launch app
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
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepo),
        RepositoryProvider.value(value: dashboardRepo),
        RepositoryProvider.value(value: leadsRepo),
      ],
      child: MultiBlocProvider(
        providers: [
          // 🔹 Auth Bloc
          BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(authRepo, localStorage),
          ),

          // 🔹 Dashboard Bloc
          BlocProvider<DashboardBloc>(
            create: (_) => DashboardBloc(dashboardRepo),
          ),

          // Dashboard Filter Bloc
          BlocProvider(
            create: (context) => DashboardFilterBloc(),
          ),

          // 🔹 Leads Bloc
          BlocProvider<LeadsBloc>(
            create: (_) => LeadsBloc(leadsRepo),
          ),

          // ✅ Lead Detail Bloc — optional global
          BlocProvider<LeadDetailBloc>(
            create: (_) => LeadDetailBloc(leadsRepo),
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'core/navigation/route_guard.dart';
import 'features/auth/presentation/pages/welcome_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/documents/presentation/pages/documents_list_page.dart';
import 'features/documents/presentation/pages/document_upload_page.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/documents/presentation/bloc/documents_bloc.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'injection/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await configureDependencies();

  runApp(const NDocsApp());
}

final _router = GoRouter(
  initialLocation: '/welcome',
  redirect: (context, state) {
    // Apply route guards
    return RouteGuard.authGuard(context, state);
  },
  routes: [
    // Public routes (no authentication required)
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomePage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),

    // Protected routes (authentication required)
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardPage(),
      redirect: (context, state) => RouteGuard.standardGuard(context, state),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
      redirect: (context, state) => RouteGuard.standardGuard(context, state),
    ),

    // Documents routes
    GoRoute(
      path: '/documents',
      builder: (context, state) => const DocumentsListPage(),
      redirect: (context, state) => RouteGuard.standardGuard(context, state),
    ),
    GoRoute(
      path: '/documents/upload',
      builder: (context, state) => const DocumentUploadPage(),
      redirect: (context, state) => RouteGuard.sensitiveGuard(context, state),
    ),

    // Special routes for guards
    GoRoute(
      path: '/profile/setup',
      builder: (context, state) => const ProfileSetupRequiredWidget(),
    ),
    GoRoute(
      path: '/verify-email',
      builder: (context, state) => const EmailVerificationRequiredWidget(),
    ),
    GoRoute(
      path: '/unauthorized',
      builder: (context, state) => const UnauthorizedWidget(),
    ),
  ],
);

class NDocsApp extends StatelessWidget {
  const NDocsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<AuthBloc>()..add(AuthCheckRequested()),
        ),
        BlocProvider(
          create: (context) => getIt<DocumentsBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<ProfileBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: AppStrings.appName,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.light,
          ),
          textTheme: GoogleFonts.interTextTheme(),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12
            ),
          ),
        ),
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

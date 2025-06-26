import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';

/// Route guard that checks authentication status before allowing navigation
class RouteGuard {
  static String? authGuard(BuildContext context, GoRouterState state) {
    final authState = context.read<AuthBloc>().state;
    
    // Check if user is authenticated
    if (authState is! AuthAuthenticated) {
      // If trying to access protected routes, redirect to login
      final protectedRoutes = [
        '/dashboard',
        '/documents',
        '/profile',
        '/upload',
        '/settings',
      ];
      
      final currentPath = state.uri.path;
      if (protectedRoutes.any((route) => currentPath.startsWith(route))) {
        return '/login';
      }
    }
    
    // If authenticated and trying to access auth routes, redirect to dashboard
    if (authState is AuthAuthenticated) {
      final authRoutes = ['/login', '/register', '/forgot-password'];
      final currentPath = state.uri.path;
      
      if (authRoutes.contains(currentPath)) {
        return '/dashboard';
      }
    }
    
    return null; // Allow navigation
  }

  /// Check if user has completed profile setup
  static String? profileCompletionGuard(BuildContext context, GoRouterState state) {
    final authState = context.read<AuthBloc>().state;
    
    if (authState is AuthAuthenticated) {
      final user = authState.user;
      
      // Check if profile is incomplete
      final hasBasicInfo = user.firstName != null && 
                          user.firstName!.isNotEmpty &&
                          user.lastName != null && 
                          user.lastName!.isNotEmpty;
      
      if (!hasBasicInfo) {
        // If trying to access main app without complete profile
        final mainRoutes = ['/dashboard', '/documents'];
        final currentPath = state.uri.path;
        
        if (mainRoutes.contains(currentPath)) {
          return '/profile/setup';
        }
      }
    }
    
    return null;
  }

  /// Check if user has verified their email
  static String? emailVerificationGuard(BuildContext context, GoRouterState state) {
    final authState = context.read<AuthBloc>().state;
    
    if (authState is AuthAuthenticated) {
      final user = authState.user;
      
      // Check if email is not verified
      if (!user.isEmailVerified) {
        // If trying to access sensitive routes without email verification
        final sensitiveRoutes = ['/documents/upload', '/profile/security'];
        final currentPath = state.uri.path;
        
        if (sensitiveRoutes.any((route) => currentPath.startsWith(route))) {
          return '/verify-email';
        }
      }
    }
    
    return null;
  }

  /// Check if user has required permissions for admin routes
  static String? adminGuard(BuildContext context, GoRouterState state) {
    final authState = context.read<AuthBloc>().state;
    
    if (authState is AuthAuthenticated) {
      final user = authState.user;
      
      // Check if user has admin role
      final isAdmin = user.role == 'admin' || user.role == 'super_admin';
      
      if (!isAdmin) {
        // If trying to access admin routes without permission
        final adminRoutes = ['/admin'];
        final currentPath = state.uri.path;
        
        if (adminRoutes.any((route) => currentPath.startsWith(route))) {
          return '/dashboard'; // Redirect to dashboard
        }
      }
    }
    
    return null;
  }

  /// Combine multiple guards
  static String? combineGuards(
    BuildContext context, 
    GoRouterState state, 
    List<String? Function(BuildContext, GoRouterState)> guards,
  ) {
    for (final guard in guards) {
      final result = guard(context, state);
      if (result != null) {
        return result; // Return first redirect found
      }
    }
    return null;
  }

  /// Standard guard for most protected routes
  static String? standardGuard(BuildContext context, GoRouterState state) {
    return combineGuards(context, state, [
      authGuard,
      profileCompletionGuard,
    ]);
  }

  /// Guard for sensitive routes that require email verification
  static String? sensitiveGuard(BuildContext context, GoRouterState state) {
    return combineGuards(context, state, [
      authGuard,
      profileCompletionGuard,
      emailVerificationGuard,
    ]);
  }

  /// Guard for admin routes
  static String? adminRouteGuard(BuildContext context, GoRouterState state) {
    return combineGuards(context, state, [
      authGuard,
      profileCompletionGuard,
      emailVerificationGuard,
      adminGuard,
    ]);
  }
}

/// Widget that shows loading while checking authentication
class AuthLoadingWidget extends StatelessWidget {
  const AuthLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

/// Widget that shows when user needs to complete profile
class ProfileSetupRequiredWidget extends StatelessWidget {
  const ProfileSetupRequiredWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_add,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 24),
              Text(
                'Complete Your Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Please complete your profile information to continue using the app.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 32),
              // Add button to navigate to profile setup
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget that shows when user needs to verify email
class EmailVerificationRequiredWidget extends StatelessWidget {
  const EmailVerificationRequiredWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Your Email'),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.email,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 24),
              Text(
                'Verify Your Email',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Please verify your email address to access this feature.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 32),
              // Add button to resend verification email
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget that shows when user doesn't have permission
class UnauthorizedWidget extends StatelessWidget {
  const UnauthorizedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Access Denied'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 24),
              Text(
                'Access Denied',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'You don\'t have permission to access this page.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

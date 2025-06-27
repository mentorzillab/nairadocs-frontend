import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ErrorSnackBar.show(context, state.message);
          } else if (state is AuthAuthenticated) {
            SuccessSnackBar.show(context, 'Welcome back, ${state.user.firstName}!');
            context.go('/dashboard');
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),

                  // App logo and title
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.description,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppStrings.appName.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Secure Nigerian Document Verification',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.lightText,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Welcome text
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Sign in to your account',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.lightText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Email field
                  CustomTextField(
                    label: AppStrings.email,
                    hint: 'Enter your email address',
                    controller: _emailController,
                    validator: Validators.validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined, color: AppColors.lightText),
                    autofocus: true,
                  ),
                  const SizedBox(height: 20),

                  // Password field
                  CustomTextField(
                    label: AppStrings.password,
                    hint: 'Enter your password',
                    controller: _passwordController,
                    validator: (value) => Validators.validateRequired(value, 'Password'),
                    obscureText: true,
                    showPasswordToggle: true,
                    prefixIcon: const Icon(Icons.lock_outlined, color: AppColors.lightText),
                  ),
                  const SizedBox(height: 16),

                  // Remember me and forgot password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                            activeColor: AppColors.primary,
                          ),
                          const Text(
                            'Remember me',
                            style: TextStyle(
                              color: AppColors.lightText,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Implement forgot password
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Forgot password feature coming soon'),
                            ),
                          );
                        },
                        child: const Text(
                          AppStrings.forgotPassword,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Login button
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return LoadingButton(
                        onPressed: _handleLogin,
                        text: AppStrings.logIn,
                        isLoading: state is AuthLoading,
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Register link
                  Center(
                    child: GestureDetector(
                      onTap: () => context.go('/register'),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.lightText,
                          ),
                          children: [
                            TextSpan(text: AppStrings.dontHaveAccount + ' '),
                            TextSpan(
                              text: 'Sign Up',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }
}

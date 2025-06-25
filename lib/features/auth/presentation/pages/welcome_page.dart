import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.insert_drive_file_rounded,
                  color: Colors.white,
                  size: 80
                ),
                const SizedBox(height: 20),
                const Text(
                  AppStrings.welcomeTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 20),
                const ListTile(
                  leading: Icon(Icons.check_circle, color: Colors.white),
                  title: Text(
                    AppStrings.secureUpload,
                    style: TextStyle(color: Colors.white)
                  ),
                ),
                const ListTile(
                  leading: Icon(Icons.check_circle, color: Colors.white),
                  title: Text(
                    AppStrings.fastVerification,
                    style: TextStyle(color: Colors.white)
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                    ),
                  ),
                  onPressed: () {
                    context.go('/login');
                  },
                  child: const Text(AppStrings.getStarted),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

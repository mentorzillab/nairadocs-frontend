import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage("https://via.placeholder.com/150"),
            ),
            const SizedBox(height: 12),
            const Text(
              "Jane Doe",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              )
            ),
            const Text(
              "janeded@example.com",
              style: TextStyle(color: Colors.grey)
            ),
            const SizedBox(height: 30),
            const ListTile(
              leading: Icon(Icons.person),
              title: Text("Account")
            ),
            const ListTile(
              leading: Icon(Icons.notifications),
              title: Text("Notifications")
            ),
            SwitchListTile(
              value: true,
              onChanged: (v) {},
              title: const Text("Dark Mode"),
              secondary: const Icon(Icons.dark_mode),
            ),
            const ListTile(
              leading: Icon(Icons.help),
              title: Text("Help")
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Widget statusCard(String label, String value, {Color? color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            )
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87
            )
          ),
        ],
      ),
    );
  }

  Widget activityTile(String title, String status, Color statusColor) {
    return ListTile(
      title: Text(title),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          status,
          style: TextStyle(color: statusColor)
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hi, Jane Doe",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold
              )
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: statusCard("In Review", "2", color: AppColors.tealLight),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: statusCard("Approved", "8", color: AppColors.tealLight),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: statusCard("Rejected", "1", color: AppColors.redLight),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              "Recent Activity",
              style: TextStyle(fontWeight: FontWeight.bold)
            ),
            activityTile("Document", "Rejected", AppColors.rejected),
            activityTile("Approved", "Approved", AppColors.approved),
            activityTile("In Review", "In Review", AppColors.inReview),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
                ),
              ),
              child: const Text("Verify Document"),
            )
          ],
        ),
      ),
    );
  }
}

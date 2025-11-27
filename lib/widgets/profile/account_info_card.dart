import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'info_row.dart';

class AccountInfoCard extends StatelessWidget {
  final Map<String, dynamic>? userData;

  const AccountInfoCard({
    super.key,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            InfoRow(
              icon: Icons.badge,
              label: 'User ID',
              value: userData?['user_id']?.toString() ?? 'N/A',
            ),
            const Divider(),
            InfoRow(
              icon: Icons.email,
              label: 'Email',
              value: userData?['email'] ?? 'N/A',
            ),
            const Divider(),
            InfoRow(
              icon: Icons.person,
              label: 'Display Name',
              value: userData?['display_name'] ?? 'N/A',
            ),
            const Divider(),
            InfoRow(
              icon: Icons.calendar_today,
              label: 'Member Since',
              value: userData?['created_at'] != null
                  ? DateFormat('MMMM dd, yyyy').format(
                      DateTime.parse(userData!['created_at']))
                  : 'N/A',
            ),
            const Divider(),
            InfoRow(
              icon: Icons.update,
              label: 'Last Updated',
              value: userData?['updated_at'] != null
                  ? DateFormat('MMM dd, yyyy HH:mm').format(
                      DateTime.parse(userData!['updated_at']))
                  : 'N/A',
            ),
          ],
        ),
      ),
    );
  }
}

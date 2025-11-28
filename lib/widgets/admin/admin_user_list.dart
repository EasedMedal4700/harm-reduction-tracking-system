import 'package:flutter/material.dart';
import 'admin_user_card.dart';

/// User list section for admin panel
class AdminUserList extends StatelessWidget {
  final List<Map<String, dynamic>> users;
  final Function(String, bool) onToggleAdmin;
  final VoidCallback onRefresh;

  const AdminUserList({
    required this.users,
    required this.onToggleAdmin,
    required this.onRefresh,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'User Management',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: onRefresh,
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (users.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text('No users found'),
            ),
          )
        else
          ...users.map((user) => AdminUserCard(
                user: user,
                onToggleAdmin: onToggleAdmin,
              )),
      ],
    );
  }
}

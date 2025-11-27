import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// User card widget for admin panel
class AdminUserCard extends StatelessWidget {
  final Map<String, dynamic> user;
  final Function(int, bool) onToggleAdmin;

  const AdminUserCard({
    required this.user,
    required this.onToggleAdmin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Database uses 'user_id' not 'id'
    final userId = user['user_id'] as int? ?? user['id'] as int? ?? 0;
    final username = user['username'] as String? ?? user['display_name'] as String? ?? 'Unknown';
    final email = user['email'] as String? ?? 'No email';
    final isAdmin = user['is_admin'] as bool? ?? false;
    final createdAt = user['created_at'];
    final lastActive = user['last_activity'] ?? user['last_active'] ?? user['updated_at'];
    final entryCount = user['entry_count'] as int? ?? 0;
    final cravingCount = user['craving_count'] as int? ?? 0;
    final reflectionCount = user['reflection_count'] as int? ?? 0;
    final authUserId = user['auth_user_id'] as String? ?? 'N/A';
    
    // If userId is 0, the data is invalid
    if (userId == 0) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: const Icon(Icons.error_outline, color: Colors.red),
          title: const Text('Invalid user data'),
          subtitle: Text('Email: $email'),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: isAdmin ? Colors.deepPurple : Colors.blue,
          child: Text(
            username[0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Row(
          children: [
            Text(username, style: const TextStyle(fontWeight: FontWeight.bold)),
            if (isAdmin) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'ADMIN',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(email),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('User ID', userId.toString()),
                _buildInfoRow('Auth UUID', authUserId.substring(0, 8) + '...'),
                const Divider(),
                _buildInfoRow('Entries', entryCount.toString()),
                _buildInfoRow('Cravings', cravingCount.toString()),
                _buildInfoRow('Reflections', reflectionCount.toString()),
                _buildInfoRow('Total Activity', (entryCount + cravingCount + reflectionCount).toString()),
                const Divider(),
                if (createdAt != null)
                  _buildInfoRow(
                    'Joined',
                    DateFormat('MMM d, yyyy').format(DateTime.parse(createdAt)),
                  ),
                if (lastActive != null)
                  _buildInfoRow(
                    'Last Active',
                    DateFormat('MMM d, yyyy HH:mm')
                        .format(DateTime.parse(lastActive)),
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => onToggleAdmin(userId, isAdmin),
                        icon: Icon(isAdmin ? Icons.remove_circle : Icons.add_circle),
                        label: Text(isAdmin ? 'Remove Admin' : 'Make Admin'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isAdmin ? Colors.red : Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

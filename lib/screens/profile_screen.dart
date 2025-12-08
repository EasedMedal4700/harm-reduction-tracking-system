import 'package:flutter/material.dart';
import '../common/old_common/drawer_menu.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/statistics_card.dart';
import '../widgets/profile/account_info_card.dart';
import '../widgets/profile/logout_button.dart';
import '../services/user_service.dart';
import '../services/auth_service.dart';
import '../services/log_entry_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _userData;
  Map<String, int>? _statistics;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      final data = await UserService.getUserData();
      final stats = await _loadStatistics();
      setState(() {
        _userData = data;
        _statistics = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profile: $e')),
        );
      }
    }
  }

  Future<Map<String, int>> _loadStatistics() async {
    try {
      final logService = LogEntryService();
      final entries = await logService.fetchRecentEntriesRaw();
      
      // Calculate statistics from entries
      final now = DateTime.now();
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));
      final sevenDaysAgo = now.subtract(const Duration(days: 7));
      
      int last7Days = 0;
      int last30Days = 0;
      
      for (var entry in entries) {
        final timestamp = DateTime.parse(entry['timestamp'] as String);
        if (timestamp.isAfter(sevenDaysAgo)) {
          last7Days++;
        }
        if (timestamp.isAfter(thirtyDaysAgo)) {
          last30Days++;
        }
      }

      return {
        'total_entries': entries.length,
        'last_7_days': last7Days,
        'last_30_days': last30Days,
      };
    } catch (e) {
      return {
        'total_entries': 0,
        'last_7_days': 0,
        'last_30_days': 0,
      };
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await AuthService().logout();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login_page');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: isDark ? const Color(0xFF1A1A2E) : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      drawer: const DrawerMenu(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadUserData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Profile Header
                    ProfileHeader(userData: _userData),
                    const SizedBox(height: 32),
                    // Statistics Card
                    if (_statistics != null)
                      StatisticsCard(statistics: _statistics!),
                    const SizedBox(height: 32),
                    // Account Information Card
                    AccountInfoCard(userData: _userData),
                    const SizedBox(height: 32),
                    // Logout Button
                    LogoutButton(onLogout: _logout),
                  ],
                ),
              ),
            ),
    );
  }
}

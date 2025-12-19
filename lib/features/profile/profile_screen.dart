// MIGRATION
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import '../../common/layout/common_spacer.dart';

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/core_providers.dart';
import '../../common/layout/common_drawer.dart';
import 'widgets/profile/profile_header.dart';
import 'widgets/profile/statistics_card.dart';
import 'widgets/profile/account_info_card.dart';
import 'widgets/profile/logout_button.dart';
import '../../services/user_service.dart';
import '../log_entry/log_entry_service.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
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
      builder: (context) {
        final c = context.colors;
        final t = context.text;
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: c.error),
              child: Text('Logout', style: t.labelLarge.copyWith(color: c.textInverse)),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await ref.read(authServiceProvider).logout();
      unawaited(ref.read(appLockControllerProvider.notifier).clear());
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login_page');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.spacing;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: context.sizes.elevationNone,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      drawer: const CommonDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadUserData,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(sp.md),
                child: Column(
                  children: [
                    // Profile Header
                    ProfileHeader(userData: _userData),
                    CommonSpacer.vertical(sp.xl),
                    // Statistics Card
                    if (_statistics != null)
                      StatisticsCard(statistics: _statistics!),
                    CommonSpacer.vertical(sp.xl),
                    // Account Information Card
                    AccountInfoCard(userData: _userData),
                    CommonSpacer.vertical(sp.xl),
                    // Logout Button
                    LogoutButton(onLogout: _logout),
                  ],
                ),
              ),
            ),
    );
  }
}

// MIGRATION:
// State: MODERN
// Navigation: GOROUTER
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Tolerance dashboard page

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/user_service.dart';
import '../controllers/tolerance_controller.dart';
import '../widgets/dashboard_content_widget.dart';
import '../../../common/feedback/common_loader.dart';

class ToleranceDashboardPage extends ConsumerStatefulWidget {
  const ToleranceDashboardPage({super.key});

  @override
  ConsumerState<ToleranceDashboardPage> createState() =>
      _ToleranceDashboardPageState();
}

class _ToleranceDashboardPageState
    extends ConsumerState<ToleranceDashboardPage> {
  String? _selectedBucket;

  @override
  Widget build(BuildContext context) {
    String userId;
    try {
      userId = UserService.getCurrentUserId();
    } catch (_) {
      return const Scaffold(body: Center(child: Text("Please log in")));
    }

    final toleranceAsync = ref.watch(toleranceControllerProvider(userId));

    return Scaffold(
      appBar: AppBar(title: const Text('Tolerance Dashboard')),
      body: toleranceAsync.when(
        data: (data) {
          // Logic to set initial selected bucket if null
          // We can do this in a useEffect or just check here, but checking here might cause rebuild loops if we setState.
          // Better to just let the user select.

          return DashboardContentWidget(
            systemTolerance: data,
            substanceActiveStates: data.substanceActiveStates,
            substanceContributions: data.substanceContributions,
            selectedBucket: _selectedBucket,
            onBucketSelected: (bucket) =>
                setState(() => _selectedBucket = bucket),
            onAddEntry: () {
              // Navigate to log entry
              // context.push('/log-entry');
              // Assuming route exists, otherwise just print
              debugPrint("Navigate to log entry");
            },
          );
        },
        loading: () => const Center(child: CommonLoader()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

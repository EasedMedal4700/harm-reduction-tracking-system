// MIGRATION:
// State: MODERN (UI-only)
// Navigation: GOROUTER
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Log entry page using Riverpod state + provider-driven save flow.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/constants/data/drug_categories.dart';

import 'package:mobile_drug_use_app/core/providers/navigation_provider.dart';

import '../../common/feedback/common_loader.dart';
import '../../common/layout/common_drawer.dart';
import 'log_entry_state.dart';
import 'providers/log_entry_save_controller.dart';
import 'widgets/log_entry/log_entry_form.dart';
import 'widgets/log_entry_page/log_entry_app_bar.dart';

class QuickLogEntryPage extends ConsumerStatefulWidget {
  const QuickLogEntryPage({super.key});

  @override
  ConsumerState<QuickLogEntryPage> createState() => _QuickLogEntryPageState();
}

class _QuickLogEntryPageState extends ConsumerState<QuickLogEntryPage>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  late Animation<double> _fadeAnimation;

  final _formKey = GlobalKey<FormState>();
  final _notesCtrl = TextEditingController();
  final _doseCtrl = TextEditingController();
  final _substanceCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Notes field currently doesn't emit onChanged from the shared textarea,
    // so we bridge it here.
    _notesCtrl.addListener(() {
      ref.read(logEntryProvider.notifier).setNotes(_notesCtrl.text);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_animationController == null) {
      _animationController = AnimationController(
        duration: context.animations.normal,
        vsync: this,
      );
      _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController!, curve: Curves.easeOut),
      );
      _animationController!.forward();
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _notesCtrl.dispose();
    _doseCtrl.dispose();
    _substanceCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      _showSnackBar('Please fix validation errors before saving.');
      return;
    }

    await ref.read(logEntrySaveControllerProvider.notifier).requestSave();
  }

  void _resetForm() {
    ref.read(logEntryProvider.notifier).resetForm();
    _notesCtrl.clear();
    _doseCtrl.clear();
    _substanceCtrl.clear();
    _formKey.currentState?.reset();
  }

  void _showSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? context.animations.snackbar,
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => ref.read(navigationProvider).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<bool> _showConfirmDialog(String title, String message) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => ref.read(navigationProvider).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => ref.read(navigationProvider).pop(true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(logEntrySaveControllerProvider, (prev, next) async {
      final notifier = ref.read(logEntrySaveControllerProvider.notifier);

      final pending = next.pendingConfirmation;
      final prevPending = prev?.pendingConfirmation;
      if (pending != null && pending != prevPending) {
        final confirmed = await _showConfirmDialog(
          pending.title,
          pending.message,
        );
        if (!mounted) return;
        await notifier.resolvePendingConfirmation(confirmed);
        return;
      }

      if (next.hasError &&
          (prev?.errorMessage != next.errorMessage ||
              prev?.errorTitle != next.errorTitle)) {
        _showErrorDialog(
          next.errorTitle ?? 'Error',
          next.errorMessage ?? 'Unknown error.',
        );
        notifier.clearError();
        return;
      }

      final result = next.lastResult;
      final prevResult = prev?.lastResult;
      if (result != null && result != prevResult) {
        if (result.isSuccess) {
          _showSnackBar(
            result.message,
            duration: context.animations.longSnackbar,
          );
          _resetForm();
        } else {
          _showSnackBar(result.message);
        }
        notifier.clearResult();
      }
    });

    final state = ref.watch(logEntryProvider);
    final notifier = ref.read(logEntryProvider.notifier);
    final saveState = ref.watch(logEntrySaveControllerProvider);
    final th = context.theme;

    String? rawCategory;
    final details = state.substanceDetails;
    if (details != null) {
      rawCategory = details['category'] as String?;
      if (rawCategory == null || rawCategory.trim().isEmpty) {
        final cats = details['categories'];
        if (cats is List) {
          final list = cats.whereType<String>().toList(growable: false);
          if (list.isNotEmpty) rawCategory = list.join(', ');
        } else if (cats is String && cats.trim().isNotEmpty) {
          rawCategory = cats;
        }
      }
    }

    final hasCategory = rawCategory != null && rawCategory.trim().isNotEmpty;
    final categoryKey = hasCategory
        ? DrugCategories.primaryCategoryFromRaw(rawCategory)
        : null;
    final categoryAccent = categoryKey == null
        ? null
        : DrugCategoryColors.colorFor(categoryKey);
    final categoryIcon = categoryKey == null
        ? null
        : (DrugCategories.categoryIconMap[categoryKey] ?? Icons.science);

    return Scaffold(
      backgroundColor: th.c.background,
      appBar: LogEntryAppBar(
        isSimpleMode: state.isSimpleMode,
        onSimpleModeChanged: notifier.setIsSimpleMode,
        categoryAccent: categoryAccent,
        categoryIcon: categoryIcon,
      ),
      drawer: const CommonDrawer(),
      body: Stack(
        children: [
          FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: EdgeInsets.all(th.sp.md),
              child: LogEntryForm(
                isSimpleMode: state.isSimpleMode,
                dose: state.dose,
                unit: state.unit,
                substance: state.substance,
                route: state.route,
                availableROAs: notifier.getAvailableROAs(),
                isROAValidated: notifier.isROAValidated,
                feelings: state.feelings,
                secondaryFeelings: state.secondaryFeelings,
                location: state.location,
                date: state.date,
                hour: state.hour,
                minute: state.minute,
                isMedicalPurpose: state.isMedicalPurpose,
                cravingIntensity: state.cravingIntensity,
                intention: state.intention,
                selectedTriggers: state.triggers,
                selectedBodySignals: state.bodySignals,
                categoryAccent: categoryAccent,
                categoryIcon: categoryIcon,
                notesCtrl: _notesCtrl,
                doseCtrl: _doseCtrl,
                substanceCtrl: _substanceCtrl,
                formKey: _formKey,
                onDoseChanged: notifier.setDose,
                onUnitChanged: notifier.setUnit,
                onSubstanceChanged: notifier.setSubstance,
                onRouteChanged: notifier.setRoute,
                onFeelingsChanged: notifier.setFeelings,
                onSecondaryFeelingsChanged: notifier.setSecondaryFeelings,
                onLocationChanged: notifier.setLocation,
                onDateChanged: notifier.setDate,
                onHourChanged: notifier.setHour,
                onMinuteChanged: notifier.setMinute,
                onMedicalPurposeChanged: notifier.setIsMedicalPurpose,
                onCravingIntensityChanged: notifier.setCravingIntensity,
                onIntentionChanged: notifier.setIntention,
                onTriggersChanged: notifier.setTriggers,
                onBodySignalsChanged: notifier.setBodySignals,
                onSave: _handleSave,
              ),
            ),
          ),
          if (saveState.isSaving)
            Container(color: th.c.overlayHeavy, child: const CommonLoader()),
        ],
      ),
    );
  }
}

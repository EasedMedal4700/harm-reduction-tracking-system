// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Account dialogs.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_drug_use_app/core/providers/navigation_provider.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../../../common/layout/common_spacer.dart';
import '../../../common/feedback/common_loader.dart';
import '../../../common/buttons/common_primary_button.dart';

/// Dialog for password verification before sensitive operations
class PasswordVerificationDialog extends StatefulWidget {
  final String title;
  final String description;
  final String actionButtonText;
  final Color actionButtonColor;
  final bool requireConfirmation;
  final Function(String password) onVerified;
  const PasswordVerificationDialog({
    required this.title,
    required this.description,
    required this.actionButtonText,
    required this.actionButtonColor,
    this.requireConfirmation = false,
    required this.onVerified,
    super.key,
  });
  @override
  State<PasswordVerificationDialog> createState() =>
      _PasswordVerificationDialogState();
}

class _PasswordVerificationDialogState
    extends State<PasswordVerificationDialog> {
  final _passwordController = TextEditingController();
  bool _isVerifying = false;
  String? _errorMessage;
  bool _obscurePassword = true;
  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final password = _passwordController.text.trim();
    if (password.isEmpty) {
      setState(() => _errorMessage = 'Please enter your password');
      return;
    }
    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });
    try {
      final supabase = Supabase.instance.client;
      final email = supabase.auth.currentUser?.email;
      if (email == null) {
        throw Exception('User not authenticated');
      }
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        widget.onVerified(password);
      } else {
        setState(() {
          _errorMessage = 'Invalid password';
          _isVerifying = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Invalid password. Please try again.';
        _isVerifying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.spacing;
    final c = context.colors;
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: AppLayout.mainAxisSizeMin,
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Text(widget.description),
          CommonSpacer.vertical(sp.lg),
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.shapes.radiusMd),
              ),
              errorText: _errorMessage,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  size: context.sizes.iconMd,
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
            ),
            enabled: !_isVerifying,
            onSubmitted: (_) => _verify(),
          ),
        ],
      ),
      actions: [
        Semantics(
          button: true,
          enabled: !_isVerifying,
          label: _isVerifying ? 'Verifying password' : 'Cancel',
          child: Consumer(
            builder: (context, ref, _) {
              final nav = ref.read(navigationProvider);
              return TextButton(
                onPressed: () {
                  if (!_isVerifying) nav.pop();
                },
                child: const Text('Cancel'),
              );
            },
          ),
        ),
        Semantics(
          button: true,
          enabled: !_isVerifying,
          label: _isVerifying ? 'Verifying password' : widget.actionButtonText,
          child: CommonPrimaryButton(
            onPressed: () {
              if (!_isVerifying) _verify();
            },
            isLoading: _isVerifying,
            label: widget.actionButtonText,
            backgroundColor: widget.actionButtonColor,
            textColor: c.surface,
          ),
        ),
      ],
    );
  }
}

/// Warning item row for delete confirmation dialogs
class WarningItem extends StatelessWidget {
  final String text;
  final bool isRed;
  const WarningItem(this.text, {this.isRed = false, super.key});
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final sp = context.spacing;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: sp.xs),
      child: Row(
        children: [
          Icon(
            Icons.close,
            color: isRed ? c.error : c.warning,
            size: context.sizes.iconLg,
          ),
          CommonSpacer.horizontal(sp.sm),
          Expanded(
            child: Text(
              text,
              style: context.text.bodyMedium.copyWith(
                color: isRed ? c.error : c.warning,
                fontWeight: context.text.bodyMedium.fontWeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Loading dialog for async operations
class LoadingDialog extends StatelessWidget {
  final String message;
  const LoadingDialog({required this.message, super.key});
  @override
  Widget build(BuildContext context) {
    final sp = context.spacing;

    return Center(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(sp.xl),
          child: Column(
            mainAxisSize: AppLayout.mainAxisSizeMin,
            children: [
              const CommonLoader(),
              CommonSpacer.vertical(sp.lg),
              Text(message),
            ],
          ),
        ),
      ),
    );
  }
}

/// Typed confirmation dialog (e.g., type "DELETE MY DATA" to confirm)
class TypedConfirmationDialog extends StatefulWidget {
  final String title;
  final String confirmText;
  final String description;
  final Color? buttonColor;
  final VoidCallback onConfirmed;
  const TypedConfirmationDialog({
    required this.title,
    required this.confirmText,
    required this.description,
    this.buttonColor,
    required this.onConfirmed,
    super.key,
  });
  @override
  State<TypedConfirmationDialog> createState() =>
      _TypedConfirmationDialogState();
}

class _TypedConfirmationDialogState extends State<TypedConfirmationDialog> {
  bool _userConfirmed = false;
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final sp = context.spacing;

    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: AppLayout.mainAxisSizeMin,
        children: [
          Text(widget.description, style: context.text.bodyBold),
          CommonSpacer.vertical(sp.md),
          TextField(
            decoration: InputDecoration(
              hintText: widget.confirmText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.shapes.radiusMd),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _userConfirmed = value.trim() == widget.confirmText;
              });
            },
          ),
        ],
      ),
      actions: [
        Consumer(
          builder: (context, ref, _) {
            final nav = ref.read(navigationProvider);
            return TextButton(
              onPressed: () => nav.pop(),
              child: const Text('Cancel'),
            );
          },
        ),
        Semantics(
          button: true,
          enabled: _userConfirmed,
          label: _userConfirmed
              ? 'Confirm action'
              : 'Type confirmation text to enable',
          child: CommonPrimaryButton(
            onPressed: widget.onConfirmed,
            isEnabled: _userConfirmed,
            label: 'Confirm',
            backgroundColor: widget.buttonColor ?? c.error,
            textColor: c.surface,
          ),
        ),
      ],
    );
  }
}

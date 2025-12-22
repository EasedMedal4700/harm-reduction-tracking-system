// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to AppThemeExtension and common components. No logic or state changes.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/layout/common_spacer.dart';
import '../../../../common/feedback/common_loader.dart';

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
    final spacing = context.spacing;
    final colors = context.colors;

    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: AppLayout.mainAxisSizeMin,
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Text(widget.description),
          CommonSpacer.vertical(spacing.lg),
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
        TextButton(
          onPressed: _isVerifying ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isVerifying ? null : _verify,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.actionButtonColor,
            foregroundColor: colors.surface,
          ),
          child: _isVerifying
              ? SizedBox(
                  width: spacing.lg,
                  height: spacing.lg,
                  child: CommonLoader(size: spacing.lg, color: colors.surface),
                )
              : Text(widget.actionButtonText),
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
    final colors = context.colors;
    final spacing = context.spacing;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.xs),
      child: Row(
        children: [
          Icon(
            Icons.close,
            color: isRed ? colors.error : colors.warning,
            size: context.sizes.iconLg,
          ),
          CommonSpacer.horizontal(spacing.sm),
          Expanded(
            child: Text(
              text,
              style: context.text.bodyMedium.copyWith(
                color: isRed ? colors.error : colors.warning,
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
    final spacing = context.spacing;

    return Center(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(spacing.xl),
          child: Column(
            mainAxisSize: AppLayout.mainAxisSizeMin,
            children: [
              const CommonLoader(),
              CommonSpacer.vertical(spacing.lg),
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
    final spacing = context.spacing;
    final colors = context.colors;

    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: AppLayout.mainAxisSizeMin,
        children: [
          Text(widget.description, style: context.text.bodyBold),
          CommonSpacer.vertical(spacing.md),
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
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _userConfirmed ? widget.onConfirmed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.buttonColor ?? colors.error,
            foregroundColor: colors.surface,
          ),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}

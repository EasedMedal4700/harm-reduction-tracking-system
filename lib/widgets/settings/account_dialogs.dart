import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.description),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              border: const OutlineInputBorder(),
              errorText: _errorMessage,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
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
            foregroundColor: Colors.white,
          ),
          child: _isVerifying
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
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
  final bool isDark;

  const WarningItem(
    this.text, {
    this.isRed = false,
    this.isDark = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.close,
            color: isRed
                ? (isDark ? Colors.red.shade400 : Colors.red.shade700)
                : (isDark ? Colors.orange.shade400 : Colors.orange.shade700),
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isRed
                    ? (isDark ? Colors.red.shade300 : Colors.red.shade900)
                    : (isDark ? Colors.orange.shade300 : Colors.orange.shade900),
                fontWeight: FontWeight.w500,
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
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
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
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.description,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              hintText: widget.confirmText,
              border: const OutlineInputBorder(),
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
            backgroundColor: widget.buttonColor ?? Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}

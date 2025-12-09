import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/providers/auth_provider.dart';

/// Page for password reset flow.
class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  late TextEditingController _emailController;
  bool _isLoading = false;
  String? _message;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    setState(() {
      _isLoading = true;
      _message = null;
      _isSuccess = false;
    });

    try {
      final email = _emailController.text.trim();

      if (email.isEmpty) {
        setState(() {
          _message = 'Please enter your email address.';
          _isLoading = false;
        });
        return;
      }

      await ref.read(resetPasswordProvider(email).future);

      setState(() {
        _message =
            'Password reset email sent! Check your inbox for further instructions.';
        _isSuccess = true;
        _isLoading = false;
        _emailController.clear();
      });
    } catch (e) {
      setState(() {
        _message = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Text(
                  'Forgot Password?',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Text(
                  'Enter your email address and we\'ll send you a link to reset your password.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Email field
                TextField(
                  controller: _emailController,
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    prefixIcon: const Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24),
                // Status message
                if (_message != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _isSuccess
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.red.withValues(alpha: 0.1),
                      border: Border.all(
                        color: _isSuccess ? Colors.green : Colors.red,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _message!,
                      style: TextStyle(
                        color: _isSuccess ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                // Reset button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleResetPassword,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Send Reset Link'),
                  ),
                ),
                const SizedBox(height: 16),
                // Back to login button
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back to Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/core/providers/auth_provider.dart';
import 'package:flutter_application_1/core/services/auth_service.dart';

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  String? _errorMessage;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final confirmPassword = _confirmPasswordController.text;

      // Validate email is not empty
      if (email.isEmpty) {
        setState(() {
          _errorMessage = 'Please enter an email address.';
          _isLoading = false;
        });
        return;
      }

      // Validate email format
      if (!AuthService.isValidEmail(email)) {
        setState(() {
          _errorMessage = 'Please enter a valid email address (e.g., user@example.com).';
          _isLoading = false;
        });
        return;
      }

      // Validate password is not empty
      if (password.isEmpty) {
        setState(() {
          _errorMessage = 'Please enter a password.';
          _isLoading = false;
        });
        return;
      }

      // Validate passwords match
      if (password != confirmPassword) {
        setState(() {
          _errorMessage = 'Passwords do not match.';
          _isLoading = false;
        });
        return;
      }

      // Validate password strength
      if (!AuthService.isStrongPassword(password)) {
        setState(() {
          _errorMessage =
              'Password must be at least 8 characters with:\n• Uppercase letter (A-Z)\n• Lowercase letter (a-z)\n• Number (0-9)\n• Special character (!@#\$%^&*)';
          _isLoading = false;
        });
        return;
      }

      // Trigger sign-up and wait for it
      await ref.read(signUpProvider(
        (email: email, password: password),
      ).future);

      if (mounted) {
        // Clear the form
        _emailController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful! Going to home...'),
            backgroundColor: Colors.green,
            duration: Duration(milliseconds: 1000),
          ),
        );

        // Add a small delay to ensure auth state is fully propagated
        await Future.delayed(const Duration(milliseconds: 100));
        if (mounted) {
          context.go('/home');
        }
      }
    } catch (e) {
      String errorMsg = e.toString();

      // Provide helpful message if account was created despite security error
      if (errorMsg.contains('Security configuration error') ||
          errorMsg.contains('internal error')) {
        errorMsg = '$errorMsg\n\nYour account was created! Please log in with your credentials.';
      }

      setState(() {
        _errorMessage = errorMsg;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Error message
          if (_errorMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                border: Border.all(color: Colors.red.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _errorMessage!,
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 14,
                ),
              ),
            ),
          if (_errorMessage != null) const SizedBox(height: 16),

          // Email field
          TextField(
            controller: _emailController,
            enabled: !_isLoading,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email',
              prefixIcon: const Icon(Icons.email),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Password field
          TextField(
            controller: _passwordController,
            enabled: !_isLoading,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter a strong password',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: _isLoading
                    ? null
                    : () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Confirm Password field
          TextField(
            controller: _confirmPasswordController,
            enabled: !_isLoading,
            obscureText: _obscureConfirmPassword,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              hintText: 'Confirm your password',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: _isLoading
                    ? null
                    : () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Register button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleRegister,
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Register'),
            ),
          ),
          const SizedBox(height: 16),

          // Login link
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account? '),
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        },
                  child: const Text('Login here'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

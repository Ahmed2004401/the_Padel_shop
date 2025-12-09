// lib/features/auth/presentation/widgets/login_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/core/providers/auth_provider.dart';
import 'package:flutter_application_1/core/services/auth_service.dart';
import '../pages/forgot_password_page.dart';
import '../pages/register_page.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // Validate email is not empty
      if (email.isEmpty) {
        setState(() {
          _errorMessage = 'Please enter your email address.';
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
          _errorMessage = 'Please enter your password.';
          _isLoading = false;
        });
        return;
      }

      // Trigger sign-in and wait for it to complete
      await ref.read(signInProvider(
        (email: email, password: password),
      ).future);

      // Clear the form
      if (mounted) {
        _emailController.clear();
        _passwordController.clear();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful!'),
            backgroundColor: Colors.green,
            duration: Duration(milliseconds: 1000),
          ),
        );

        // Navigation happens automatically via GoRouter's redirect logic
        // when currentUserProvider emits the authenticated user
        // Add a small delay to ensure auth state is fully propagated
        await Future.delayed(const Duration(milliseconds: 100));
        if (mounted) {
          context.go('/home');
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
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
          // Email field
          TextField(
            controller: _emailController,
            enabled: !_isLoading,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              prefixIcon: const Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          // Password field
          TextField(
            controller: _passwordController,
            enabled: !_isLoading,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              prefixIcon: const Icon(Icons.lock),
            ),
          ),
          const SizedBox(height: 16),
          // Error message
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                _errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ),
          // Login button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Login'),
            ),
          ),
          const SizedBox(height: 16),
          // Forgot password link
          Center(
            child: TextButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordPage(),
                        ),
                      );
                    },
              child: const Text('Forgot Password?'),
            ),
          ),
          const SizedBox(height: 8),
          // Register link
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                          );
                        },
                  child: const Text('Register here'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

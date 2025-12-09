import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/providers/auth_provider.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/login_page.dart';

/// Auth guard that routes to login or home screen based on auth state.
/// Use this as the home widget in your MaterialApp.
class AuthGuard extends ConsumerWidget {
  final Widget homeScreen;

  const AuthGuard({
    super.key,
    required this.homeScreen,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(currentUserProvider);

    return authState.when(
      data: (user) {
        // User is authenticated
        if (user != null) {
          return homeScreen;
        }
        // User is not authenticated
        return const LoginPage();
      },
      loading: () {
        // Loading auth state
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Loading...',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        // Error loading auth state
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${error.toString()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Retry by rebuilding
                    ref.invalidate(currentUserProvider);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

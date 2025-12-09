import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/providers/auth_provider.dart';
import 'package:flutter_application_1/core/services/firestore_service.dart';

/// Widget to display current user profile information.
class UserProfileWidget extends ConsumerWidget {
  const UserProfileWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final firestoreService = FirestoreService();

    return currentUser.when(
      data: (user) {
        if (user == null) {
          return const SizedBox.shrink();
        }

        return FutureBuilder(
          future: firestoreService.getUserProfile(user.uid),
          builder: (context, snapshot) {
            final userProfile = snapshot.data;
            final displayName = userProfile?.displayName ?? user.displayName ?? 'User';
            final email = userProfile?.email ?? user.email ?? 'No email';
            
            // Safely get the first character
            final firstChar = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U';

            return Card(
              margin: const EdgeInsets.all(16),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        firstChar,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // User info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Error loading profile: $error',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sellatrack/core/navigation/app_router.dart';
import 'package:sellatrack/features/auth/presentation/notifiers/auth_state.dart';
import 'package:sellatrack/features/auth/presentation/providers/auth_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Widget _buildProfileDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String? value,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value ?? 'Not set',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final theme = Theme.of(context);

    ref.listen<AuthScreenState>(authNotifierProvider, (previous, next) {
      if (next.status == AuthStatus.unauthenticated) {
        context.go(AppRoutePaths.authentication);
      }
      if (next.errorMessage != null &&
          next.errorMessage!.isNotEmpty &&
          (previous?.errorMessage != next.errorMessage ||
              previous?.status != next.status)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            tooltip: 'Sign Out',
            onPressed: () {
              authNotifier.signOut();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => authNotifier.checkCurrentUser(),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            if (authState.status == AuthStatus.loading &&
                authState.user == null)
              const Center(child: CircularProgressIndicator())
            else if (authState.user != null) ...[
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: theme.colorScheme.primaryContainer,
                      backgroundImage:
                          authState.user!.photoURL != null
                              ? NetworkImage(authState.user!.photoURL!)
                              : null,
                      child:
                          authState.user!.photoURL == null
                              ? Text(
                                authState.user!.displayName?.isNotEmpty == true
                                    ? authState.user!.displayName![0]
                                        .toUpperCase()
                                    : 'S',
                                style: theme.textTheme.headlineLarge?.copyWith(
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              )
                              : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      authState.user!.displayName ?? 'SellaTrack User',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (authState.user!.email != null)
                      Text(
                        authState.user!.email!,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              _buildProfileDetailRow(
                context,
                Icons.person_outline,
                'Full Name',
                authState.user!.displayName,
              ),
              if (authState.user!.email != null)
                _buildProfileDetailRow(
                  context,
                  Icons.email_outlined,
                  'Email Address',
                  authState.user!.email,
                ),
              if (authState.user!.phoneNumber != null)
                _buildProfileDetailRow(
                  context,
                  Icons.phone_outlined,
                  'Phone Number',
                  authState.user!.phoneNumber,
                ),
              _buildProfileDetailRow(
                context,
                Icons.vpn_key_outlined,
                'User ID',
                authState.user!.uid,
              ),
              const Divider(),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit Profile'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: theme.colorScheme.secondaryContainer,
                  foregroundColor: theme.colorScheme.onSecondaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  context.goNamed(AppRoutePaths.updateProfileNamed);
                },
              ),
            ] else
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'User information not available. Please try logging in again.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

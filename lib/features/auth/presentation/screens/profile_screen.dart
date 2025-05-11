import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sellatrack/core/navigation/app_router.dart';
import 'package:sellatrack/features/auth/presentation/notifiers/auth_state.dart';
import 'package:sellatrack/features/auth/presentation/providers/auth_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);

    ref.listen<AuthScreenState>(authNotifierProvider, (previous, next) {
      if (next.status == AuthStatus.unauthenticated) {
        context.go(AppRoutePaths.authentication);
      }
      if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.goNamed(AppRoutePaths.updateProfileNamed);
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authNotifier.signOut();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            authState.user != null
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('UID: ${authState.user!.uid}'),
                    const SizedBox(height: 8),
                    Text(
                      'Display Name: ${authState.user!.displayName ?? 'Not set'}',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Phone: ${authState.user!.phoneNumber ?? 'Not available'}',
                    ),
                    const SizedBox(height: 8),
                    Text('Email: ${authState.user!.email ?? 'Not set'}'),
                  ],
                )
                : const Center(child: Text('No user data found.')),
      ),
    );
  }
}

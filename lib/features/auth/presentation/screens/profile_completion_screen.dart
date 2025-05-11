import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sellatrack/core/navigation/app_router.dart';

class ProfileCompletionScreen extends StatelessWidget {
  const ProfileCompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Profile Completion Screen'),
            const SizedBox(height: 20),
            // TODO: Add TextField for display name and other profile fields
            ElevatedButton(
              onPressed: () {
                // TODO: Add logic to save profile information first
                // (e.g., call UpdateUserProfileUseCase)
                // For now, directly navigate for testing
                context.go(AppRoutePaths.profile);
              },
              child: const Text('Save Profile & Go to Profile (Test)'),
            ),
          ],
        ),
      ),
    );
  }
}

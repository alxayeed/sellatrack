import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sellatrack/core/navigation/app_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          // Adding an edit button to the AppBar is a common pattern
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.goNamed(AppRoutePaths.updateProfileNamed);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Profile Screen'),
            const SizedBox(height: 20),
            // You would display user profile information here
            // e.g., Text('Name: ${user.displayName}'),
            const SizedBox(height: 20),
            ElevatedButton(
              // Alternative: A button in the body
              onPressed: () {
                context.goNamed(AppRoutePaths.updateProfileNamed);
              },
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

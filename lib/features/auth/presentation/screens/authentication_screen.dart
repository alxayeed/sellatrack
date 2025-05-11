import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import go_router
import 'package:sellatrack/core/navigation/app_router.dart'; // Import your route paths

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Authentication')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Authentication Screen'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Add logic to actually send OTP first
                context.go(AppRoutePaths.otp);
              },
              child: const Text('Go to OTP Screen (Test)'),
            ),
          ],
        ),
      ),
    );
  }
}

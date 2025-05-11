import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sellatrack/core/navigation/app_router.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter OTP')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('OTP Screen'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Add logic to verify OTP first
                // For now, directly navigate to profile completion for testing
                context.go(AppRoutePaths.profileCompletion);
              },
              child: const Text('Go to Complete Profile (Test)'),
            ),
          ],
        ),
      ),
    );
  }
}

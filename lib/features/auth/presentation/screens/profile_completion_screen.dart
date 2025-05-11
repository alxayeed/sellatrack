import 'package:flutter/material.dart';

class ProfileCompletionScreen extends StatelessWidget {
  const ProfileCompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Profile')),
      body: const Center(child: Text('Profile Completion Screen')),
    );
  }
}

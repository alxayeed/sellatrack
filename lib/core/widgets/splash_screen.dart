import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sellatrack/core/navigation/app_router.dart';

import '../constants/app_colors.dart';
import '../styles/app_text_styles.dart'; // For AppRoutePaths

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToAuth();
  }

  void _navigateToAuth() {
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        context.go(AppRoutePaths.authentication);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.storefront_outlined,
              size: 80,
              color: AppColors.primaryDarker,
            ),
            SizedBox(height: 24),
            Text('SellaTrack', style: AppTextStyles.headlineLarge),
          ],
        ),
      ),
    );
  }
}

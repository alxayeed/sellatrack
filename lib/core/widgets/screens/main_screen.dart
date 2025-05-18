import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sellatrack/core/widgets/app_layout/app_drawer_widget.dart';
import 'package:sellatrack/core/widgets/app_layout/bottom_nav_bar_widget.dart';
import 'package:sellatrack/core/widgets/app_layout/custom_app_bar.dart';

import '../../constants/app_strings.dart';
import '../../navigation/app_router.dart';

class MainScreen extends StatelessWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.startsWith(AppRoutePaths.sales)) return 0;
    if (location.startsWith(AppRoutePaths.home)) return 1;
    if (location.startsWith(AppRoutePaths.stocks)) return 2;

    return 0; // default to sales
  }

  void _onBottomNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutePaths.sales);
        break;
      case 1:
        context.go(AppRoutePaths.home);
        break;
      case 2:
        context.go(AppRoutePaths.stocks);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getSelectedIndex(context);

    return Scaffold(
      appBar: CustomAppBar(title: AppStrings.appName),
      drawer: const AppDrawerWidget(),
      body: child,
      bottomNavigationBar: BottomNavBarWidget(
        currentIndex: currentIndex,
        onTap: (index) => _onBottomNavTap(context, index),
      ),
    );
  }
}

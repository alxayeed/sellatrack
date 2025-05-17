import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sellatrack/core/widgets/app_layout/app_drawer_widget.dart';
import 'package:sellatrack/core/widgets/app_layout/bottom_nav_bar_widget.dart';
import 'package:sellatrack/core/widgets/app_layout/custom_app_bar.dart';

import '../../constants/app_strings.dart';
// We'll use a standard AppBar here for now, CustomAppBar can be integrated if needed.

class MainScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell; // Provided by GoRouter

  const MainScreen({super.key, required this.navigationShell});

  void _onBottomNavTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  // String _getTitleForIndex(int index) {
  //   switch (index) {
  //     case 0:
  //       return 'Sales Dashboard'; // AppStrings.salesTitle
  //     case 1:
  //       return 'Stock Management'; // AppStrings.stocksTitle
  //     case 2:
  //       return 'My Profile'; // AppStrings.profileTitle
  //     default:
  //       return 'SellaTrack'; // AppStrings.appName
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.appName,
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       context.push(AppRoutePaths.profile);
        //     },
        //     icon: Icon(Icons.person),
        //   ),
        // ],
      ),

      drawer: const AppDrawerWidget(),
      // Add the drawer
      body: navigationShell,
      // This is where the child route's screen is displayed
      bottomNavigationBar: BottomNavBarWidget(
        currentIndex: navigationShell.currentIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
}

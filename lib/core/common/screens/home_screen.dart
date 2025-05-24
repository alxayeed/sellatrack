import 'package:flutter/material.dart';
import 'package:sellatrack/core/common/app_layout/app_drawer_widget.dart';
// We'll use a standard AppBar here for now, CustomAppBar can be integrated if needed.

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // void _onBottomNavTap(int index) {
  //   navigationShell.goBranch(
  //     index,
  //     initialLocation: index == navigationShell.currentIndex,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // appBar: CustomAppBar(title: AppStrings.appName),
      // appBar: AppBar(
      //   // Using standard AppBar, can be replaced with CustomAppBar
      //   title: Text(_getTitleForIndex(navigationShell.currentIndex)),
      //   centerTitle: true,
      // ),
      drawer: const AppDrawerWidget(),
      // Add the drawer
      body: Center(
        child: SingleChildScrollView(
          // Added SingleChildScrollView for smaller screens
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.storefront_outlined,
                size: 80,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Welcome to SellaTrack!',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Manage your sales, expenses, and customers.', // Updated text
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),

      // This is where the child route's screen is displayed
      // bottomNavigationBar: BottomNavBarWidget(
      //   currentIndex: navigationShell.currentIndex,
      //   onTap: _onBottomNavTap,
      // ),
    );
  }
}

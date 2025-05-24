import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../navigation/app_router.dart';
import '../app_layout/app_drawer_widget.dart';

class MainScreen extends StatelessWidget {
  final Widget child;
  final String location;

  const MainScreen({super.key, required this.child, required this.location});

  // Top-level screens (no back button)
  bool get isRootRoute =>
      location == AppRoutePaths.sales ||
      location == AppRoutePaths.home ||
      location == AppRoutePaths.stocks;

  String getAppBarTitle() {
    if (location.contains(AppRoutePaths.addSaleNamed)) {
      return 'Add Sale';
    } else if (location.contains(AppRoutePaths.editSaleSubPath)) {
      return 'Edit Sale';
    } else if (location.contains(AppRoutePaths.saleDetailNamed)) {
      return 'Sale Detail';
    } else if (location.startsWith(AppRoutePaths.sales)) {
      return 'Sales';
    } else if (location.startsWith(AppRoutePaths.stocks)) {
      return 'Stocks';
    } else if (location.startsWith(AppRoutePaths.home)) {
      return 'Home';
    }
    return 'Sellatrack';
  }

  int getSelectedIndex() {
    if (location.startsWith(AppRoutePaths.sales)) return 0;
    if (location.startsWith(AppRoutePaths.home)) return 1;
    if (location.startsWith(AppRoutePaths.stocks)) return 2;
    return 0;
  }

  void onTabSelected(BuildContext context, int index) {
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
    final selectedIndex = getSelectedIndex();
    final title = getAppBarTitle();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        leading:
            isRootRoute
                ? null
                : IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                ),
      ),
      body: child,
      drawer: const AppDrawerWidget(),
      bottomNavigationBar:
          isRootRoute
              ? BottomNavigationBar(
                currentIndex: selectedIndex,
                onTap: (index) => onTabSelected(context, index),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.sell),
                    label: 'Sales',
                  ),

                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),

                  BottomNavigationBarItem(
                    icon: Icon(Icons.store),
                    label: 'Stocks',
                  ),
                ],
              )
              : null,
    );
  }
}

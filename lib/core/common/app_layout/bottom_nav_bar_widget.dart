import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNavBarWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBarWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      // Or .shifting if you prefer animation
      selectedItemColor:
          theme.bottomNavigationBarTheme.selectedItemColor ??
          theme.colorScheme.primary,
      unselectedItemColor:
          theme.bottomNavigationBarTheme.unselectedItemColor ??
          theme.colorScheme.onSurfaceVariant,
      selectedFontSize:
          theme.bottomNavigationBarTheme.selectedLabelStyle?.fontSize ?? 12.sp,
      unselectedFontSize:
          theme.bottomNavigationBarTheme.unselectedLabelStyle?.fontSize ??
          12.sp,
      backgroundColor:
          theme.bottomNavigationBarTheme.backgroundColor ??
          theme.colorScheme.surface,
      elevation: theme.bottomNavigationBarTheme.elevation ?? 8.0,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.point_of_sale_outlined),
          activeIcon: Icon(Icons.point_of_sale),
          label: 'Sales', // Use AppStrings.sales
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home', // Use AppStrings.profile
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2_outlined),
          activeIcon: Icon(Icons.inventory_2),
          label: 'Stocks', // Use AppStrings.stocks
        ),
      ],
    );
  }
}

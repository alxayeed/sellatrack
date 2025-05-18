import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../navigation/app_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor; // For title and icons
  final double elevation;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0.5, // Default subtle elevation
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
          onPressed: () {
            context.push(AppRoutePaths.profile);
          },
          icon: Icon(Icons.person),
        ),
      ],
      leading: leading,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      elevation: elevation,
      titleTextStyle: theme.appBarTheme.titleTextStyle,
      iconTheme: theme.appBarTheme.iconTheme,
      actionsIconTheme: theme.appBarTheme.actionsIconTheme,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight.h);
}

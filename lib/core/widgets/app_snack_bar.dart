import 'package:flutter/material.dart';

class AppSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    IconData? icon,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final snackBar = SnackBar(
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
          ],
          Expanded(child: Text(message)),
        ],
      ),
      duration: duration,
      backgroundColor:
          backgroundColor ??
          Theme.of(context).colorScheme.secondaryContainer, // Default color
      behavior: SnackBarBehavior.floating,
      // margin: const EdgeInsets.all(10),
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showError(BuildContext context, {required String message}) {
    show(
      context,
      message: message,
      backgroundColor: Theme.of(context).colorScheme.error,
      icon: Icons.error_outline,
    );
  }

  static void showSuccess(BuildContext context, {required String message}) {
    show(
      context,
      message: message,
      backgroundColor: Colors.green,
      icon: Icons.check_circle_outline,
    );
  }

  static void showInfo(BuildContext context, {required String message}) {
    show(
      context,
      message: message,
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      icon: Icons.info_outline,
    );
  }
}

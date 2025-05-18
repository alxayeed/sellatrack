import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'button_defs.dart';

class CustomIconButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData iconData;
  final String? tooltip;
  final IconButtonType type;
  final double? customSize; // Overrides default sizes

  const CustomIconButtonWidget({
    super.key,
    required this.onPressed,
    required this.iconData,
    this.tooltip,
    this.type = IconButtonType.standard,
    this.customSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color? iconColor;
    double iconSize;
    EdgeInsetsGeometry padding = EdgeInsets.all(8.r);

    switch (type) {
      case IconButtonType.primary:
        iconColor = theme.colorScheme.primary;
        iconSize = customSize ?? 24.sp;
        break;
      case IconButtonType.subtle:
        iconColor = theme.colorScheme.onSurfaceVariant;
        iconSize = customSize ?? 20.sp;
        padding = EdgeInsets.all(6.r);
        break;
      case IconButtonType.standard:
        iconColor = theme.iconTheme.color;
        iconSize = customSize ?? theme.iconTheme.size ?? 24.sp;
        break;
    }

    return IconButton(
      icon: Icon(iconData),
      iconSize: iconSize,
      color: iconColor,
      tooltip: tooltip,
      padding: padding,
      splashRadius: iconSize * 0.8,
      // Adjust splash radius based on icon size
      constraints: BoxConstraints(
        minWidth: iconSize * 1.5,
        minHeight: iconSize * 1.5,
      ),
      onPressed: onPressed,
    );
  }
}

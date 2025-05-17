import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'button_defs.dart'; // Assuming ButtonSize is defined here or elsewhere shared

class CustomTextButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Widget? leadingIcon; // Text buttons usually don't have trailing icons
  final bool isLoading;
  final ButtonSize size;
  final Color? customColor;

  const CustomTextButtonWidget({
    super.key,
    required this.onPressed,
    required this.text,
    this.leadingIcon,
    this.isLoading = false,
    this.size = ButtonSize.medium,
    this.customColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    TextStyle? effectiveTextStyle;
    EdgeInsetsGeometry? padding;

    Color fgColor =
        customColor ??
        theme.textButtonTheme.style?.foregroundColor?.resolve({}) ??
        theme.colorScheme.primary;

    switch (size) {
      case ButtonSize.small:
        effectiveTextStyle = theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
        );
        padding = EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h);
        break;
      case ButtonSize.large:
        effectiveTextStyle = theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.bold,
        );
        padding = EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h);
        break;
      case ButtonSize.medium:
        effectiveTextStyle =
            theme.textButtonTheme.style?.textStyle?.resolve({}) ??
            theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600);
        padding =
            theme.textButtonTheme.style?.padding?.resolve({}) ??
            EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h);
        break;
    }
    effectiveTextStyle = effectiveTextStyle?.copyWith(color: fgColor);

    Widget buttonChild;
    if (isLoading) {
      buttonChild = SizedBox(
        width: (effectiveTextStyle?.fontSize ?? 12.sp),
        height: (effectiveTextStyle?.fontSize ?? 12.sp),
        child: CircularProgressIndicator(
          strokeWidth: 1.5,
          valueColor: AlwaysStoppedAnimation<Color>(fgColor),
        ),
      );
    } else {
      List<Widget> children = [];
      if (leadingIcon != null) {
        children.add(leadingIcon!);
        if (text.isNotEmpty) children.add(SizedBox(width: 4.w));
      }
      if (text.isNotEmpty) {
        children.add(Text(text));
      }
      buttonChild = Row(mainAxisSize: MainAxisSize.min, children: children);
    }

    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: fgColor,
        textStyle: effectiveTextStyle,
        padding: padding,
        shape:
            theme.textButtonTheme.style?.shape?.resolve({}) ??
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        minimumSize: theme.textButtonTheme.style?.minimumSize?.resolve({}),
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.hovered)) {
            return fgColor.withOpacity(0.08);
          }
          if (states.contains(WidgetState.focused) ||
              states.contains(WidgetState.pressed)) {
            return fgColor.withOpacity(0.12);
          }
          return null;
        }),
      ),
      onPressed: isLoading ? null : onPressed,
      child: buttonChild,
    );
  }
}

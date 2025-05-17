import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'button_defs.dart';

class CustomOutlinedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool isLoading;
  final ButtonType type;
  final ButtonSize size;
  final bool expand;

  const CustomOutlinedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.expand = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color? fgColor;
    Color? sideColor;
    TextStyle? effectiveTextStyle;
    EdgeInsetsGeometry? padding;
    double? minHeight;

    switch (type) {
      case ButtonType.destructive:
        fgColor = theme.colorScheme.error;
        sideColor = theme.colorScheme.error;
        break;
      case ButtonType.secondary:
        fgColor = theme.colorScheme.onSurfaceVariant;
        sideColor = theme.colorScheme.outline;
        break;
      case ButtonType.primary:
        fgColor =
            theme.outlinedButtonTheme.style?.foregroundColor?.resolve({}) ??
            theme.colorScheme.primary;
        sideColor =
            theme.outlinedButtonTheme.style?.side?.resolve({})?.color ??
            theme.colorScheme.primary;
        break;
      case ButtonType.custom:
        // TODO: Handle this case.
        throw UnimplementedError();
    }

    switch (size) {
      case ButtonSize.small:
        effectiveTextStyle = theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
        );
        padding = EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h);
        minHeight = 36.h;
        break;
      case ButtonSize.large:
        effectiveTextStyle = theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.bold,
        );
        padding = EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h);
        minHeight = 52.h;
        break;
      case ButtonSize.medium:
        effectiveTextStyle =
            theme.outlinedButtonTheme.style?.textStyle?.resolve({}) ??
            theme.textTheme.labelLarge;
        padding =
            theme.outlinedButtonTheme.style?.padding?.resolve({}) ??
            EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h);
        minHeight = 48.h;
        break;
    }
    effectiveTextStyle = effectiveTextStyle?.copyWith(color: fgColor);

    Widget buttonChild;
    if (isLoading) {
      buttonChild = SizedBox(
        width: (effectiveTextStyle?.fontSize ?? 14.sp) * 1.2,
        height: (effectiveTextStyle?.fontSize ?? 14.sp) * 1.2,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(fgColor),
        ),
      );
    } else {
      List<Widget> children = [];
      if (leadingIcon != null) {
        children.add(leadingIcon!);
        if (text.isNotEmpty) children.add(SizedBox(width: 8.w));
      }
      if (text.isNotEmpty) {
        children.add(
          Flexible(child: Text(text, overflow: TextOverflow.ellipsis)),
        );
      }
      if (trailingIcon != null) {
        if (text.isNotEmpty || leadingIcon != null)
          children.add(SizedBox(width: 8.w));
        children.add(trailingIcon!);
      }
      buttonChild = Row(mainAxisSize: MainAxisSize.min, children: children);
    }

    final buttonStyle = OutlinedButton.styleFrom(
      foregroundColor: fgColor,
      side: BorderSide(
        color: sideColor,
        width: size == ButtonSize.small ? 1.0 : 1.5,
      ),
      textStyle: effectiveTextStyle,
      padding: padding,
      minimumSize: Size(
        expand ? double.infinity : (size == ButtonSize.small ? 80.w : 100.w),
        minHeight,
      ),
      shape:
          theme.outlinedButtonTheme.style?.shape?.resolve({}) ??
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
    ).copyWith(
      overlayColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.hovered)) {
          return fgColor?.withOpacity(0.08);
        }
        if (states.contains(WidgetState.focused) ||
            states.contains(WidgetState.pressed)) {
          return fgColor?.withOpacity(0.12);
        }
        return null;
      }),
    );

    return OutlinedButton(
      style: buttonStyle,
      onPressed: isLoading ? null : onPressed,
      child: buttonChild,
    );
  }
}

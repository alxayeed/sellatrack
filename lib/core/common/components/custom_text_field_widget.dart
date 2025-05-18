import 'package:flutter/material.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText; // Still useful for specific labels
  final String? hintText;
  final Widget? prefixIcon; // Keep for common icons like email, person
  final Widget? suffixIcon; // Keep for password visibility toggle etc.
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final int? maxLines; // Allow for slight variation if not using CustomTextArea
  final TextCapitalization textCapitalization;
  final String? initialValue;
  final AutovalidateMode? autovalidateMode;

  const CustomTextFieldWidget({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.maxLines = 1,
    this.textCapitalization = TextCapitalization.none,
    this.initialValue,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      enabled: enabled,
      maxLines: obscureText ? 1 : maxLines,
      textCapitalization: textCapitalization,
      style: Theme.of(context).textTheme.bodyLarge,
      autovalidateMode: autovalidateMode ?? AutovalidateMode.onUserInteraction,
    );
  }
}

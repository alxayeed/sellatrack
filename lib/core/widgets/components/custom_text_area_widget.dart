import 'package:flutter/material.dart';

class CustomTextAreaWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int minLines;
  final int? maxLines; // Keep null for auto-expand
  final bool enabled;
  final String? initialValue;
  final AutovalidateMode? autovalidateMode;

  const CustomTextAreaWidget({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.validator,
    this.onChanged,
    this.minLines = 3,
    this.maxLines = 5,
    this.enabled = true,
    this.initialValue,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // Directly use TextFormField
      controller: controller,
      initialValue: initialValue,
      decoration: InputDecoration(labelText: labelText, hintText: hintText),
      keyboardType: TextInputType.multiline,
      minLines: minLines,
      maxLines: maxLines,
      validator: validator,
      onChanged: onChanged,
      enabled: enabled,
      textCapitalization: TextCapitalization.sentences,
      style: Theme.of(context).textTheme.bodyLarge,
      autovalidateMode: autovalidateMode ?? AutovalidateMode.onUserInteraction,
    );
  }
}

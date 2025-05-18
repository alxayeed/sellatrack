import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomNumberInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final String? suffixText; // For units
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool allowDecimal;
  final bool enabled;
  final String? initialValue;
  final AutovalidateMode? autovalidateMode;

  const CustomNumberInputField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixText,
    this.validator,
    this.onChanged,
    this.allowDecimal = true,
    this.enabled = true,
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
        suffixText: suffixText,
      ),
      keyboardType: TextInputType.numberWithOptions(
        decimal: allowDecimal,
        signed:
            false, // Typically numbers are not negative in forms unless specified
      ),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(
          allowDecimal ? RegExp(r'^\d*\.?\d*') : RegExp(r'^\d*'),
        ),
      ],
      validator: validator,
      onChanged: onChanged,
      enabled: enabled,
      style: Theme.of(context).textTheme.bodyLarge,
      autovalidateMode: autovalidateMode ?? AutovalidateMode.onUserInteraction,
    );
  }
}

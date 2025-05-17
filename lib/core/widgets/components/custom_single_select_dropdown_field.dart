import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DropdownOption<T> {
  final T value;
  final String label;
  final Widget? leadingIcon;

  DropdownOption({required this.value, required this.label, this.leadingIcon});
}

class CustomSingleSelectDropdownField<T> extends StatelessWidget {
  final String? labelText;
  final String hintText; // Essential for when no value is selected
  final T? value;
  final List<DropdownOption<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final Widget? prefixIcon; // Keep prefix icon if desired for consistency
  final bool enabled;
  final String? restorationId;

  const CustomSingleSelectDropdownField({
    super.key,
    this.labelText,
    required this.hintText,
    this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.prefixIcon,
    this.enabled = true,
    this.restorationId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DropdownButtonFormField<T>(
      value: value,
      items:
          items.map<DropdownMenuItem<T>>((DropdownOption<T> option) {
            return DropdownMenuItem<T>(
              value: option.value,
              child: Row(
                children: [
                  if (option.leadingIcon != null) ...[
                    option.leadingIcon!,
                    SizedBox(width: 8.w),
                  ],
                  Expanded(
                    child: Text(option.label, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            );
          }).toList(),
      onChanged: enabled ? onChanged : null,
      validator: validator,
      isExpanded: true,
      // Usually good for form fields
      decoration: InputDecoration(
        labelText: labelText,
        hintText: value == null ? hintText : null,
        // Show hint only if value is null
        prefixIcon: prefixIcon,
      ),
      icon: Icon(
        Icons.arrow_drop_down_rounded,
        color: enabled ? theme.colorScheme.primary : theme.disabledColor,
      ),
      dropdownColor: theme.cardColor,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: enabled ? null : theme.disabledColor,
      ),
      disabledHint:
          value != null
              ? Text(
                items
                    .firstWhere(
                      (item) => item.value == value,
                      orElse:
                          () => DropdownOption(value: value as T, label: '...'),
                    )
                    .label,
              )
              : Text(hintText, style: TextStyle(color: theme.disabledColor)),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // restorationId: restorationId,
    );
  }
}

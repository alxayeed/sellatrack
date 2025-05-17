import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateSelectorField extends StatefulWidget {
  final String labelText;
  final DateTime? initialDate;
  final Function(DateTime?) onDateSelected;
  final String? Function(DateTime?)? validator;
  final bool enabled;
  final String? hintText; // Keep hintText for when no date is selected

  const CustomDateSelectorField({
    super.key,
    required this.labelText,
    this.initialDate,
    required this.onDateSelected,
    this.validator,
    this.enabled = true,
    this.hintText,
  });

  @override
  State<CustomDateSelectorField> createState() =>
      _CustomDateSelectorFieldState();
}

class _CustomDateSelectorFieldState extends State<CustomDateSelectorField> {
  DateTime? _selectedDate;
  late TextEditingController _controller;
  final DateFormat _displayFormat = DateFormat.yMMMd();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _controller = TextEditingController(
      text: _selectedDate != null ? _displayFormat.format(_selectedDate!) : '',
    );
  }

  @override
  void didUpdateWidget(CustomDateSelectorField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDate != oldWidget.initialDate &&
        widget.initialDate != _selectedDate) {
      setState(() {
        _selectedDate = widget.initialDate;
        _controller.text =
            _selectedDate != null ? _displayFormat.format(_selectedDate!) : '';
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    if (!widget.enabled) return;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _controller.text = _displayFormat.format(picked);
      });
      widget.onDateSelected(picked);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      readOnly: true,
      onTap: () => _selectDate(context),
      enabled: widget.enabled,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText:
            _controller.text.isEmpty
                ? (widget.hintText ?? 'Select Date')
                : null,
        suffixIcon: Icon(
          Icons.calendar_today_outlined,
          color:
              widget.enabled
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).disabledColor,
        ),
      ),
      validator: (value) {
        if (widget.validator != null) {
          return widget.validator!(_selectedDate);
        }
        return null;
      },
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: widget.enabled ? null : Theme.of(context).disabledColor,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}

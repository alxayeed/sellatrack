import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomTimeSelectorField extends StatefulWidget {
  final String labelText;
  final TimeOfDay? initialTime;
  final Function(TimeOfDay?) onTimeSelected;
  final String? Function(TimeOfDay?)? validator;
  final bool enabled;
  final String? hintText;

  const CustomTimeSelectorField({
    super.key,
    required this.labelText,
    this.initialTime,
    required this.onTimeSelected,
    this.validator,
    this.enabled = true,
    this.hintText,
  });

  @override
  State<CustomTimeSelectorField> createState() =>
      _CustomTimeSelectorFieldState();
}

class _CustomTimeSelectorFieldState extends State<CustomTimeSelectorField> {
  TimeOfDay? _selectedTime;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
    _controller = TextEditingController(
      text: _selectedTime != null ? _formatTimeOfDay(_selectedTime!) : '',
    );
  }

  @override
  void didUpdateWidget(CustomTimeSelectorField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTime != oldWidget.initialTime &&
        widget.initialTime != _selectedTime) {
      setState(() {
        _selectedTime = widget.initialTime;
        _controller.text =
            _selectedTime != null ? _formatTimeOfDay(_selectedTime!) : '';
      });
    }
  }

  String _formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    return DateFormat.jm().format(dt);
  }

  Future<void> _selectTime(BuildContext context) async {
    if (!widget.enabled) return;
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _controller.text = _formatTimeOfDay(picked);
      });
      widget.onTimeSelected(picked);
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
      onTap: () => _selectTime(context),
      enabled: widget.enabled,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText:
            _controller.text.isEmpty
                ? (widget.hintText ?? 'Select Time')
                : null,
        suffixIcon: Icon(
          Icons.access_time_outlined,
          color:
              widget.enabled
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).disabledColor,
        ),
      ),
      validator: (value) {
        if (widget.validator != null) {
          return widget.validator!(_selectedTime);
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

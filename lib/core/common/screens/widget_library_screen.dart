import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sellatrack/core/common/components/button_defs.dart';
import 'package:sellatrack/core/common/components/custom_date_selector_field.dart';
import 'package:sellatrack/core/common/components/custom_elevated_button.dart';
import 'package:sellatrack/core/common/components/custom_icon_button_widget.dart';
import 'package:sellatrack/core/common/components/custom_number_input_field.dart';
import 'package:sellatrack/core/common/components/custom_outlined_button.dart';
import 'package:sellatrack/core/common/components/custom_single_select_dropdown_field.dart';
import 'package:sellatrack/core/common/components/custom_text_area_widget.dart';
import 'package:sellatrack/core/common/components/custom_text_button_widget.dart';
import 'package:sellatrack/core/common/components/custom_text_field_widget.dart';
import 'package:sellatrack/core/common/components/custom_time_selector_field.dart';

class WidgetLibraryScreen extends StatefulWidget {
  const WidgetLibraryScreen({super.key});

  @override
  State<WidgetLibraryScreen> createState() => _WidgetLibraryScreenState();
}

class _WidgetLibraryScreenState extends State<WidgetLibraryScreen> {
  bool _buttonsLoading = false;
  bool _fieldsEnabled = true;
  String? _selectedDropdownValue;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final List<DropdownOption<String>> _dropdownOptions = [
    DropdownOption(value: 'opt1', label: 'Option 1'),
    DropdownOption(value: 'opt2', label: 'Option 2 - A Bit Longer'),
    DropdownOption(
      value: 'opt3',
      label: 'Option 3',
      leadingIcon: const Icon(Icons.star, size: 16),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Widget Library'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionTitle(context, 'Buttons'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text("Loading State:"),
                    Switch(
                      value: _buttonsLoading,
                      onChanged: (value) {
                        setState(() {
                          _buttonsLoading = value;
                        });
                      },
                      activeColor: theme.colorScheme.primary,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.h),
            _buildSectionTitle(context, 'CustomElevatedButton', isSub: true),
            _buildButtonRow([
              CustomElevatedButton(
                onPressed: () {},
                text: 'Small',
                size: ButtonSize.small,
                isLoading: _buttonsLoading,
              ),
              CustomElevatedButton(
                onPressed: () {},
                text: 'Medium',
                size: ButtonSize.medium,
                isLoading: _buttonsLoading,
              ),
              CustomElevatedButton(
                onPressed: () {},
                text: 'Large',
                size: ButtonSize.large,
                isLoading: _buttonsLoading,
              ),
            ]),
            SizedBox(height: 8.h),
            _buildButtonRow([
              CustomElevatedButton(
                onPressed: () {},
                text: 'Secondary',
                type: ButtonType.secondary,
                isLoading: _buttonsLoading,
              ),
              CustomElevatedButton(
                onPressed: () {},
                text: 'Destructive',
                type: ButtonType.destructive,
                isLoading: _buttonsLoading,
              ),
            ]),
            SizedBox(height: 8.h),
            CustomElevatedButton(
              onPressed: () {},
              text: 'Expanded Icon',
              expand: true,
              isLoading: _buttonsLoading,
              leadingIcon: Icon(Icons.add, size: 18.sp),
            ),
            SizedBox(height: 8.h),
            CustomElevatedButton(
              onPressed: () {},
              text: 'With Icons',
              isLoading: _buttonsLoading,
              leadingIcon: Icon(Icons.star_border, size: 18.sp),
              trailingIcon: Icon(Icons.arrow_forward_ios, size: 16.sp),
            ),

            SizedBox(height: 16.h),
            _buildSectionTitle(context, 'CustomOutlinedButton', isSub: true),
            _buildButtonRow([
              CustomOutlinedButton(
                onPressed: () {},
                text: 'Small',
                size: ButtonSize.small,
                isLoading: _buttonsLoading,
              ),
              CustomOutlinedButton(
                onPressed: () {},
                text: 'Medium',
                size: ButtonSize.medium,
                isLoading: _buttonsLoading,
              ),
              CustomOutlinedButton(
                onPressed: () {},
                text: 'Large',
                size: ButtonSize.large,
                isLoading: _buttonsLoading,
              ),
            ]),
            SizedBox(height: 8.h),
            _buildButtonRow([
              CustomOutlinedButton(
                onPressed: () {},
                text: 'Secondary',
                type: ButtonType.secondary,
                isLoading: _buttonsLoading,
              ),
              CustomOutlinedButton(
                onPressed: () {},
                text: 'Destructive',
                type: ButtonType.destructive,
                isLoading: _buttonsLoading,
              ),
            ]),
            SizedBox(height: 8.h),
            CustomOutlinedButton(
              onPressed: () {},
              text: 'Expanded Icon',
              expand: true,
              isLoading: _buttonsLoading,
              leadingIcon: Icon(Icons.settings, size: 18.sp),
            ),

            SizedBox(height: 16.h),
            _buildSectionTitle(context, 'CustomTextButtonWidget', isSub: true),
            _buildButtonRow([
              CustomTextButtonWidget(
                onPressed: () {},
                text: 'Small',
                size: ButtonSize.small,
                isLoading: _buttonsLoading,
              ),
              CustomTextButtonWidget(
                onPressed: () {},
                text: 'Medium',
                size: ButtonSize.medium,
                isLoading: _buttonsLoading,
              ),
              CustomTextButtonWidget(
                onPressed: () {},
                text: 'Large',
                size: ButtonSize.large,
                isLoading: _buttonsLoading,
              ),
            ]),
            SizedBox(height: 8.h),
            _buildButtonRow([
              CustomTextButtonWidget(
                onPressed: () {},
                text: 'With Icon',
                leadingIcon: Icon(Icons.info_outline, size: 16.sp),
                isLoading: _buttonsLoading,
              ),
              CustomTextButtonWidget(
                onPressed: () {},
                text: 'Custom Color',
                customColor: Colors.orangeAccent,
                isLoading: _buttonsLoading,
              ),
            ]),

            SizedBox(height: 16.h),
            _buildSectionTitle(context, 'CustomIconButtonWidget', isSub: true),
            _buildButtonRow([
              CustomIconButtonWidget(
                onPressed: () {},
                iconData: Icons.home,
                tooltip: 'Home',
                type: IconButtonType.primary,
              ),
              CustomIconButtonWidget(
                onPressed: () {},
                iconData: Icons.search,
                tooltip: 'Search',
              ),
              CustomIconButtonWidget(
                onPressed: () {},
                iconData: Icons.notifications,
                tooltip: 'Notifications',
                type: IconButtonType.subtle,
              ),
              CustomIconButtonWidget(
                onPressed: () {},
                iconData: Icons.settings,
                tooltip: 'Settings',
                customSize: 32.sp,
              ),
              CustomIconButtonWidget(
                onPressed: _buttonsLoading ? null : () {},
                iconData: Icons.delete_forever,
                tooltip: 'Action (affected by loading)',
              ),
            ]),

            const Divider(thickness: 1, height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionTitle(context, 'Form Fields'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text("Enable: "),
                    Switch(
                      value: _fieldsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _fieldsEnabled = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 8.h),

            _buildSectionTitle(context, 'CustomTextFieldWidget', isSub: true),
            CustomTextFieldWidget(
              labelText: 'Name',
              hintText: 'Enter your full name',
              prefixIcon: const Icon(Icons.person_outline),
              enabled: _fieldsEnabled,
              validator:
                  (val) => (val?.isEmpty ?? true) ? 'Name required' : null,
            ),
            SizedBox(height: 12.h),
            CustomTextFieldWidget(
              labelText: 'Password (Obscured)',
              hintText: 'Enter password',
              prefixIcon: const Icon(Icons.lock_outline),
              obscureText: true,
              enabled: _fieldsEnabled,
              suffixIcon: const Icon(Icons.visibility_off_outlined),
            ),

            SizedBox(height: 16.h),
            _buildSectionTitle(context, 'CustomTextAreaWidget', isSub: true),
            CustomTextAreaWidget(
              labelText: 'Description',
              hintText: 'Enter item description...',
              minLines: 2,
              maxLines: 4,
              enabled: _fieldsEnabled,
            ),

            SizedBox(height: 16.h),
            _buildSectionTitle(context, 'CustomNumberInputField', isSub: true),
            CustomNumberInputField(
              labelText: 'Price',
              hintText: '0.00',
              prefixIcon: const Icon(Icons.attach_money_outlined),
              allowDecimal: true,
              enabled: _fieldsEnabled,
            ),
            SizedBox(height: 12.h),
            CustomNumberInputField(
              labelText: 'Quantity (Integer only)',
              hintText: '0',
              allowDecimal: false,
              enabled: _fieldsEnabled,
            ),

            SizedBox(height: 16.h),
            _buildSectionTitle(context, 'CustomDateSelectorField', isSub: true),
            CustomDateSelectorField(
              labelText: 'Purchase Date',
              hintText: 'Tap to select date',
              initialDate: _selectedDate,
              onDateSelected: (date) {
                setState(() => _selectedDate = date);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Date Selected: $date')));
              },
              enabled: _fieldsEnabled,
              validator: (date) => date == null ? 'Date required' : null,
            ),

            SizedBox(height: 16.h),
            _buildSectionTitle(context, 'CustomTimeSelectorField', isSub: true),
            CustomTimeSelectorField(
              labelText: 'Pickup Time',
              hintText: 'Tap to select time',
              initialTime: _selectedTime,
              onTimeSelected: (time) {
                setState(() => _selectedTime = time);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Time Selected: ${time?.format(context)}'),
                  ),
                );
              },
              enabled: _fieldsEnabled,
            ),

            SizedBox(height: 16.h),
            _buildSectionTitle(
              context,
              'CustomSingleSelectDropdownField',
              isSub: true,
            ),
            CustomSingleSelectDropdownField<String>(
              labelText: 'Category',
              hintText: 'Select a category',
              value: _selectedDropdownValue,
              items: _dropdownOptions,
              onChanged: (value) {
                setState(() {
                  _selectedDropdownValue = value;
                });
              },
              prefixIcon: const Icon(Icons.category_outlined),
              enabled: _fieldsEnabled,
              validator: (val) => val == null ? 'Category required' : null,
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    String title, {
    bool isSub = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: isSub ? 8.h : 16.h, bottom: 8.h),
      child: Text(
        title,
        style:
            isSub
                ? Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.secondary,
                )
                : Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildButtonRow(List<Widget> buttons) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      alignment: WrapAlignment.start,
      children: buttons,
    );
  }
}

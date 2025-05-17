import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sellatrack/core/widgets/components/button_defs.dart';
import 'package:sellatrack/core/widgets/components/custom_elevated_button.dart';
import 'package:sellatrack/core/widgets/components/custom_icon_button_widget.dart';
import 'package:sellatrack/core/widgets/components/custom_outlined_button.dart';
import 'package:sellatrack/core/widgets/components/custom_text_button_widget.dart';

class WidgetLibraryScreen extends StatefulWidget {
  const WidgetLibraryScreen({super.key});

  @override
  State<WidgetLibraryScreen> createState() => _WidgetLibraryScreenState();
}

class _WidgetLibraryScreenState extends State<WidgetLibraryScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Library'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Switch(
              value: _isLoading,
              onChanged: (value) {
                setState(() {
                  _isLoading = value;
                });
              },
              activeColor: theme.colorScheme.primary,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Text("Loading"),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSectionTitle(context, 'CustomElevatedButton'),
            _buildButtonRow([
              CustomElevatedButton(
                onPressed: () {},
                text: 'Primary Small',
                size: ButtonSize.small,
                isLoading: _isLoading,
              ),
              CustomElevatedButton(
                onPressed: () {},
                text: 'Primary Medium',
                size: ButtonSize.medium,
                isLoading: _isLoading,
              ),
              CustomElevatedButton(
                onPressed: () {},
                text: 'Primary Large',
                size: ButtonSize.large,
                isLoading: _isLoading,
              ),
            ]),
            SizedBox(height: 8.h),
            _buildButtonRow([
              CustomElevatedButton(
                onPressed: () {},
                text: 'Secondary',
                type: ButtonType.secondary,
                isLoading: _isLoading,
              ),
              CustomElevatedButton(
                onPressed: () {},
                text: 'Destructive',
                type: ButtonType.destructive,
                isLoading: _isLoading,
              ),
            ]),
            SizedBox(height: 8.h),
            CustomElevatedButton(
              onPressed: () {},
              text: 'Primary Expanded',
              expand: true,
              isLoading: _isLoading,
              leadingIcon: Icon(Icons.add_shopping_cart, size: 18.sp),
            ),
            SizedBox(height: 8.h),
            CustomElevatedButton(
              onPressed: () {},
              text: 'With Icons',
              isLoading: _isLoading,
              leadingIcon: Icon(Icons.star_border, size: 18.sp),
              trailingIcon: Icon(Icons.arrow_forward_ios, size: 16.sp),
            ),

            const Divider(height: 32),
            _buildSectionTitle(context, 'CustomOutlinedButton'),
            _buildButtonRow([
              CustomOutlinedButton(
                onPressed: () {},
                text: 'Primary Small',
                size: ButtonSize.small,
                isLoading: _isLoading,
              ),
              CustomOutlinedButton(
                onPressed: () {},
                text: 'Primary Medium',
                size: ButtonSize.medium,
                isLoading: _isLoading,
              ),
              CustomOutlinedButton(
                onPressed: () {},
                text: 'Primary Large',
                size: ButtonSize.large,
                isLoading: _isLoading,
              ),
            ]),
            SizedBox(height: 8.h),
            _buildButtonRow([
              CustomOutlinedButton(
                onPressed: () {},
                text: 'Secondary',
                type: ButtonType.secondary,
                isLoading: _isLoading,
              ),
              CustomOutlinedButton(
                onPressed: () {},
                text: 'Destructive',
                type: ButtonType.destructive,
                isLoading: _isLoading,
              ),
            ]),
            SizedBox(height: 8.h),
            CustomOutlinedButton(
              onPressed: () {},
              text: 'Outlined Expanded',
              expand: true,
              isLoading: _isLoading,
              leadingIcon: Icon(Icons.settings_outlined, size: 18.sp),
            ),

            const Divider(height: 32),
            _buildSectionTitle(context, 'CustomTextButtonWidget'),
            _buildButtonRow([
              CustomTextButtonWidget(
                onPressed: () {},
                text: 'Text Small',
                size: ButtonSize.small,
                isLoading: _isLoading,
              ),
              CustomTextButtonWidget(
                onPressed: () {},
                text: 'Text Medium',
                size: ButtonSize.medium,
                isLoading: _isLoading,
              ),
              CustomTextButtonWidget(
                onPressed: () {},
                text: 'Text Large',
                size: ButtonSize.large,
                isLoading: _isLoading,
              ),
            ]),
            SizedBox(height: 8.h),
            _buildButtonRow([
              CustomTextButtonWidget(
                onPressed: () {},
                text: 'With Icon',
                leadingIcon: Icon(Icons.info_outline, size: 16.sp),
                isLoading: _isLoading,
              ),
              CustomTextButtonWidget(
                onPressed: () {},
                text: 'Custom Color',
                customColor: Colors.deepOrange,
                isLoading: _isLoading,
              ),
            ]),

            const Divider(height: 32),
            _buildSectionTitle(context, 'CustomIconButtonWidget'),
            _buildButtonRow([
              CustomIconButtonWidget(
                onPressed: () {},
                iconData: Icons.home_outlined,
                tooltip: 'Home',
                type: IconButtonType.primary,
              ),
              CustomIconButtonWidget(
                onPressed: () {},
                iconData: Icons.search_outlined,
                tooltip: 'Search',
              ),
              CustomIconButtonWidget(
                onPressed: () {},
                iconData: Icons.notifications_none_outlined,
                tooltip: 'Notifications',
                type: IconButtonType.subtle,
              ),
              CustomIconButtonWidget(
                onPressed: () {},
                iconData: Icons.settings_outlined,
                tooltip: 'Settings',
                customSize: 32.sp,
              ),
              CustomIconButtonWidget(
                onPressed: null,
                iconData: Icons.disabled_by_default_outlined,
                tooltip: 'Disabled',
              ),
            ]),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Text(
        title,
        style: Theme.of(
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

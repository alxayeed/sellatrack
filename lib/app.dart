import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import ConsumerWidget
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sellatrack/core/navigation/app_router.dart';

import 'core/constants/app_strings.dart';
import 'core/styles/app_theme.dart';

class SellaTrackApp extends ConsumerWidget {
  const SellaTrackApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    const Size designScreenSize = Size(375, 812);

    return ScreenUtilInit(
      designSize: designScreenSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: AppStrings.appName,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          // Or from a provider
          routerConfig: router,
          builder: (context, widget) {
            // You can set a global text scale factor if needed,
            // but ScreenUtil handles adaptation.
            // ScreenUtil.init(context);
            return widget!;
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/config/app_config.dart';
import 'core/navigation/app_router.dart';
import 'core/styles/app_theme.dart';

class SellaTrackApp extends ConsumerWidget {
  final AppConfig config;

  const SellaTrackApp({super.key, required this.config});

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
          debugShowCheckedModeBanner: config.enableConsoleLogs,
          title: 'SellaTrack (${config.flavor})',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          routerConfig: router,
          builder: (context, widget) => widget!,
        );
      },
    );
  }
}

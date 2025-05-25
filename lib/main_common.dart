import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sellatrack/app.dart';
import 'package:sellatrack/core/config/app_config.dart';
import 'package:sellatrack/core/logging/talker.dart';
import 'package:sellatrack/firebase_options.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';

import 'core/di/providers.dart';

Future<void> runAppWithConfig(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (config.enableRemoteLogs) {
    FlutterError.onError = (details) {
      // TODO: integrate FirebaseCrashlytics/Sentry here
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      // TODO: integrate FirebaseCrashlytics/Sentry here
      return true;
    };
  } else {
    FlutterError.onError = (FlutterErrorDetails details) {
      talker.handle(details.exception, details.stack, 'FlutterError.onError');
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      talker.handle(error, stack, 'PlatformDispatcher.onError');
      return true;
    };
  }

  runApp(
    ProviderScope(
      overrides: [appConfigProvider.overrideWithValue(config)],
      observers:
          config.enableConsoleLogs
              ? [
                TalkerRiverpodObserver(
                  talker: talker,
                  settings: const TalkerRiverpodLoggerSettings(
                    printProviderAdded: true,
                    printProviderDisposed: true,
                    printProviderUpdated: true,
                  ),
                ),
              ]
              : [],
      child: SellaTrackApp(config: config),
    ),
  );
}

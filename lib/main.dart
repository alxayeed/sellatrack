import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'; // For PlatformDispatcher
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sellatrack/app.dart';
import 'package:sellatrack/core/logging/talker.dart';
import 'package:sellatrack/firebase_options.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  runZonedGuarded<Future<void>>(
    () async {
      await initializeApp();

      FlutterError.onError = (FlutterErrorDetails details) {
        talker.handle(details.exception, details.stack, 'FlutterError.onError');
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        talker.handle(error, stack, 'PlatformDispatcher.onError');
        return true;
      };

      runApp(
        ProviderScope(
          observers: [
            TalkerRiverpodObserver(
              talker: talker,
              settings: const TalkerRiverpodLoggerSettings(
                printProviderAdded: true,
                printProviderDisposed: true,
                printProviderUpdated: true,
              ),
            ),
          ],
          child: const SellaTrackApp(),
        ),
      );
    },
    (error, stackTrace) {
      talker.handle(error, stackTrace, 'runZonedGuarded error');
    },
  );
}

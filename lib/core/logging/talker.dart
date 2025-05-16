import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';

final talker = TalkerFlutter.init(
  settings: TalkerSettings(
    enabled: true,
    useHistory: true,
    maxHistoryItems: 200,
    useConsoleLogs: true,
  ),
  logger: TalkerLogger(
    settings: TalkerLoggerSettings(
      // Customize log levels for console output etc.
    ),
    formatter: const ColoredLoggerFormatter(),
  ),
);

final talkerProvider = Provider<Talker>((ref) => talker);

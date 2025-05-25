// // core/utils/firebase_utils.dart
//
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sellatrack/core/config/app_config.dart';
//
// String collectionName(AppConfig config, String baseName) {
//   return config.isDev ? '${baseName}_dev' : baseName;
// }
//
// String collectionNameFromRef(WidgetRef ref, String baseName) {
//   return collectionName(ref.read(appConfigProvider), baseName);
// }

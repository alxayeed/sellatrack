class AppConfig {
  final String flavor;
  final String? baseUrl;
  final bool enableConsoleLogs;
  final bool enableRemoteLogs;

  const AppConfig({
    required this.flavor,
    this.baseUrl,
    this.enableConsoleLogs = false,
    this.enableRemoteLogs = false,
  });

  // Convenience getters for environment checks
  bool get isDev => flavor == 'dev';

  bool get isProd => flavor == 'prod';

  String collectionName(String baseName) {
    return isDev ? '${baseName}_dev' : baseName;
  }

  // Static named configs for easy access
  static const dev = AppConfig(
    flavor: 'dev',
    baseUrl: null,
    enableConsoleLogs: true,
    enableRemoteLogs: false,
  );

  static const prod = AppConfig(
    flavor: 'prod',
    baseUrl: null,
    enableConsoleLogs: false,
    enableRemoteLogs: true,
  );
}

enum Build { production, testing }

class AppConfig {
  static String? token;
  static const Build server = Build.testing;
  static bool get isProduction => server == Build.production;
  static String get baseUrl {
    switch (server) {
      case Build.testing:
        return 'https://logistics-api.ufc-app.com';

      case Build.production:
        return 'https://logistics-api.ufc-app.com';
    }
  }
}

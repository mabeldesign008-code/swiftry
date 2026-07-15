class Env {
  Env._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.swiftree.com/v1',
  );

  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: '',
  );

  static const String flavor = String.fromEnvironment(
    'FLAVOR',
    defaultValue: 'development',
  );

  static bool get isDevelopment => flavor == 'development';
  static bool get isProduction => flavor == 'production';

  static const double defaultLat = 5.6037;
  static const double defaultLng = -0.1870;
}

/// Vendor Env Config - mirrors customer but for vendor app

class Env {
  Env._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.swiftree.com/v1',
  );
  static const String apiStagingUrl = String.fromEnvironment(
    'API_STAGING_URL',
    defaultValue: 'https://staging-api.swiftree.com/v1',
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
  static bool get isStaging => flavor == 'staging';
  static bool get isProduction => flavor == 'production';

  static const bool enableMockSimulation = bool.fromEnvironment(
    'ENABLE_MOCK_SIMULATION',
    defaultValue: true,
  );

  static const double defaultLat = 5.6037; // Accra, Ghana
  static const double defaultLng = -0.1870;
}

class EnvValidator {
  static List<String> validate() {
    final warnings = <String>[];
    if (Env.googleMapsApiKey.isEmpty) {
      warnings.add('GOOGLE_MAPS_API_KEY empty - vendor map features may fail');
    }
    return warnings;
  }
}

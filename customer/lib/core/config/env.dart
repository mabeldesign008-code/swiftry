/// Environment configuration - frontend only, backend team fills values.
/// Uses --dart-define to inject at build time, with safe defaults for dev.

class Env {
  Env._();

  // -- API
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.swiftree.com/v1',
  );
  static const String apiStagingUrl = String.fromEnvironment(
    'API_STAGING_URL',
    defaultValue: 'https://staging-api.swiftree.com/v1',
  );

  // -- Google Maps / Places
  // TODO Backend/DevOps: Pass via --dart-define=GOOGLE_MAPS_API_KEY=xxx
  // For local dev, create a .env file and use flutter_dotenv (optional)
  // Never commit real keys.
  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: '',
  );

  static const String googleMapsSessionToken = String.fromEnvironment(
    'GOOGLE_MAPS_SESSION_TOKEN',
    defaultValue: 'swiftry-session',
  );

  // -- Environment flavor
  static const String flavor = String.fromEnvironment(
    'FLAVOR',
    defaultValue: 'development', // development | staging | production
  );

  static bool get isDevelopment => flavor == 'development';
  static bool get isStaging => flavor == 'staging';
  static bool get isProduction => flavor == 'production';

  // -- Feature flags
  static const bool enableMockSimulation = bool.fromEnvironment(
    'ENABLE_MOCK_SIMULATION',
    defaultValue: true, // Keep true until backend real-time is ready
  );

  // -- Map config
  static const String osmTileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String osmUserAgent = 'swiftree.app';

  // -- Location defaults (Ghana - corrected from previous Nigeria label)
  static const double defaultLat = 5.6037; // Accra, Ghana
  static const double defaultLng = -0.1870;
  static const double kumasiLat = 6.6884; // Kumasi, Ghana
  static const double kumasiLng = -1.6244;
  static const String defaultLocationName = 'Accra, Ghana';
}

/// Validation helper for env setup
class EnvValidator {
  static List<String> validate() {
    final warnings = <String>[];
    if (Env.googleMapsApiKey.isEmpty) {
      warnings.add(
        'GOOGLE_MAPS_API_KEY is empty - Place autocomplete will fail. '
        'Run with --dart-define=GOOGLE_MAPS_API_KEY=YOUR_KEY',
      );
    }
    return warnings;
  }
}

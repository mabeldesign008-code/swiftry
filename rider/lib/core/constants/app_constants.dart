/// Rider App Constants - Ghana launch

class AppConstants {
  AppConstants._();

  static const String appName = 'Swiftry Rider';
  static const String appVersion = '1.0.0';

  // API
  static const String apiBaseUrl = 'https://api.swiftree.com/v1';
  static const String apiStagingUrl = 'https://staging-api.swiftree.com/v1';

  // Storage keys
  static const String keyToken = 'rider_auth_token';
  static const String keyRefreshToken = 'rider_refresh_token';
  static const String keyRiderId = 'rider_id';
  static const String keyOnboardingDone = 'rider_onboarding_done';
  static const String keyIsOnline = 'rider_is_online';

  // Map defaults - Accra, Ghana
  static const double defaultLat = 5.6037;
  static const double defaultLng = -0.1870;
  static const double defaultZoom = 14.0;

  // Delivery config
  static const double maxDeliveryRadiusKm = 20.0;
  static const int locationUpdateIntervalSec = 5;
  static const double arrivalThresholdMeters = 50.0;

  // Order stages for rider perspective
  static const List<String> riderStages = [
    'assigned',
    'heading_to_pickup',
    'arrived_at_pickup',
    'picked_up',
    'heading_to_dropoff',
    'arrived_at_dropoff',
    'delivered',
  ];

  // Delivery proof types
  static const List<String> proofTypes = ['otp', 'photo', 'signature'];

  // Error messages
  static const String errorGeneric = 'Something went wrong';
  static const String errorNoInternet = 'No internet connection';
  static const String errorLocationPermission = 'Location permission required';

  // Ghana regions
  static const List<String> GhanaRegions = [
    'Greater Accra',
    'Ashanti',
    'Western',
    'Central',
    'Eastern',
    'Northern',
    'Upper East',
    'Upper West',
    'Volta',
  ];
}

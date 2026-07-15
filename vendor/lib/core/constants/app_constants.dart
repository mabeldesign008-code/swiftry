/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App information
  static const String appName = 'swiftree Vendor';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String apiBaseUrl = 'https://api.swiftree.com/v1';
  static const String apiTimeout = '30000'; // 30 seconds
  static const int apiTimeoutMs = 30000;

  // Storage keys
  static const String keyToken = 'auth_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyVendorId = 'vendor_id';
  static const String keyBusinessType = 'business_type';
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Image upload
  static const int maxImageSizeMB = 5;
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png', 'webp'];

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minBusinessNameLength = 3;
  static const int maxBusinessNameLength = 100;
  static const int maxDescriptionLength = 500;

  // Nigeria specific
  static const String countryCode = '+233';
  static const int phoneNumberLength = 9; // Without country code

  // Business types
  static const String businessTypeRestaurant = 'restaurant';
  static const String businessTypeGroceries = 'groceries';
  static const String businessTypeMarket = 'market';
  static const String businessTypePharmacy = 'pharmacy';
  static const String businessTypeRetail = 'retail';
  static const String businessTypeLaundry = 'laundry';

  static const List<String> businessTypes = [
    businessTypeRestaurant,
    businessTypeGroceries,
    businessTypeMarket,
    businessTypePharmacy,
    businessTypeRetail,
    businessTypeLaundry,
  ];

  // Order statuses (dynamic based on business type)
  // Restaurant
  static const List<String> orderStagesRestaurant = [
    'new',
    'preparing',
    'ready',
    'completed',
  ];

  // Groceries
  static const List<String> orderStagesGroceries = [
    'new',
    'picking',
    'packed',
    'completed',
  ];

  // Market
  static const List<String> orderStagesMarket = [
    'new',
    'weighing',
    'packed',
    'completed',
  ];

  // Pharmacy
  static const List<String> orderStagesPharmacy = [
    'new',
    'rx_check',
    'approved',
    'dispensing',
    'completed',
  ];

  // Retail
  static const List<String> orderStagesRetail = [
    'new',
    'packing',
    'ready',
    'completed',
  ];

  // Laundry
  static const List<String> orderStagesLaundry = [
    'collected',
    'sorting',
    'washing',
    'drying',
    'qc',
    'completed',
  ];

  // Animation durations
  static const Duration animationDurationShort = Duration(milliseconds: 200);
  static const Duration animationDurationMedium = Duration(milliseconds: 300);
  static const Duration animationDurationLong = Duration(milliseconds: 500);

  // Debounce duration for search
  static const Duration searchDebounceDuration = Duration(milliseconds: 500);

  // Cache durations
  static const Duration cacheShortDuration = Duration(minutes: 5);
  static const Duration cacheMediumDuration = Duration(minutes: 30);
  static const Duration cacheLongDuration = Duration(hours: 24);

  // Map defaults
  static const double defaultLatitude = 5.6037; // Accra, Nigeria
  static const double defaultLongitude = -0.1870;
  static const double defaultZoom = 13.0;

  // Rating
  static const double minRating = 1.0;
  static const double maxRating = 5.0;
  static const double ratingStep = 0.5;

  // Nigeria regions
  static const List<String> NigeriaRegions = [
    'Greater Accra',
    'Ashanti',
    'Western',
    'Central',
    'Eastern',
    'Northern',
    'Upper East',
    'Upper West',
    'Volta',
    'Brong-Ahafo',
  ];

  // Major Nigeria cities
  static const List<String> NigeriaCities = [
    'Accra',
    'Kumasi',
    'Takoradi',
    'Cape Coast',
    'Tamale',
    'Bolgatanga',
    'Wa',
    'Koforidua',
    'Ho',
    'Sunyani',
  ];

  // Date formats
  static const String dateFormatDisplay = 'MMM dd, yyyy';
  static const String dateFormatFull = 'MMMM dd, yyyy';
  static const String timeFormatDisplay = 'hh:mm a';
  static const String dateTimeFormatFull = 'MMM dd, yyyy hh:mm a';

  // Error messages
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork = 'No internet connection. Please check your network.';
  static const String errorTimeout = 'Request timeout. Please try again.';
  static const String errorUnauthorized = 'Session expired. Please login again.';
  static const String errorNotFound = 'Resource not found.';
  static const String errorServerError = 'Server error. Please try again later.';

  // Success messages
  static const String successSaved = 'Changes saved successfully';
  static const String successCreated = 'Created successfully';
  static const String successUpdated = 'Updated successfully';
  static const String successDeleted = 'Deleted successfully';

  // Chart defaults
  static const int chartMaxDataPoints = 30;
  static const double chartBarWidth = 12.0;
  static const double chartLineStrokeWidth = 3.0;
}

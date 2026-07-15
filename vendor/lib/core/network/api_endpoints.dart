/// Vendor API endpoints contract

class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String vendorLogin = '/vendor/auth/login';
  static const String vendorRegister = '/vendor/auth/register';
  static const String vendorRefresh = '/vendor/auth/refresh';
  static const String vendorMe = '/vendor/me';

  // Registration (5-step)
  static const String registrationStatus = '/vendor/registration/status';
  static const String registrationSubmit = '/vendor/registration/submit';
  static const String uploadDocument = '/vendor/documents/upload';

  // Dashboard
  static const String dashboardStats = '/vendor/dashboard/stats';
  static const String revenueChart = '/vendor/dashboard/revenue';
  static const String storeStatus = '/vendor/store/status';
  static String toggleStore(String vendorId) => '/vendor/$vendorId/toggle';

  // Orders (vendor side - different views than customer)
  static const String vendorOrders = '/vendor/orders';
  static String vendorOrderById(String id) => '/vendor/orders/$id';
  static String acceptOrder(String id) => '/vendor/orders/$id/accept';
  static String rejectOrder(String id) => '/vendor/orders/$id/reject';
  static String updateOrderStage(String id) => '/vendor/orders/$id/stage';
  static const String orderIssues = '/vendor/orders/issues';

  // Menu / Products
  static const String vendorProducts = '/vendor/products';
  static String productById(String id) => '/vendor/products/$id';
  static const String categories = '/vendor/categories';
  static String categoryById(String id) => '/vendor/categories/$id';
  static const String productOptions = '/vendor/products/options';

  // Store settings
  static const String storeProfile = '/vendor/store/profile';
  static const String storePhotos = '/vendor/store/photos';
  static const String operatingHours = '/vendor/store/hours';
  static const String preparationTime = '/vendor/store/prep-time';
  static const String locationDelivery = '/vendor/store/location';
  static const String notificationSettings = '/vendor/store/notifications';

  // Wallet / Earnings
  static const String earnings = '/vendor/wallet/earnings';
  static const String transactions = '/vendor/wallet/transactions';
  static const String withdraw = '/vendor/wallet/withdraw';
  static const String settlementSchedule = '/vendor/wallet/settlements';

  // Analytics
  static const String productAnalytics = '/vendor/analytics/products';
  static const String stories = '/vendor/stories';
  static String storyById(String id) => '/vendor/stories/$id';
  static const String promotions = '/vendor/promotions';
  static const String promotionInsights = '/vendor/promotions/insights';

  // Ratings
  static const String ratings = '/vendor/ratings';
  static String respondToReview(String reviewId) => '/vendor/ratings/$reviewId/respond';

  // Support
  static const String helpCenter = '/vendor/support/help';
  static const String supportChat = '/vendor/support/chat';

  // Notifications
  static const String notifications = '/vendor/notifications';
}

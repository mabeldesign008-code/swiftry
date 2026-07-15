class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String riderLogin = '/rider/auth/login';
  static const String riderRegister = '/rider/auth/register';
  static const String sendOtp = '/rider/auth/otp/send';
  static const String verifyOtp = '/rider/auth/otp/verify';
  static const String refresh = '/rider/auth/refresh';

  // Rider profile
  static const String me = '/rider/me';
  static const String availability = '/rider/availability';
  static const String locationUpdate = '/rider/location';

  // Orders - rider view
  static const String incomingOrders = '/rider/orders/incoming';
  static const String activeOrders = '/rider/orders/active';
  static const String orderHistory = '/rider/orders/history';
  static String orderById(String id) => '/rider/orders/$id';
  static String acceptOrder(String id) => '/rider/orders/$id/accept';
  static String rejectOrder(String id) => '/rider/orders/$id/reject';
  static String updateStage(String id) => '/rider/orders/$id/stage';
  static String uploadProof(String id) => '/rider/orders/$id/proof';
  static String reportIssue(String id) => '/rider/orders/$id/issue';

  // Earnings
  static const String earnings = '/rider/earnings';
  static const String transactions = '/rider/earnings/transactions';
  static const String withdraw = '/rider/earnings/withdraw';

  // Support
  static const String support = '/rider/support';
}

/// Centralized API endpoint definitions - frontend contract for backend team.
/// All paths are relative to apiBaseUrl.
/// Backend team: Implement these exact contracts.

class ApiEndpoints {
  ApiEndpoints._();

  // --- Auth
  static const String requestOtp = '/auth/otp/request';
  static const String verifyOtp = '/auth/otp/verify';
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String socialLogin = '/auth/social';
  static const String forgotPassword = '/auth/forgot-password';

  // --- User / Profile
  static const String me = '/users/me';
  static const String updateProfile = '/users/me';
  static const String savedAddresses = '/users/me/addresses';

  // --- Vendors
  static const String vendors = '/vendors';
  static String vendorById(String id) => '/vendors/$id';
  static String vendorProducts(String vendorId) => '/vendors/$vendorId/products';
  static String vendorReviews(String vendorId) => '/vendors/$vendorId/reviews';
  static String vendorStories(String vendorId) => '/vendors/$vendorId/stories';
  static const String vendorStoriesAll = '/stories';

  // --- Products / Catalog
  static const String products = '/products';
  static String productById(String id) => '/products/$id';
  static const String categories = '/categories';
  static const String search = '/search';
  static const String searchSuggestions = '/search/suggestions';

  // --- Orders (all service types)
  static const String orders = '/orders';
  static String orderById(String id) => '/orders/$id';
  static String orderCancel(String id) => '/orders/$id/cancel';
  static String orderTrack(String id) => '/orders/$id/track';
  static String orderRate(String id) => '/orders/$id/rate';
  static const String activeOrders = '/orders/active';
  static const String orderHistory = '/orders/history';

  // --- Cart
  static const String cart = '/cart';
  static const String cartClear = '/cart/clear';

  // --- Payments
  static const String paymentMethods = '/payments/methods';
  static const String wallet = '/wallet';
  static const String walletTransactions = '/wallet/transactions';
  static const String walletTopUp = '/wallet/topup';
  static const String vouchers = '/vouchers';
  static const String validateVoucher = '/vouchers/validate';

  // --- Parcel
  static const String parcelQuote = '/parcel/quote';

  // --- Laundry
  static const String laundryServices = '/laundry/services';

  // --- Bill Payment
  static const String billTypes = '/bills/types';
  static const String billVerify = '/bills/verify';
  static const String billPay = '/bills/pay';

  // --- Errand / Agent
  static const String errandTasks = '/errands';
  static String errandById(String id) => '/errands/$id';

  // --- Rider (for customer tracking)
  static String riderLocation(String orderId) => '/orders/$orderId/rider-location';
  static String riderInfo(String orderId) => '/orders/$orderId/rider';

  // --- Notifications
  static const String notifications = '/notifications';
  static const String notificationsRead = '/notifications/read';

  // --- Places
  static const String placesAutocomplete = '/places/autocomplete';
  static const String placeDetails = '/places/details';
  static const String reverseGeocode = '/places/reverse-geocode';

  // --- Chat
  static String orderChat(String orderId) => '/orders/$orderId/chat';
  static const String supportChat = '/support/chat';

  // --- Uploads
  static const String uploadImage = '/uploads/image';
  static const String uploadReceipt = '/uploads/receipt';
}

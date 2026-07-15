import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../models/order.dart';
import '../../models/service_type.dart';

/// Order service - central contract for creating and tracking orders across all service types.
/// Frontend prepared for backend - currently calls mocked delay then returns order.
/// Backend team: Implement endpoints matching ApiEndpoints.

class OrderService {
  final Dio _dio = ApiClient().dio;

  /// Create new order - handles all service types (food, groceries, parcel, laundry, errand, bill, queue)
  /// POST /orders
  /// Body includes: service_type, items, address, vendor_id, fees, payment_method, scheduled_for, etc.
  Future<ApiResult<Order>> createOrder(Order order) async {
    try {
      // TODO Backend: Replace with real POST
      // final response = await _dio.post(
      //   ApiEndpoints.orders,
      //   data: order.toJson(), // Need to implement Order.toJson() fully for all types
      // );
      // final data = ApiClient.handleResponse(response);
      // return ApiSuccess(Order.fromJson(data['order'] ?? data));

      // Frontend mock: simulate network latency and return same order with server-generated ID
      // In production, backend should generate order ID (not client)
      await Future.delayed(const Duration(seconds: 1));
      
      // Simulate server assigning a proper ID if client used temporary one
      // For now keep client ID but backend TODO: return server ID
      return ApiSuccess(order);
    } on DioException catch (e) {
      return ApiFailure(ApiClient.handleError(e), statusCode: e.response?.statusCode);
    }
  }

  /// Get order by ID
  /// GET /orders/:id
  Future<ApiResult<Order>> getOrder(String orderId) async {
    try {
      // TODO Backend
      // final response = await _dio.get(ApiEndpoints.orderById(orderId));
      // return ApiSuccess(Order.fromJson(response.data));

      await Future.delayed(const Duration(milliseconds: 500));
      return const ApiFailure('Order not cached - fetch from orderHistoryProvider', statusCode: 404);
    } on DioException catch (e) {
      return ApiFailure(ApiClient.handleError(e), statusCode: e.response?.statusCode);
    }
  }

  /// List active orders
  /// GET /orders/active
  Future<ApiResult<List<Order>>> getActiveOrders() async {
    try {
      // TODO Backend
      // final response = await _dio.get(ApiEndpoints.activeOrders);
      // final list = (response.data['orders'] as List).map((j)=>Order.fromJson(j)).toList();
      // return ApiSuccess(list);

      await Future.delayed(const Duration(milliseconds: 300));
      return const ApiSuccess([]);
    } on DioException catch (e) {
      return ApiFailure(ApiClient.handleError(e));
    }
  }

  /// List order history (past + active)
  /// GET /orders/history?page=1&limit=10
  Future<ApiResult<List<Order>>> getOrderHistory({int page = 1, int limit = 20}) async {
    try {
      // TODO Backend
      // final response = await _dio.get(ApiEndpoints.orderHistory, queryParameters: {'page': page, 'limit': limit});
      await Future.delayed(const Duration(milliseconds: 300));
      return const ApiSuccess([]);
    } on DioException catch (e) {
      return ApiFailure(ApiClient.handleError(e));
    }
  }

  /// Cancel order
  /// POST /orders/:id/cancel { reason }
  Future<ApiResult<Order>> cancelOrder(String orderId, {required String reason}) async {
    try {
      // TODO Backend
      // final response = await _dio.post(ApiEndpoints.orderCancel(orderId), data: {'reason': reason});
      // return ApiSuccess(Order.fromJson(response.data));

      await Future.delayed(const Duration(milliseconds: 800));
      // Mock failure if already in terminal state - caller should check local state
      return const ApiFailure('Cancel mocked - update local provider', statusCode: 200);
    } on DioException catch (e) {
      return ApiFailure(ApiClient.handleError(e));
    }
  }

  /// Track order - get rider location + status timeline
  /// GET /orders/:id/track
  Future<ApiResult<Map<String, dynamic>>> trackOrder(String orderId) async {
    try {
      // TODO Backend: Should return { status, timeline, rider_location, eta }
      // final response = await _dio.get(ApiEndpoints.orderTrack(orderId));
      await Future.delayed(const Duration(milliseconds: 400));
      return const ApiSuccess({
        'status': 'in_transit',
        'eta': '15-20 min',
        'rider': {'name': 'Kwame A.', 'phone': '+233***', 'rating': 4.8},
      });
    } on DioException catch (e) {
      return ApiFailure(ApiClient.handleError(e));
    }
  }

  /// Rate order after delivery
  /// POST /orders/:id/rate { rating, comment }
  Future<ApiResult<void>> rateOrder(String orderId, {required double rating, String? comment}) async {
    try {
      // TODO Backend
      // await _dio.post(ApiEndpoints.orderRate(orderId), data: {'rating': rating, 'comment': comment});
      await Future.delayed(const Duration(milliseconds: 500));
      return const ApiSuccess(null);
    } on DioException catch (e) {
      return ApiFailure(ApiClient.handleError(e));
    }
  }

  // --- Parcel specific ---

  /// Get parcel quote based on dimensions/weight/distance
  /// POST /parcel/quote { category, weight, dimensions, pickup, dropoff }
  Future<ApiResult<Map<String, dynamic>>> getParcelQuote({
    required String category,
    double? weightKg,
    Map<String, double>? dimensions,
    required String pickupAddress,
    required String dropoffAddress,
  }) async {
    try {
      // TODO Backend: Real quote calculation
      await Future.delayed(const Duration(milliseconds: 600));
      final distanceKm = 5.2; // mock
      final baseFee = 15.0;
      final weightFee = (weightKg ?? 1) * 2.0;
      return ApiSuccess({
        'distance_km': distanceKm,
        'delivery_fee': baseFee + weightFee,
        'estimated_time': '30-45 min',
        'breakdown': {'base': baseFee, 'weight': weightFee},
      });
    } on DioException catch (e) {
      return ApiFailure(ApiClient.handleError(e));
    }
  }

  // --- Bill specific ---

  /// Verify bill account/meter
  /// POST /bills/verify { bill_type, account_number }
  Future<ApiResult<Map<String, dynamic>>> verifyBill({
    required String billType,
    required String accountNumber,
  }) async {
    try {
      // TODO Backend: Real verification with ECG, Ghana Water, etc.
      await Future.delayed(const Duration(seconds: 2));
      return ApiSuccess({
        'verified': true,
        'account_name': 'Verified Account Holder',
        'outstanding': 0.0,
      });
    } on DioException catch (e) {
      return ApiFailure(ApiClient.handleError(e));
    }
  }
}

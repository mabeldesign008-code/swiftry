import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

/// Vendor / Product / Search services - frontend contract for backend.

class VendorService {
  final Dio _dio = ApiClient().dio;
  final Dio _cachedDio = ApiClient().cachedDio;

  /// List vendors with filters
  Future<ApiResult<List<Map<String, dynamic>>>> getVendors({
    String? serviceType,
    String? category,
    String? search,
    int page = 1,
    int limit = 20,
    String? sortBy,
    double? lat,
    double? lng,
  }) async {
    try {
      // TODO Backend: GET /vendors?type=food&category=...
      await Future.delayed(const Duration(milliseconds: 400));
      return const ApiSuccess([]);
    } on DioException catch (e) {
      return ApiFailure(ApiClient.handleError(e));
    }
  }

  Future<ApiResult<Map<String, dynamic>>> getVendorById(String vendorId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return const ApiFailure('Mock - use local data', statusCode: 404);
    } on DioException catch (e) {
      return ApiFailure(ApiClient.handleError(e));
    }
  }

  Future<ApiResult<List<Map<String, dynamic>>>> getVendorProducts(
    String vendorId, {
    String? category,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return const ApiSuccess([]);
    } on DioException catch (e) {
      return ApiFailure(ApiClient.handleError(e));
    }
  }
}

class SearchService {
  final Dio _dio = ApiClient().dio;

  Future<ApiResult<List<String>>> getSuggestions(String query) async {
    try {
      if (query.trim().isEmpty) return const ApiSuccess([]);
      // TODO Backend: GET /search/suggestions?q=
      await Future.delayed(const Duration(milliseconds: 200));
      return ApiSuccess([
        '$query restaurant',
        '$query near me',
        'Best $query in Accra',
      ]);
    } on DioException catch (e) {
      return ApiFailure(ApiClient.handleError(e));
    }
  }

  Future<ApiResult<List<Map<String, dynamic>>>> search({
    required String query,
    String? serviceType,
    double? lat,
    double? lng,
  }) async {
    try {
      // TODO Backend: GET /search?q=
      await Future.delayed(const Duration(milliseconds: 500));
      return const ApiSuccess([]);
    } on DioException catch (e) {
      return ApiFailure(ApiClient.handleError(e));
    }
  }
}

class PaymentService {
  final Dio _dio = ApiClient().dio;

  Future<ApiResult<List<Map<String, dynamic>>>> getPaymentMethods() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return const ApiSuccess([]);
    } on DioException catch (e) {
      return ApiFailure(ApiClient.handleError(e));
    }
  }

  Future<ApiResult<Map<String, dynamic>>> getWallet() async {
    try {
      // TODO Backend: GET /wallet
      await Future.delayed(const Duration(milliseconds: 300));
      return ApiSuccess({
        'balance': 150.0,
        'currency': 'GHS',
      });
    } on DioException catch (e) {
      return ApiFailure(ApiClient.handleError(e));
    }
  }

  Future<ApiResult<List<Map<String, dynamic>>>> getWalletTransactions() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return const ApiSuccess([]);
    } on DioException catch (e) {
      return ApiFailure(ApiClient.handleError(e));
    }
  }

  Future<ApiResult<Map<String, dynamic>>> validateVoucher(String code, double subtotal) async {
    try {
      // TODO Backend: POST /vouchers/validate { code, subtotal }
      await Future.delayed(const Duration(milliseconds: 400));
      if (code.toUpperCase() == 'YEN10') {
        return ApiSuccess({'valid': true, 'discount': subtotal * 0.10});
      }
      return ApiFailure('Invalid voucher code', statusCode: 400);
    } on DioException catch (e) {
      return ApiFailure(ApiClient.handleError(e));
    }
  }
}

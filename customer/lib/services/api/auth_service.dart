import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

/// Auth service abstraction - frontend ready for backend.
/// All methods are stubbed with mock delay + TODO for real implementation.
/// Backend team: Replace mock bodies with real Dio calls using ApiEndpoints.

class AuthService {
  final Dio _dio = ApiClient().dio;

  /// Request OTP for phone number
  /// POST /auth/otp/request { phone, country_code: +233 }
  Future<ApiResult<Map<String, dynamic>>> requestOtp({
    required String phone,
    String countryCode = '+233',
  }) async {
    try {
      // TODO Backend: Uncomment real call when endpoint ready
      // final response = await _dio.post(ApiEndpoints.requestOtp, data: {
      //   'phone': phone,
      //   'country_code': countryCode,
      // });
      // return ApiSuccess(ApiClient.handleResponse(response));

      // Mock for frontend dev
      await Future.delayed(const Duration(seconds: 1));
      return const ApiSuccess({'message': 'OTP sent', 'expires_in': 300});
    } on DioException catch (e) {
      return ApiFailure(ApiClient.handleError(e), statusCode: e.response?.statusCode);
    }
  }

  /// Verify OTP
  /// POST /auth/otp/verify { phone, code, session_id }
  Future<ApiResult<Map<String, dynamic>>> verifyOtp({
    required String phone,
    required String code,
    String? sessionId,
  }) async {
    try {
      // TODO Backend: Real call
      // final response = await _dio.post(ApiEndpoints.verifyOtp, data: {
      //   'phone': phone, 'code': code, 'session_id': sessionId
      // });
      // return ApiSuccess(response.data);

      await Future.delayed(const Duration(seconds: 1));
      // Mock: Any 4-digit code starting not with 0 is success
      if (code.length == 4) {
        return ApiSuccess({
          'access_token': 'mock_access_${DateTime.now().millisecondsSinceEpoch}',
          'refresh_token': 'mock_refresh_${DateTime.now().millisecondsSinceEpoch}',
          'user': {'id': 'user_${phone.hashCode}', 'phone': phone},
        });
      }
      return const ApiFailure('Invalid OTP code', statusCode: 400);
    } on DioException catch (e) {
      return ApiFailure(ApiClient.handleError(e), statusCode: e.response?.statusCode);
    }
  }

  /// Login with email/phone + password if needed later
  Future<ApiResult<Map<String, dynamic>>> login({
    required String identifier,
    String? password,
  }) async {
    // TODO Backend: Implement when needed
    await Future.delayed(const Duration(seconds: 1));
    return const ApiFailure('Not implemented - OTP flow is primary');
  }

  /// Refresh token
  Future<ApiResult<Map<String, dynamic>>> refreshToken(String refreshToken) async {
    try {
      // TODO Backend: Real call
      // final response = await _dio.post(ApiEndpoints.refreshToken, data: {'refresh_token': refreshToken});
      // return ApiSuccess(response.data);

      await Future.delayed(const Duration(milliseconds: 500));
      return ApiSuccess({
        'access_token': 'refreshed_access_${DateTime.now().millisecondsSinceEpoch}',
        'refresh_token': 'refreshed_refresh_${DateTime.now().millisecondsSinceEpoch}',
      });
    } on DioException catch (e) {
      return ApiFailure(ApiClient.handleError(e), statusCode: e.response?.statusCode);
    }
  }

  Future<ApiResult<void>> logout() async {
    try {
      // TODO Backend: POST logout to invalidate token
      // await _dio.post(ApiEndpoints.logout);
      await Future.delayed(const Duration(milliseconds: 300));
      return const ApiSuccess(null);
    } on DioException catch (e) {
      return ApiFailure(ApiClient.handleError(e));
    }
  }
}

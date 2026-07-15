import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import '../config/env.dart';
import '../storage/secure_storage_service.dart';
import 'api_interceptor.dart';

/// Centralized Dio client - frontend only, mocked until backend ready.
/// Backend team: Configures interceptors, timeouts, caching. Use this singleton.

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  Dio? _dio;
  Dio? _cachedDio; // For places etc with cache

  Dio get dio {
    _dio ??= _createDio();
    return _dio!;
  }

  Dio get cachedDio {
    _cachedDio ??= _createCachedDio();
    return _cachedDio!;
  }

  Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    final secureStorage = SecureStorageService();

    dio.interceptors.addAll([
      AuthInterceptor(secureStorage),
      LoggingInterceptor(),
      RetryInterceptor(dio: dio),
    ]);

    return dio;
  }

  Dio _createCachedDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    final secureStorage = SecureStorageService();

    // Cache options for idempotent GETs
    final cacheOptions = CacheOptions(
      store: MemCacheStore(),
      policy: CachePolicy.request,
      hitCacheOnErrorExcept: [401, 403],
      maxStale: const Duration(minutes: 30),
      priority: CachePriority.normal,
      keyBuilder: CacheOptions.defaultCacheKeyBuilder,
    );

    dio.interceptors.addAll([
      AuthInterceptor(secureStorage),
      DioCacheInterceptor(options: cacheOptions),
      LoggingInterceptor(),
    ]);

    return dio;
  }

  /// Helper for handling API responses consistently
  static Map<String, dynamic> handleResponse(Response response) {
    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      return {'data': response.data};
    }
    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      message: 'Request failed with status: ${response.statusCode}',
    );
  }

  /// Generic error handler
  static String handleError(DioException e) {
    if (e.response?.data is Map) {
      final data = e.response!.data as Map;
      if (data.containsKey('message')) return data['message'].toString();
      if (data.containsKey('error')) return data['error'].toString();
    }
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check internet.';
      case DioExceptionType.receiveTimeout:
        return 'Server not responding. Try again.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      default:
        return e.message ?? 'Something went wrong.';
    }
  }
}

/// Result wrapper for API calls - avoids throwing everywhere
sealed class ApiResult<T> {
  const ApiResult();
}

class ApiSuccess<T> extends ApiResult<T> {
  final T data;
  const ApiSuccess(this.data);
}

class ApiFailure<T> extends ApiResult<T> {
  final String message;
  final int? statusCode;
  const ApiFailure(this.message, {this.statusCode});
}

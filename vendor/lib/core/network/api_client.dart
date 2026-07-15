import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import '../config/env.dart';
import '../storage/secure_storage_service.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  Dio? _dio;
  Dio? _cachedDio;

  Dio get dio {
    _dio ??= _createDio();
    return _dio!;
  }

  Dio get cachedDio {
    _cachedDio ??= _createCached();
    return _cachedDio!;
  }

  Dio _createDio() {
    final dio = Dio(BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));

    dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final storage = SecureStorageService();
          final token = await storage.getToken();
          if (token != null) options.headers['Authorization'] = 'Bearer $token';
          options.headers['Accept'] = 'application/json';
          handler.next(options);
        },
      ),
    ]);
    return dio;
  }

  Dio _createCached() {
    final dio = Dio(BaseOptions(baseUrl: Env.apiBaseUrl));
    final cacheOptions = CacheOptions(
      store: MemCacheStore(),
      policy: CachePolicy.request,
      maxStale: const Duration(minutes: 15),
    );
    dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));
    return dio;
  }

  static String handleError(DioException e) {
    if (e.response?.data is Map && e.response!.data['message'] != null) {
      return e.response!.data['message'].toString();
    }
    return e.message ?? 'Something went wrong';
  }
}

sealed class ApiResult<T> {}
class ApiSuccess<T> extends ApiResult<T> {
  final T data;
  const ApiSuccess(this.data);
}
class ApiFailure<T> extends ApiResult<T> {
  final String message;
  final int? statusCode;
  const ApiFailure(this.message, {this.statusCode});
}

import 'package:dio/dio.dart';
import '../storage/secure_storage_service.dart';
import '../config/env.dart';

/// Dio interceptors for auth, logging, error handling.
/// Frontend-only: adds structure for backend team to implement token refresh.

class AuthInterceptor extends Interceptor {
  final SecureStorageService secureStorage;

  AuthInterceptor(this.secureStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Inject JWT if available
    final token = await secureStorage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Common headers
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';
    options.headers['X-App-Version'] = '1.0.0';
    options.headers['X-Platform'] = 'flutter';
    options.headers['X-Flavor'] = Env.flavor;

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // TODO Backend: Implement refresh token flow
    // If 401, try refresh token and retry once
    if (err.response?.statusCode == 401) {
      // Clear token and redirect to login - router will handle
      // final refreshToken = await secureStorage.getRefreshToken();
      // if (refreshToken != null) {
      //   try {
      //     final newTokens = await _refresh(refreshToken);
      //     await secureStorage.saveTokens(newTokens.access, newTokens.refresh);
      //     // Retry original request
      //     final opts = err.requestOptions;
      //     opts.headers['Authorization'] = 'Bearer ${newTokens.access}';
      //     final dio = Dio();
      //     final clone = await dio.fetch(opts);
      //     return handler.resolve(clone);
      //   } catch (_) {
      //     await secureStorage.clearAll();
      //   }
      // }
      
      // For now, just clear and continue error
      // await secureStorage.clearAll();
    }
    handler.next(err);
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (Env.isDevelopment) {
      // ignore: avoid_print
      print('🌐 REQUEST[${options.method}] => ${options.baseUrl}${options.path}');
      if (options.queryParameters.isNotEmpty) {
        // ignore: avoid_print
        print('  Query: ${options.queryParameters}');
      }
      if (options.data != null) {
        // ignore: avoid_print
        print('  Data: ${options.data}');
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (Env.isDevelopment) {
      // ignore: avoid_print
      print('✅ RESPONSE[${response.statusCode}] => ${response.requestOptions.path}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (Env.isDevelopment) {
      // ignore: avoid_print
      print('❌ ERROR[${err.response?.statusCode}] => ${err.requestOptions.path}');
      // ignore: avoid_print
      print('   Message: ${err.message}');
      // ignore: avoid_print
      print('   Data: ${err.response?.data}');
    }
    handler.next(err);
  }
}

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;

  RetryInterceptor({required this.dio, this.maxRetries = 2});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err) && err.requestOptions.extra['retry_count'] == null) {
      var retryCount = 0;
      while (retryCount < maxRetries) {
        try {
          retryCount++;
          final options = err.requestOptions;
          options.extra['retry_count'] = retryCount;
          
          // Exponential backoff
          await Future.delayed(Duration(milliseconds: 500 * retryCount));
          
          final response = await dio.fetch(options);
          return handler.resolve(response);
        } catch (_) {
          continue;
        }
      }
    }
    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }
}

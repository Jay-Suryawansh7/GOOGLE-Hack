import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://localhost:8080',
      ),
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  static Dio get dio {
    _dio.interceptors.clear();
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final session = Supabase.instance.client.auth.currentSession;
          if (session != null) {
            options.headers['Authorization'] = 'Bearer ${session.accessToken}';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            // Try refreshing token
            final refreshToken = Supabase.instance.client.auth.currentSession?.refreshToken;
            if (refreshToken != null) {
              try {
                final response = await Supabase.instance.client.auth.refreshSession();
                if (response.session != null) {
                  // Retry request with new token
                  error.requestOptions.headers['Authorization'] =
                      'Bearer ${response.session!.accessToken}';
                  final retryResponse = await _dio.fetch(error.requestOptions);
                  handler.resolve(retryResponse);
                  return;
                }
              } catch (_) {
                // Refresh failed, let error propagate
              }
            }
          }
          handler.next(error);
        },
      ),
    );
    return _dio;
  }
}

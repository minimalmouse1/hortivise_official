import 'package:dio/dio.dart';
import 'dart:developer' as developer;

class Api {
  static final Api _instance = Api._internal();
  factory Api() => _instance;
  static const String _baseUrl = 'https://payment.hortivise.com';
  static const String _prefix = '/api/v1';
  final Dio api = Dio();

  String? accessToken;

  Api._internal() {
    api.interceptors.add(
      InterceptorsWrapper(
          onRequest: (options, handler) async {
            if (!options.path.startsWith('http')) {
              options.path = _baseUrl + _prefix + options.path;
            }

            // ⛔ Skip login/auth endpoints to prevent recursion
            final isAuthRequest = options.path.contains('/auth/login') || options.path.contains('/auth');

            if (!isAuthRequest && accessToken == null) {
              final success = await login();
              if (!success) {
                return handler.reject(DioException(
                  requestOptions: options,
                  error: 'Login failed. Cannot proceed without access token.',
                  type: DioExceptionType.unknown,
                ));
              }
            }

            if (!isAuthRequest && accessToken != null) {
              options.headers['Authorization'] = 'Bearer $accessToken';
            }

            return handler.next(options);
          },
        onError: (DioException error, handler) async {
          developer.log('onError ==> $error');
          developer.log('error data ==> ${error.response?.data}');
          final errors = error.response?.data['errors'];
          final message = (errors is List && errors.isNotEmpty)
              ? errors[0]['message']
              : null;

          final originalPath = error.requestOptions.path;
          final isAuthRequest = originalPath.contains('/auth/login') || originalPath.contains('/auth');

          if (!isAuthRequest &&
              (message == "Unauthorized access" || message == "Unauthorized")) {
            final success = await login();
            developer.log('login success ==> $success');
            if (success) {
              return handler.resolve(await _retry(error.requestOptions));
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return api.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  Future<bool> authentication() async {
    try {
      final response = await api.get('/auth');
      if (response.statusCode == 200) return true;
      accessToken = null;
      return false;
    } catch (_) {
      accessToken = null;
      return false;
    }
  }

  Future<bool> login() async {
    try {
      final response = await api.post('/auth/login', data: {
        'email': 'admin@hortivise.com',
        'password': '123456',
      });
developer.log('login response ==> $response');
      if (response.statusCode == 200) {
        accessToken = response.data['result']['token'];
        developer.log('access token ==> $accessToken');
        return true;
      } else {
        accessToken = null;
        return false;
      }
    } catch (e) {
      accessToken = null;
      return false;
    }
  }
  Future<void> ensureAuthenticated() async {
    developer.log('storage token ==> $accessToken');
    if (accessToken != null) {
      final valid = await authentication();
      if (!valid) await login();
    } else {
      developer.log('storage token null state');
      await login();
    }
  }
  Future<Response<dynamic>> request({
    required String path,
    String method = 'GET',
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final options = Options(
      method: method,
      headers: headers,
    );

    return await api.request(
      path,
      data: data,
      queryParameters: query,
      options: options,
    );
  }
}

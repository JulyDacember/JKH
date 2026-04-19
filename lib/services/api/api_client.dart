import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../../config/app_config.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient({HttpClient? httpClient})
      : _httpClient = httpClient ?? HttpClient();

  final HttpClient _httpClient;
  String? _authToken;

  void setAuthToken(String? token) {
    _authToken = token;
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    return _request('GET', path, queryParameters: queryParameters);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
  }) async {
    return _request('POST', path, body: body, queryParameters: queryParameters);
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
  }) async {
    return _request('PUT', path, body: body, queryParameters: queryParameters);
  }

  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    return _request('DELETE', path, queryParameters: queryParameters);
  }

  Future<Map<String, dynamic>> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
  }) async {
    final uri = Uri.parse(AppConfig.apiBaseUrl).resolve(path).replace(
          queryParameters:
              queryParameters?.isEmpty == true ? null : queryParameters,
        );

    try {
      final request = await _httpClient
          .openUrl(method, uri)
          .timeout(AppConfig.connectTimeout);

      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      if (_authToken != null && _authToken!.isNotEmpty) {
        request.headers.set(
          HttpHeaders.authorizationHeader,
          'Bearer $_authToken',
        );
      }

      if (body != null) {
        request.write(jsonEncode(body));
      }

      final response = await request.close().timeout(AppConfig.receiveTimeout);
      final responseBody = await utf8.decoder.bind(response).join();

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException(
          _extractErrorMessage(responseBody) ?? 'Request failed',
          statusCode: response.statusCode,
        );
      }

      if (responseBody.trim().isEmpty) {
        return <String, dynamic>{};
      }

      final decoded = jsonDecode(responseBody);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      return <String, dynamic>{'data': decoded};
    } on TimeoutException {
      throw const ApiException('Request timeout');
    } on SocketException {
      throw const ApiException('No internet connection');
    } on FormatException {
      throw const ApiException('Invalid response format');
    }
  }

  String? _extractErrorMessage(String responseBody) {
    if (responseBody.trim().isEmpty) return null;
    try {
      final decoded = jsonDecode(responseBody);
      if (decoded is Map<String, dynamic>) {
        final message = decoded['message'];
        if (message is String && message.trim().isNotEmpty) {
          return message;
        }
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}

import 'package:dio/dio.dart';
import 'package:test_app_dir/core/constants/api_endpoints.dart';
import 'package:test_app_dir/core/constants/network_constants.dart';
import 'package:test_app_dir/core/network/api_response.dart';
import 'package:test_app_dir/core/network/logger_interceptor.dart';
import 'package:test_app_dir/core/network/token_interceptor.dart';
import 'package:test_app_dir/core/network/error_interceptor.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio _dio;

  factory ApiClient() => _instance;

  static ApiClient get instance => _instance;

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout:
            const Duration(milliseconds: NetworkConstants.connectTimeout),
        receiveTimeout:
            const Duration(milliseconds: NetworkConstants.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    _dio.interceptors.addAll([
      TokenInterceptor(),
      LoggerInterceptor(),
      ErrorInterceptor(),
    ]);
  }

  Dio get dio => _dio;

  Future<ApiResponse<T>> _request<T>(
    String path, {
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    Options? options,
  }) async {
    try {
      final response = await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: (options ?? Options()).copyWith(method: method),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        if (fromJson != null) {
          return ApiResponse(
            data: fromJson(response.data),
            statusCode: response.statusCode,
          );
        } else {
          return ApiResponse(
            data: response.data as T?,
            statusCode: response.statusCode,
          );
        }
      } else {
        return ApiResponse(
          error: 'Received invalid status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      String errorMsg = e.toString();
      if (e is DioException) {
        errorMsg = e.response?.data?['message'] ?? e.message ?? e.toString();
      }
      return ApiResponse(error: errorMsg);
    }
  }

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    Options? options,
  }) async {
    return _request<T>(
      path,
      method: 'GET',
      queryParameters: queryParameters,
      fromJson: fromJson,
      options: options,
    );
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    T Function(dynamic)? fromJson,
    Options? options,
  }) async {
    return _request<T>(
      path,
      method: 'POST',
      data: data,
      fromJson: fromJson,
      options: options,
    );
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    T Function(dynamic)? fromJson,
    Options? options,
  }) async {
    return _request<T>(
      path,
      method: 'PUT',
      data: data,
      fromJson: fromJson,
      options: options,
    );
  }

  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic data,
    T Function(dynamic)? fromJson,
    Options? options,
  }) async {
    return _request<T>(
      path,
      method: 'PATCH',
      data: data,
      fromJson: fromJson,
      options: options,
    );
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    T Function(dynamic)? fromJson,
    Options? options,
  }) async {
    return _request<T>(
      path,
      method: 'DELETE',
      data: data,
      fromJson: fromJson,
      options: options,
    );
  }
}

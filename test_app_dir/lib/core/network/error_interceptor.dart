import 'package:dio/dio.dart';
import 'package:test_app_dir/core/network/api_exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      throw UnauthorizedException('Unauthorized access', statusCode: 401);
    }
    super.onError(err, handler);
  }
}

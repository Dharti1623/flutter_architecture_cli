class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  NetworkException(super.message, {super.statusCode});
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(super.message, {super.statusCode});
}

class ValidationException extends ApiException {
  ValidationException(super.message, {super.statusCode});
}

class ServerException extends ApiException {
  ServerException(super.message, {super.statusCode});
}

class CacheException extends ApiException {
  CacheException(super.message, {super.statusCode});
}

class ServerException implements Exception {
  final String message;
  
  const ServerException(this.message);
  
  @override
  String toString() => 'ServerException: $message';
}

class CacheException implements Exception {
  final String message;
  
  const CacheException(this.message);
  
  @override
  String toString() => 'CacheException: $message';
}

class NetworkException implements Exception {
  final String message;
  
  const NetworkException(this.message);
  
  @override
  String toString() => 'NetworkException: $message';
}

class ValidationException implements Exception {
  final String message;
  
  const ValidationException(this.message);
  
  @override
  String toString() => 'ValidationException: $message';
}

class AuthenticationException implements Exception {
  final String message;
  
  const AuthenticationException(this.message);
  
  @override
  String toString() => 'AuthenticationException: $message';
}

class UnauthorizedException implements Exception {
  final String message;
  
  const UnauthorizedException(this.message);
  
  @override
  String toString() => 'UnauthorizedException: $message';
}

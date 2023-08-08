class OfflineException implements Exception {}

class ServerException implements Exception {
  String message;

  ServerException({required this.message});
}

class EmptyCacheException implements Exception {}

class EmailIsNotVerifiedException implements Exception {}

import 'package:http/http.dart';

/// Thrown when an HTTP request returns an error (4xx or 5xx).
class HttpErrorException implements Exception {
  /// Constructs a [HttpErrorException]
  const HttpErrorException({required this.response});

  /// The [Response] from the request
  final Response response;
}

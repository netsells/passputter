// 🌎 Project imports:
import 'package:passputter/src/oauth_token.dart';

/// Thrown when an expired [OAuthToken] is used and cannot be refreshed.
class TokenExpiredException implements Exception {
  /// Constructs a [TokenExpiredException]
  const TokenExpiredException(
    this.expiredToken, [
    this.message = 'OAuth token has expired',
  ]) : super();

  /// The [OAuthToken] which has expired.
  final OAuthToken expiredToken;

  /// The error message
  final String message;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TokenExpiredException &&
        other.expiredToken == expiredToken &&
        other.message == message;
  }

  @override
  int get hashCode => expiredToken.hashCode ^ message.hashCode;
}

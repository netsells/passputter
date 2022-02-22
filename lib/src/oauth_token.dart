// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:clock/clock.dart';
import 'package:meta/meta.dart';

/// An authentication token.
@immutable
class OAuthToken {
  /// Constructs an [OAuthToken]
  const OAuthToken({
    required this.token,
    required this.expiresAt,
    required this.refreshToken,
  });

  /// Constructs an [OAuthToken] from a [map]
  factory OAuthToken.fromMap(
    Map<String, dynamic> map, [
    Clock clock = const Clock(),
  ]) {
    final expiresIn = map['expires_in'] as int?;
    return OAuthToken(
      token: map['access_token'] as String,
      expiresAt: expiresIn != null
          ? clock.now().add(Duration(seconds: expiresIn))
          : null,
      refreshToken: map['refresh_token'] as String?,
    );
  }

  /// Constructs an [OAuthToken] from a JSON [source]
  factory OAuthToken.fromJson(String source) =>
      OAuthToken.fromMap(json.decode(source) as Map<String, dynamic>);

  /// The token used to authenticate requests.
  ///
  /// Should be added HTTP requests using a Bearer Authorization header.
  final String token;

  /// The [DateTime] at which this token expires.
  final DateTime? expiresAt;

  /// A refresh token which can be used to generate a new token.
  final String? refreshToken;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OAuthToken &&
        other.token == token &&
        other.expiresAt == expiresAt &&
        other.refreshToken == refreshToken;
  }

  @override
  int get hashCode =>
      token.hashCode ^ expiresAt.hashCode ^ refreshToken.hashCode;
}

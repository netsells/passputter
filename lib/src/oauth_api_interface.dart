import 'package:passputter/src/oauth_token.dart';

/// Interface defining API methods
abstract class OAuthApiInterface {
  /// Request a client token
  Future<OAuthToken> getClientToken({
    required String clientId,
    required String clientSecret,
  });

  /// Request a user (password grant) token
  Future<OAuthToken> getUserToken({
    required String username,
    required String password,
    required String clientId,
    required String clientSecret,
  });

  /// Request a token using the [refreshToken] from an existing token.
  Future<OAuthToken> getRefreshedToken({
    required String refreshToken,
    required String clientId,
    required String clientSecret,
  });
}

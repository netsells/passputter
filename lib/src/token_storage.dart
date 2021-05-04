import 'oauth_token.dart';

/// Handles storage and retrieval of [OAuthToken]s.
abstract class TokenStorage {
  /// Retrieves the currently saved client token if it exists, or none.
  OAuthToken? get clientToken;

  /// Retrieves the currently saved user token if it exists, or none.
  OAuthToken? get userToken;

  /// Saves a new client [token].
  ///
  /// Overwrites any currently saved client token.
  Future<void> saveClientToken(OAuthToken token);

  /// Saves a new user [token].
  ///
  /// Overwrites any currently saved user tokens.
  Future<void> saveUserToken(OAuthToken token);

  /// Deletes the currently saved client token
  Future<void> deleteClientToken();

  /// Deletes the currently saved client token
  Future<void> deleteUserToken();
}

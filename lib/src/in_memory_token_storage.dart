// 🌎 Project imports:
import 'package:passputter/passputter.dart';
import 'package:passputter/src/oauth_token.dart';

/// Implementation of [TokenStorage] which stores tokens in memory.
class InMemoryTokenStorage implements TokenStorage {
  OAuthToken? _clientToken;
  OAuthToken? _userToken;

  @override
  OAuthToken? get clientToken => _clientToken;

  @override
  Future<void> deleteClientToken() async {
    _clientToken = null;
  }

  @override
  Future<void> deleteUserToken() async {
    _userToken = null;
  }

  @override
  Future<void> saveClientToken(OAuthToken token) async {
    _clientToken = token;
  }

  @override
  Future<void> saveUserToken(OAuthToken token) async {
    _userToken = token;
  }

  @override
  OAuthToken? get userToken => _userToken;
}

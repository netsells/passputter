// 🌎 Project imports:
import 'package:passputter/passputter.dart';
import 'package:passputter/src/oauth_api_interface.dart';

/// Implementation of [Passputter]
class PassputterImpl implements Passputter {
  /// Constructs a [PassputterImpl]
  const PassputterImpl({
    required this.oAuthApi,
    required this.tokenStorage,
    required this.clientId,
    required this.clientSecret,
  });

  /// Instance of [TokenStorage]
  final TokenStorage tokenStorage;

  /// Instance of [OAuthApiInterface]
  final OAuthApiInterface oAuthApi;

  /// Client ID for password grant authentication
  final String clientId;

  /// Client secret for password grant authentication
  final String clientSecret;

  @override
  bool get isLoggedIn => tokenStorage.userToken != null;

  @override
  Future<void> logIn({
    required String email,
    required String password,
  }) async {
    final token = await oAuthApi.getUserToken(
      username: email,
      password: password,
      clientId: clientId,
      clientSecret: clientSecret,
    );

    await tokenStorage.saveUserToken(token);
  }

  @override
  Future<void> logOut() async {
    await tokenStorage.deleteUserToken();
  }
}

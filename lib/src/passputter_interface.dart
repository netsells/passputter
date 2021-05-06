// 📦 Package imports:
import 'package:dio/dio.dart';

// 🌎 Project imports:
import 'package:passputter/passputter.dart';
import 'package:passputter/src/oauth_api_impl.dart';
import 'package:passputter/src/passputter_impl.dart';

/// Main passputter interface.
///
/// Includes methods for logging in/out, and retrieving the current auth state.
abstract class Passputter {
  /// Constructs a [Passputter].
  ///
  /// [dio] is a [Dio] instance which will be used to request auth tokens.
  ///
  /// [endpoint] is the URL from which tokens should be retrieved. This
  /// typically ends with `oauth/token`.
  ///
  /// [clientId] is the ID of the OAuth client used for **password** auth.
  ///
  /// [clientSecret] is the secret of the OAuth client used for **password**
  /// auth.
  ///
  /// [tokenStorage] is an instance of an implementation of [TokenStorage].
  factory Passputter({
    required Dio dio,
    required String endpoint,
    required String clientId,
    required String clientSecret,
    required TokenStorage tokenStorage,
  }) {
    return PassputterImpl(
      oAuthApi: OAuthApiImpl(client: dio, endpoint: endpoint),
      clientId: clientId,
      clientSecret: clientSecret,
      tokenStorage: tokenStorage,
    );
  }

  /// Whether the user is logged in.
  bool get isLoggedIn;

  /// Log in with the given [email] and [password] credentials.
  ///
  /// Throws a [DioError] if the token request returns an error.
  Future<void> logIn({
    required String email,
    required String password,
  });

  /// Log out of the application
  Future<void> logOut();
}

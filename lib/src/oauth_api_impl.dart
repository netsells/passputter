import 'package:passputter/src/http_error_exception.dart';
import 'package:passputter/src/oauth_api_interface.dart';
import 'package:passputter/src/oauth_token.dart';
import 'package:http/http.dart';

/// Implementation of [OAuthApiInterface]
class OAuthApiImpl implements OAuthApiInterface {
  /// Constructs a [OAuthApiImpl]
  const OAuthApiImpl({required this.endpoint, required this.client});

  /// The URL of the API endpoint used for authentication.
  ///
  /// Typically ends in `oauth/token`.
  final String endpoint;

  /// The HTTP [Client] to use for requests.
  final Client client;

  @override
  Future<OAuthToken> getClientToken({
    required String clientId,
    required String clientSecret,
  }) async {
    final r = await client.post(
      Uri.parse(endpoint),
      body: <String, String>{
        'client_id': clientId,
        'client_secret': clientSecret,
        'grant_type': 'client_credentials',
      },
    );

    if (r.statusCode >= 400 && r.statusCode <= 599) {
      throw HttpErrorException(response: r);
    }

    return OAuthToken.fromJson(r.body);
  }

  @override
  Future<OAuthToken> getRefreshedToken({
    required String refreshToken,
    required String clientId,
    required String clientSecret,
  }) async {
    final r = await client.post(
      Uri.parse(endpoint),
      body: <String, String>{
        'refresh_token': refreshToken,
        'client_id': clientId,
        'client_secret': clientSecret,
        'grant_type': 'refresh_token',
      },
    );

    if (r.statusCode >= 400 && r.statusCode <= 599) {
      throw HttpErrorException(response: r);
    }

    return OAuthToken.fromJson(r.body);
  }

  @override
  Future<OAuthToken> getUserToken({
    required String username,
    required String password,
    required String clientId,
    required String clientSecret,
  }) async {
    final r = await client.post(
      Uri.parse(endpoint),
      body: <String, String>{
        'username': username,
        'password': password,
        'client_id': clientId,
        'client_secret': clientSecret,
        'grant_type': 'password',
      },
    );

    if (r.statusCode >= 400 && r.statusCode <= 599) {
      throw HttpErrorException(response: r);
    }

    return OAuthToken.fromJson(r.body);
  }
}

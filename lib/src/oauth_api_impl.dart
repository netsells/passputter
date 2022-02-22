// 📦 Package imports:
import 'package:dio/dio.dart';
// 🌎 Project imports:
import 'package:passputter/src/oauth_api_interface.dart';
import 'package:passputter/src/oauth_token.dart';

/// Implementation of [OAuthApiInterface]
class OAuthApiImpl implements OAuthApiInterface {
  /// Constructs a [OAuthApiImpl]
  const OAuthApiImpl({required this.endpoint, required this.client});

  /// The URL of the API endpoint used for authentication.
  ///
  /// Typically ends in `oauth/token`.
  final String endpoint;

  /// The [Dio] instance to use for requests.
  final Dio client;

  @override
  Future<OAuthToken> getClientToken({
    required String clientId,
    required String clientSecret,
  }) async {
    final r = await client.post<String>(
      endpoint,
      data: <String, String>{
        'client_id': clientId,
        'client_secret': clientSecret,
        'grant_type': 'client_credentials',
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    return OAuthToken.fromJson(r.data!);
  }

  @override
  Future<OAuthToken> getRefreshedToken({
    required String refreshToken,
    required String clientId,
    required String clientSecret,
  }) async {
    final r = await client.post<String>(
      endpoint,
      data: <String, String>{
        'refresh_token': refreshToken,
        'client_id': clientId,
        'client_secret': clientSecret,
        'grant_type': 'refresh_token',
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    return OAuthToken.fromJson(r.data!);
  }

  @override
  Future<OAuthToken> getUserToken({
    required String username,
    required String password,
    required String clientId,
    required String clientSecret,
  }) async {
    final r = await client.post<String>(
      endpoint,
      data: <String, String>{
        'username': username,
        'password': password,
        'client_id': clientId,
        'client_secret': clientSecret,
        'grant_type': 'password',
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    return OAuthToken.fromJson(r.data!);
  }
}

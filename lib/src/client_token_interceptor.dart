import 'package:dio/dio.dart';
import 'package:passputter/passputter.dart';
import 'package:passputter/src/oauth_api_interface.dart';

/// Adds a client bearer token to the Authorization header of each request
class ClientTokenInterceptor extends Interceptor {
  /// Constructs a [ClientTokenInterceptor]
  ClientTokenInterceptor({
    required this.tokenStorage,
    required this.oAuthApi,
    required this.clientId,
    required this.clientSecret,
  });

  /// An instance of [TokenStorage]
  final TokenStorage tokenStorage;

  /// An instance of [OAuthApiInterface]
  final OAuthApiInterface oAuthApi;

  /// The OAuth Client ID
  final String clientId;

  /// The OAuth Client Secret
  final String clientSecret;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = tokenStorage.clientToken;
    if (token == null) {
      try {
        // No token saved; get another one.
        final newToken = await oAuthApi.getClientToken(
          clientId: clientId,
          clientSecret: clientSecret,
        );

        await tokenStorage.saveClientToken(newToken);

        options.headers['Authorization'] = 'Bearer ${newToken.token}';

        return handler.next(options);
      } on DioError catch (e) {
        return handler.reject(e);
      }
    } else {
      options.headers['Authorization'] = 'Bearer ${token.token}';
      return handler.next(options);
    }
  }
}

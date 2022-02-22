// 📦 Package imports:
import 'package:clock/clock.dart';
import 'package:dio/dio.dart';

// 🌎 Project imports:
import 'package:passputter/passputter.dart';
import 'package:passputter/src/oauth_api_interface.dart';
import 'package:passputter/src/token_expired_exception.dart';

/// Adds a user bearer token to the Authorizaton header of each request
class UserTokenInterceptor extends Interceptor {
  /// Constructs a [UserTokenInterceptor]
  UserTokenInterceptor({
    required this.tokenStorage,
    required this.oAuthApi,
    required this.clientId,
    required this.clientSecret,
    this.clock = const Clock(),
  });

  /// Instance of [TokenStorage]
  final TokenStorage tokenStorage;

  /// Instance of [OAuthApiInterface]
  final OAuthApiInterface oAuthApi;

  /// The OAuth Client ID
  final String clientId;

  /// The OAuth Client Secret
  final String clientSecret;

  /// The [clock] to use for date comparisons
  final Clock clock;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenStorage.userToken;
    if (token != null) {
      if (token.expiresAt != null && token.expiresAt!.isBefore(clock.now())) {
        final refreshToken = token.refreshToken;
        if (refreshToken != null) {
          try {
            final newToken = await oAuthApi.getRefreshedToken(
              refreshToken: refreshToken,
              clientId: clientId,
              clientSecret: clientSecret,
            );

            await tokenStorage.saveUserToken(newToken);

            options.headers['Authorization'] = 'Bearer ${newToken.token}';

            return handler.next(options);
          } on DioError catch (e) {
            return handler.reject(e);
          }
        } else {
          return handler.reject(
            DioError(
              requestOptions: options,
              error: TokenExpiredException(token),
            ),
          );
        }
      } else {
        options.headers['Authorization'] = 'Bearer ${token.token}';
      }
    }
    return handler.next(options);
  }
}

// 📦 Package imports:
import 'package:clock/clock.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:time/time.dart';

// 🌎 Project imports:
import 'package:passputter/passputter.dart';
import 'package:passputter/src/oauth_api_interface.dart';
import 'package:passputter/src/oauth_token.dart';
import 'package:passputter/src/token_expired_exception.dart';

class MockOAuthApi extends Mock implements OAuthApiInterface {}

class MockHandler extends Mock implements RequestInterceptorHandler {}

void main() {
  late InMemoryTokenStorage tokenStorage;
  late MockOAuthApi oAuthApi;
  late MockHandler handler;
  late Clock clock;
  late UserTokenInterceptor interceptor;

  setUpAll(() {
    registerFallbackValue(
      DioError(
        requestOptions: RequestOptions(
          path: 'path',
        ),
      ),
    );
  });

  setUp(() {
    tokenStorage = InMemoryTokenStorage();
    oAuthApi = MockOAuthApi();
    handler = MockHandler();
    clock = Clock.fixed(DateTime(2021));
    interceptor = UserTokenInterceptor(
      tokenStorage: tokenStorage,
      oAuthApi: oAuthApi,
      clientId: 'id',
      clientSecret: 'secret',
      clock: clock,
    );
  });

  final tRequest = RequestOptions(path: 'path');

  test('adds token if a valid token exists in storage', () async {
    final token = OAuthToken(
      token: 'token',
      expiresAt: clock.now().add(30.days),
      refreshToken: 'refresh',
    );

    await tokenStorage.saveUserToken(token);

    await interceptor.onRequest(tRequest, handler);

    final expected = tRequest..headers['Authorization'] = 'Bearer token';

    verify(() => handler.next(expected));
  });

  test('refreshes token if an expired token exists in storage', () async {
    final token = OAuthToken(
      token: 'token',
      expiresAt: clock.now().subtract(30.days),
      refreshToken: 'refresh',
    );

    await tokenStorage.saveUserToken(token);

    final refreshedToken = OAuthToken(
      token: 'token2',
      expiresAt: clock.now().add(30.days),
      refreshToken: 'refresh2',
    );

    when(
      () => oAuthApi.getRefreshedToken(
        refreshToken: 'refresh',
        clientId: 'id',
        clientSecret: 'secret',
      ),
    ).thenAnswer((_) async => refreshedToken);

    await interceptor.onRequest(tRequest, handler);

    final expected = tRequest..headers['Authorization'] = 'Bearer token2';

    verify(() => handler.next(expected));

    verify(
      () => oAuthApi.getRefreshedToken(
        refreshToken: 'refresh',
        clientId: 'id',
        clientSecret: 'secret',
      ),
    );
  });

  test(
    'throws error if token has expired and there is no refresh token',
    () async {
      final token = OAuthToken(
        token: 'token',
        expiresAt: clock.now().subtract(30.days),
        refreshToken: null,
      );

      await tokenStorage.saveUserToken(token);

      await interceptor.onRequest(tRequest, handler);

      final captured = verify(() => handler.reject(captureAny())).captured;

      expect(
        captured.last,
        isA<DioError>().having(
          (e) => e.error,
          'error',
          isA<TokenExpiredException>(),
        ),
      );

      verifyZeroInteractions(oAuthApi);
    },
  );

  test('rejects request if token refresh fails', () async {
    final token = OAuthToken(
      token: 'token',
      expiresAt: clock.now().subtract(30.days),
      refreshToken: 'refresh',
    );

    await tokenStorage.saveUserToken(token);

    final error = DioError(requestOptions: RequestOptions(path: 'path'));

    when(
      () => oAuthApi.getRefreshedToken(
        refreshToken: 'refresh',
        clientId: 'id',
        clientSecret: 'secret',
      ),
    ).thenAnswer((_) => Future.error(error));

    await interceptor.onRequest(tRequest, handler);

    verify(() => handler.reject(error));

    verify(
      () => oAuthApi.getRefreshedToken(
        refreshToken: 'refresh',
        clientId: 'id',
        clientSecret: 'secret',
      ),
    );
  });

  test('continues request unchanged if no token exists', () async {
    await tokenStorage.deleteUserToken();

    await interceptor.onRequest(tRequest, handler);

    verify(() => handler.next(tRequest));

    verifyZeroInteractions(oAuthApi);
  });
}

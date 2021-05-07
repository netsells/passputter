// 📦 Package imports:
import 'package:clock/clock.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:time/time.dart';

// 🌎 Project imports:
import 'package:passputter/passputter.dart';
import 'package:passputter/src/client_token_interceptor.dart';
import 'package:passputter/src/oauth_api_interface.dart';
import 'package:passputter/src/oauth_token.dart';

class MockOAuthApi extends Mock implements OAuthApiInterface {}

class MockHandler extends Mock implements RequestInterceptorHandler {}

void main() {
  late InMemoryTokenStorage tokenStorage;
  late MockOAuthApi oAuthApi;
  late MockHandler handler;
  late Clock clock;
  late ClientTokenInterceptor interceptor;

  setUp(() {
    tokenStorage = InMemoryTokenStorage();
    oAuthApi = MockOAuthApi();
    handler = MockHandler();
    clock = Clock.fixed(DateTime(2021, 5, 1));
    interceptor = ClientTokenInterceptor(
      tokenStorage: tokenStorage,
      oAuthApi: oAuthApi,
      clientId: 'id',
      clientSecret: 'secret',
      clock: clock,
    );
  });

  const token = OAuthToken(
    token: 'token',
    expiresAt: null,
    refreshToken: 'refresh',
  );

  final tRequest = RequestOptions(path: 'path');

  test('adds header when it exists in TokenStorage', () async {
    await tokenStorage.saveClientToken(token);

    await interceptor.onRequest(tRequest, handler);

    final expected = tRequest..headers['Authorization'] = 'Bearer token';

    verify(() => handler.next(expected));

    verifyZeroInteractions(oAuthApi);
  });

  test('generates header when none exists in TokenStorage', () async {
    await tokenStorage.deleteClientToken();

    when(() => oAuthApi.getClientToken(clientId: 'id', clientSecret: 'secret'))
        .thenAnswer((_) async => token);

    await interceptor.onRequest(tRequest, handler);

    final expected = tRequest..headers['Authorization'] = 'Bearer token';

    verify(() => handler.next(expected));

    verify(
      () => oAuthApi.getClientToken(clientId: 'id', clientSecret: 'secret'),
    );
  });

  test('generates header when token in TokenStorage has expired', () async {
    await tokenStorage.saveClientToken(OAuthToken(
      token: 'expired',
      expiresAt: clock.now().subtract(1.hours),
      refreshToken: null,
    ));

    when(() => oAuthApi.getClientToken(clientId: 'id', clientSecret: 'secret'))
        .thenAnswer((_) async => token);

    await interceptor.onRequest(tRequest, handler);

    final expected = tRequest..headers['Authorization'] = 'Bearer token';

    verify(() => handler.next(expected));

    verify(
      () => oAuthApi.getClientToken(clientId: 'id', clientSecret: 'secret'),
    );
  });

  test('throws error when no token exists and token request fails', () async {
    await tokenStorage.deleteClientToken();

    final error = DioError(requestOptions: RequestOptions(path: 'path'));

    when(() => oAuthApi.getClientToken(clientId: 'id', clientSecret: 'secret'))
        .thenAnswer((_) => Future.error(error));

    await interceptor.onRequest(tRequest, handler);

    verify(() => handler.reject(error));

    verify(
      () => oAuthApi.getClientToken(clientId: 'id', clientSecret: 'secret'),
    );
  });
}

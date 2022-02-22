// 📦 Package imports:
import 'package:mocktail/mocktail.dart';
// 🌎 Project imports:
import 'package:passputter/passputter.dart';
import 'package:passputter/src/oauth_api_interface.dart';
import 'package:passputter/src/passputter_impl.dart';
import 'package:test/test.dart';

class MockOAuthApi extends Mock implements OAuthApiInterface {}

void main() {
  late InMemoryTokenStorage tokenStorage;
  late MockOAuthApi oAuthApi;
  late PassputterImpl passputterImpl;

  const clientId = '1';
  const clientSecret = 'secret';

  setUp(() {
    tokenStorage = InMemoryTokenStorage();
    oAuthApi = MockOAuthApi();
    passputterImpl = PassputterImpl(
      oAuthApi: oAuthApi,
      tokenStorage: tokenStorage,
      clientId: clientId,
      clientSecret: clientSecret,
    );
  });

  test('login/logout flow works', () async {
    when(
      () => oAuthApi.getUserToken(
        username: any(named: 'username'),
        password: any(named: 'password'),
        clientId: clientId,
        clientSecret: clientSecret,
      ),
    ).thenAnswer(
      (invocation) async => const OAuthToken(
        token: 'token',
        expiresAt: null,
        refreshToken: 'refreshToken',
      ),
    );

    expect(passputterImpl.isLoggedIn, isFalse);

    await passputterImpl.logIn(
      email: 'email@example.com',
      password: 'password',
    );

    expect(passputterImpl.isLoggedIn, isTrue);

    await passputterImpl.logOut();

    expect(passputterImpl.isLoggedIn, isFalse);
  });
}

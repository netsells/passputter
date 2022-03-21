// 📦 Package imports:

// 📦 Package imports:
import 'package:test/test.dart';

// 🌎 Project imports:
import 'package:passputter/src/in_memory_token_storage.dart';
import 'package:passputter/src/oauth_token.dart';

void main() {
  late InMemoryTokenStorage storage;

  setUp(() {
    storage = InMemoryTokenStorage();
  });

  test('adding, updating and deleting user tokens is successful', () async {
    const token1 = OAuthToken(
      token: 'token1',
      expiresAt: null,
      refreshToken: 'refresh1',
    );

    expect(storage.userToken, isNull);

    await storage.saveUserToken(token1);

    expect(storage.userToken, equals(token1));

    const token2 = OAuthToken(
      token: 'token2',
      expiresAt: null,
      refreshToken: 'refresh2',
    );

    await storage.saveUserToken(token2);

    expect(storage.userToken, equals(token2));

    await storage.deleteUserToken();

    expect(storage.userToken, isNull);
  });

  test('adding, updating and deleting client tokens is successful', () async {
    const token1 = OAuthToken(
      token: 'token1',
      expiresAt: null,
      refreshToken: 'refresh1',
    );

    expect(storage.clientToken, isNull);

    await storage.saveClientToken(token1);

    expect(storage.clientToken, equals(token1));

    const token2 = OAuthToken(
      token: 'token2',
      expiresAt: null,
      refreshToken: 'refresh2',
    );

    await storage.saveClientToken(token2);

    expect(storage.clientToken, equals(token2));

    await storage.deleteClientToken();

    expect(storage.clientToken, isNull);
  });
}

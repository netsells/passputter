// 📦 Package imports:
import 'package:test/test.dart';

// 🌎 Project imports:
import 'package:passputter/src/oauth_token.dart';
import 'package:passputter/src/token_expired_exception.dart';

void main() {
  test('equal exceptions are evaluated as equal', () async {
    const token = OAuthToken(
      token: 'token',
      refreshToken: null,
      expiresAt: null,
    );
    const t1 = TokenExpiredException(token);
    const t2 = TokenExpiredException(token);

    expect(t1 == t2, isTrue);
    expect(t1.hashCode == t2.hashCode, isTrue);
  });

  test('exceptions with different tokens are not evaluated as equal', () async {
    const token1 = OAuthToken(
      token: 'token',
      refreshToken: null,
      expiresAt: null,
    );
    const token2 = OAuthToken(
      token: 'token2',
      refreshToken: null,
      expiresAt: null,
    );
    const t1 = TokenExpiredException(token1);
    const t2 = TokenExpiredException(token2);

    expect(t1 == t2, isFalse);
    expect(t1.hashCode == t2.hashCode, isFalse);
  });

  test(
    'exceptions with different messages are not evaluated as equal',
    () async {
      const token = OAuthToken(
        token: 'token',
        refreshToken: null,
        expiresAt: null,
      );
      const t1 = TokenExpiredException(token);
      const t2 = TokenExpiredException(token, 'A different message');

      expect(t1 == t2, isFalse);
      expect(t1.hashCode == t2.hashCode, isFalse);
    },
  );
}

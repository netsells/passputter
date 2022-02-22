// 📦 Package imports:
import 'package:clock/clock.dart';
// 🌎 Project imports:
import 'package:passputter/src/oauth_token.dart';
import 'package:test/test.dart';
import 'package:time/time.dart';

void main() {
  group('fromMap', () {
    test('without expiry parses successfully', () {
      final map = <String, dynamic>{
        'access_token': 'token',
        'refresh_token': 'refresh',
      };

      const expected = OAuthToken(
        token: 'token',
        refreshToken: 'refresh',
        expiresAt: null,
      );

      expect(OAuthToken.fromMap(map), equals(expected));
    });

    test('without refresh token parses successfully', () {
      final clock = Clock.fixed(DateTime(2021, 5));

      final map = <String, dynamic>{
        'access_token': 'token',
        'expires_in': 1000,
      };

      final expected = OAuthToken(
        token: 'token',
        refreshToken: null,
        expiresAt: clock.now().add(1000.seconds),
      );

      expect(OAuthToken.fromMap(map, clock), equals(expected));
    });

    test('with all arguments parses successfully', () {
      final clock = Clock.fixed(DateTime(2021, 5));

      final map = <String, dynamic>{
        'access_token': 'token',
        'refresh_token': 'refresh',
        'expires_in': 1000,
      };

      final expected = OAuthToken(
        token: 'token',
        refreshToken: 'refresh',
        expiresAt: clock.now().add(1000.seconds),
      );

      expect(OAuthToken.fromMap(map, clock), equals(expected));
    });
  });

  group('equality', () {
    test('equal tokens are evaluated as equal', () {
      const t1 = OAuthToken(
        token: 'token',
        refreshToken: null,
        expiresAt: null,
      );

      const t2 = OAuthToken(
        token: 'token',
        refreshToken: null,
        expiresAt: null,
      );

      expect(t1 == t2, isTrue);
      expect(t1.hashCode == t2.hashCode, isTrue);
    });

    test('non-equal tokens are not evaluated as equal', () {
      const t1 = OAuthToken(
        token: 'token',
        refreshToken: null,
        expiresAt: null,
      );

      const t2 = OAuthToken(
        token: 'token2',
        refreshToken: 'refresh',
        expiresAt: null,
      );

      expect(t1 == t2, isFalse);
      expect(t1.hashCode == t2.hashCode, isFalse);
    });
  });
}

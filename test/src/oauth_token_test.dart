import 'package:clock/clock.dart';
import 'package:passputter/src/oauth_token.dart';
import 'package:test/test.dart';
import 'package:time/time.dart';

void main() {
  group('fromMap', () {
    test('without expiry parses successfully', () {
      final map = <String, dynamic>{
        'accessToken': 'token',
        'refreshToken': 'refresh',
      };

      const expected = OAuthToken(
        token: 'token',
        refreshToken: 'refresh',
        expiresAt: null,
      );

      expect(OAuthToken.fromMap(map), equals(expected));
    });

    test('with expiry parses successfully', () {
      final clock = Clock.fixed(DateTime(2021, 5, 1));

      final map = <String, dynamic>{
        'accessToken': 'token',
        'refreshToken': 'refresh',
        'expiresIn': 1000,
      };

      final expected = OAuthToken(
        token: 'token',
        refreshToken: 'refresh',
        expiresAt: clock.now().add(1000.seconds),
      );

      expect(OAuthToken.fromMap(map, clock), equals(expected));
    });
  });
}

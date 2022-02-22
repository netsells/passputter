// 📦 Package imports:
import 'package:dio/dio.dart';
import 'package:mock_web_server/mock_web_server.dart';
// 🌎 Project imports:
import 'package:passputter/passputter.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:test/test.dart';

void main() {
  const clientId = 'id';
  const clientSecret = 'secret';

  late MockWebServer server;
  late InMemoryTokenStorage storage;
  late Passputter passputter;

  setUp(() async {
    server = MockWebServer();
    storage = InMemoryTokenStorage();

    await server.start();

    passputter = Passputter(
      dio: Dio()..interceptors.add(PrettyDioLogger()),
      endpoint: server.url,
      clientId: clientId,
      clientSecret: clientSecret,
      tokenStorage: storage,
    );
  });

  tearDown(() {
    server.shutdown();
  });

  group('isLoggedIn', () {
    test('is false when no token is stored', () async {
      await storage.deleteUserToken();

      expect(passputter.isLoggedIn, isFalse);
    });

    test('is true after logging in then false after logging out', () async {
      server.enqueue(
        body: '''
        {
          "access_token": "token",
          "expires_in": 1000
        }
        ''',
      );

      await passputter.logIn(email: 'email@example.com', password: 'password');

      expect(passputter.isLoggedIn, isTrue);

      await passputter.logOut();

      expect(passputter.isLoggedIn, isFalse);
    });
  });
}

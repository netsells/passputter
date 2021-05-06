// 📦 Package imports:
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

// 🌎 Project imports:
import 'package:passputter/src/oauth_api_impl.dart';
import 'package:passputter/src/oauth_token.dart';

class MockDio extends Mock implements Dio {}

void main() {
  const endpoint = 'https://test.com/oauth/token';

  late MockDio dio;
  late OAuthApiImpl oAuthApi;

  setUp(() {
    dio = MockDio();
    oAuthApi = OAuthApiImpl(client: dio, endpoint: endpoint);
  });

  const clientId = 'id';
  const clientSecret = 'secret';

  final tError = DioError(requestOptions: RequestOptions(path: endpoint));

  group('getClientToken', () {
    test('successfully returns token', () async {
      when(
        () => dio.post(
          endpoint,
          data: <String, String>{
            'client_id': clientId,
            'client_secret': clientSecret,
            'grant_type': 'client_credentials',
          },
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: endpoint),
          statusCode: 200,
          data: '''{
            "accessToken": "token",
            "refreshToken": "refresh"
          }''',
        ),
      );

      final r = await oAuthApi.getClientToken(
        clientId: clientId,
        clientSecret: clientSecret,
      );

      const expected = OAuthToken(
        token: 'token',
        refreshToken: 'refresh',
        expiresAt: null,
      );

      expect(r, equals(expected));
    });

    test('throws DioError if one is thrown by request', () async {
      when(
        () => dio.post(
          endpoint,
          data: <String, String>{
            'client_id': clientId,
            'client_secret': clientSecret,
            'grant_type': 'client_credentials',
          },
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) => Future.error(tError));

      expect(
        () async => await oAuthApi.getClientToken(
          clientId: clientId,
          clientSecret: clientSecret,
        ),
        throwsA(equals(tError)),
      );
    });
  });

  group('getRefreshedToken', () {
    const refreshToken = 'refreshToken';

    test('successfully returns token', () async {
      when(
        () => dio.post(
          endpoint,
          data: <String, String>{
            'refresh_token': refreshToken,
            'client_id': clientId,
            'client_secret': clientSecret,
            'grant_type': 'refresh_token',
          },
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: endpoint),
          statusCode: 200,
          data: '''{
            "accessToken": "token",
            "refreshToken": "refresh"
          }''',
        ),
      );

      final r = await oAuthApi.getRefreshedToken(
        refreshToken: refreshToken,
        clientId: clientId,
        clientSecret: clientSecret,
      );

      const expected = OAuthToken(
        token: 'token',
        refreshToken: 'refresh',
        expiresAt: null,
      );

      expect(r, equals(expected));
    });

    test('throws DioError if one is thrown by request', () async {
      when(
        () => dio.post(
          endpoint,
          data: <String, String>{
            'refresh_token': refreshToken,
            'client_id': clientId,
            'client_secret': clientSecret,
            'grant_type': 'refresh_token',
          },
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) => Future.error(tError));

      expect(
        () async => await oAuthApi.getRefreshedToken(
          refreshToken: refreshToken,
          clientId: clientId,
          clientSecret: clientSecret,
        ),
        throwsA(equals(tError)),
      );
    });
  });

  group('getUserToken', () {
    const username = 'username';
    const password = 'password';

    test('successfully returns token', () async {
      when(
        () => dio.post(
          endpoint,
          data: <String, String>{
            'username': username,
            'password': password,
            'client_id': clientId,
            'client_secret': clientSecret,
            'grant_type': 'password',
          },
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: endpoint),
          statusCode: 200,
          data: '''{
            "accessToken": "token",
            "refreshToken": "refresh"
          }''',
        ),
      );

      final r = await oAuthApi.getUserToken(
        username: username,
        password: password,
        clientId: clientId,
        clientSecret: clientSecret,
      );

      const expected = OAuthToken(
        token: 'token',
        refreshToken: 'refresh',
        expiresAt: null,
      );

      expect(r, equals(expected));
    });

    test('throws DioError if one is thrown by request', () async {
      when(
        () => dio.post(
          endpoint,
          data: <String, String>{
            'username': username,
            'password': password,
            'client_id': clientId,
            'client_secret': clientSecret,
            'grant_type': 'password',
          },
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) => Future.error(tError));

      expect(
        () async => await oAuthApi.getUserToken(
          username: username,
          password: password,
          clientId: clientId,
          clientSecret: clientSecret,
        ),
        throwsA(equals(tError)),
      );
    });
  });
}

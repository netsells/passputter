import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passputter/src/http_error_exception.dart';
import 'package:passputter/src/oauth_api_impl.dart';
import 'package:passputter/src/oauth_token.dart';
import 'package:test/test.dart';

class MockClient extends Mock implements Client {}

void main() {
  const endpoint = 'https://test.com/oauth/token';
  late MockClient client;
  late OAuthApiImpl oAuthApi;

  setUp(() {
    client = MockClient();
    oAuthApi = OAuthApiImpl(
      endpoint: endpoint,
      client: client,
    );
  });

  final successResponse = Response(
    '''
      {
        "accessToken": "token",
        "refreshToken": "refresh",
        "expiresIn": 1234
      }
    ''',
    200,
  );

  final errorResponse = Response('', 401);

  group('retrieving client token', () {
    test('is successful', () async {
      when(
        () => client.post(
          Uri.parse(endpoint),
          body: any(named: 'body'),
        ),
      ).thenAnswer((invocation) async => successResponse);

      final token = await oAuthApi.getClientToken(
        clientId: 'clientId',
        clientSecret: 'clientSecret',
      );

      expect(
        token,
        isA<OAuthToken>()
            .having((t) => t.token, 'token', equals('token'))
            .having((t) => t.refreshToken, 'refreshToken', equals('refresh')),
      );

      verify(
        () => client.post(
          Uri.parse(endpoint),
          body: <String, String>{
            'client_id': 'clientId',
            'client_secret': 'clientSecret',
            'grant_type': 'client_credentials',
          },
        ),
      );
    });

    test('throws exception when an error is returned', () async {
      when(
        () => client.post(
          Uri.parse(endpoint),
          body: any(named: 'body'),
        ),
      ).thenAnswer((invocation) async => errorResponse);

      expect(
        () async => oAuthApi.getClientToken(
          clientId: 'clientId',
          clientSecret: 'clientSecret',
        ),
        throwsA(isA<HttpErrorException>()),
      );

      verify(
        () => client.post(
          Uri.parse(endpoint),
          body: <String, String>{
            'client_id': 'clientId',
            'client_secret': 'clientSecret',
            'grant_type': 'client_credentials',
          },
        ),
      );
    });
  });

  group('retrieving user token', () {
    test('is successful', () async {
      when(
        () => client.post(
          Uri.parse(endpoint),
          body: any(named: 'body'),
        ),
      ).thenAnswer((invocation) async => successResponse);

      final token = await oAuthApi.getUserToken(
        clientId: 'clientId',
        clientSecret: 'clientSecret',
        username: 'username',
        password: 'password',
      );

      expect(
        token,
        isA<OAuthToken>()
            .having((t) => t.token, 'token', equals('token'))
            .having((t) => t.refreshToken, 'refreshToken', equals('refresh')),
      );

      verify(
        () => client.post(
          Uri.parse(endpoint),
          body: <String, String>{
            'client_id': 'clientId',
            'client_secret': 'clientSecret',
            'username': 'username',
            'password': 'password',
            'grant_type': 'password',
          },
        ),
      );
    });

    test('throws exception when an error is returned', () async {
      when(
        () => client.post(
          Uri.parse(endpoint),
          body: any(named: 'body'),
        ),
      ).thenAnswer((invocation) async => errorResponse);

      expect(
        () async => oAuthApi.getUserToken(
          clientId: 'clientId',
          clientSecret: 'clientSecret',
          username: 'username',
          password: 'password',
        ),
        throwsA(isA<HttpErrorException>()),
      );

      verify(
        () => client.post(
          Uri.parse(endpoint),
          body: <String, String>{
            'client_id': 'clientId',
            'client_secret': 'clientSecret',
            'username': 'username',
            'password': 'password',
            'grant_type': 'password',
          },
        ),
      );
    });
  });

  group('retrieving refresh token', () {
    test('is successful', () async {
      when(
        () => client.post(
          Uri.parse(endpoint),
          body: any(named: 'body'),
        ),
      ).thenAnswer((invocation) async => successResponse);

      final token = await oAuthApi.getRefreshedToken(
        clientId: 'clientId',
        clientSecret: 'clientSecret',
        refreshToken: 'refresh',
      );

      expect(
        token,
        isA<OAuthToken>()
            .having((t) => t.token, 'token', equals('token'))
            .having((t) => t.refreshToken, 'refreshToken', equals('refresh')),
      );

      verify(
        () => client.post(
          Uri.parse(endpoint),
          body: <String, String>{
            'client_id': 'clientId',
            'client_secret': 'clientSecret',
            'refresh_token': 'refresh',
            'grant_type': 'refresh_token',
          },
        ),
      );
    });

    test('throws exception when an error is returned', () async {
      when(
        () => client.post(
          Uri.parse(endpoint),
          body: any(named: 'body'),
        ),
      ).thenAnswer((invocation) async => errorResponse);

      expect(
        () async => oAuthApi.getRefreshedToken(
          clientId: 'clientId',
          clientSecret: 'clientSecret',
          refreshToken: 'refresh',
        ),
        throwsA(isA<HttpErrorException>()),
      );

      verify(
        () => client.post(
          Uri.parse(endpoint),
          body: <String, String>{
            'client_id': 'clientId',
            'client_secret': 'clientSecret',
            'refresh_token': 'refresh',
            'grant_type': 'refresh_token',
          },
        ),
      );
    });
  });
}

# Passputter

Easily authenticate using OAuth 2.0 client/password grants.

[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
[![Gitmoji](https://img.shields.io/badge/gitmoji-%20😜%20😍-FFDD67.svg)](https://gitmoji.dev/)
[![Pub Version](https://img.shields.io/pub/v/passputter)](https://pub.dev/packages/passputter)
![GitHub](https://img.shields.io/github/license/netsells/passputter)
![GitHub Workflow Status](https://img.shields.io/github/workflow/status/netsells/passputter/Test)
[![Coverage Status](https://coveralls.io/repos/github/netsells/passputter/badge.svg?branch=master)](https://coveralls.io/github/netsells/passputter?branch=master)

## 🚀 Installation

Install passputter from [pub.dev](https://pub.dev/packages/passputter):

```yaml
passputter: ^1.0.1
```

## ✅ Prerequisites

Passputter is designed to work alongside a REST API which uses OAuth 2.0 Client Credentials and Password Grants, such as [Laravel Passport](https://laravel.com/docs/8.x/passport).

You will need:

- [Dio](https://pub.dev/packages/dio). Passputter **only** works with Dio.
- An API endpoint which can be used to request tokens. Passputter will send `POST` requests to the endpoint containing URL Form Encoded data.
  - Typically these endpoints end with `oauth/token`
- A set of OAuth client credentials (an ID and a secret).
  - Some apps have separate credentials for client and password grants. Passputter supports this.

## 🔨 Usage

### 📦 Step 1: Implement a way to store tokens

Passputter provides a `TokenStorage` interface, but you will need to create an implementation. You will need to be able to store, retrieve, and delete client and user tokens. Something secure is strongly recommended such as `FlutterSecureStorage`, or an encrypted [Hive](https://hivedb.dev) box.

Here's an example of an implementation using Hive:

```dart
class HiveTokenStorage implements TokenStorage {
    const HiveTokenStorage(this._box);

    final Box<Map<String, dynamic>> _box;

    static const _clientTokenKey = 'clientToken';
    static const _userTokenKey = 'userToken';

    @override
    OAuthToken? get clientToken {
        final tokenMap = _box.get(_clientTokenKey);
        if (tokenMap != null) {
            return OAuthToken.fromJson(tokenMap);
        } else {
            return null;
        }
    }

    @override
    OAuthToken? get userToken {
        final tokenMap = _box.get(_userTokenKey);
        if (tokenMap != null) {
            return OAuthToken.fromJson(tokenMap);
        } else {
            return null;
        }
    }

    @override
    Future<void> saveClientToken(OAuthToken token) async {
        await _box.put(_clientTokenKey, token.toJson());
    }

    @override
    Future<void> saveUserToken(OAuthToken token) async {
        await _box.put(_userTokenKey, token.toJson());
    }

    @override
    Future<void> deleteClientToken() async {
        await _box.delete(_clientTokenKey);
    }

    @override
    Future<void> deleteUserToken() async {
        await _box.delete(_userTokenKey);
    }
}
```

_Note: The `fromJson` and `toJson` methods in this example aren't actually included in the Passputter package. You could implement them yourself as extension methods._

### ✨ Step 2: Create a Passputter object

The `Passputter` class is the class you will use to log the user in and out, as well as to determine the current auth state.

Create one like this:

```dart
final passputter = Passputter(
    dio: Dio(), // This will be used to request tokens.
    endpoint: 'https://api.myapp.com/oauth/token',
    clientId: '1', // Client ID for password grant
    clientSecret: 'secret', // Client Secret for password grant
    tokenStorage: tokenStorage, // Your implementation of TokenStorage
);
```

You can then use your new `Passputter` instance to log in, log out, and get the current state:

```dart
await passputter.isLoggedIn; // false

await passputter.logIn(email: 'email@example.com', password: 'password');

await passputter.isLoggedIn; // true

await passputter.logOut();

await passputter.isLoggedIn; // false
```

### ✋🏻 Step 3: Use the token interceptors

Passputter provides two interceptors which you can add to your Dio instances: `UserTokenInterceptor` and `ClientTokenInterceptor`.

`UserTokenInterceptor` will add a user token to all requests. If a token has expired, the interceptor will attempt to refresh it. If no token exists, the interceptor will continue with the request without attaching a token.

`ClientTokenInterceptor` will add a client token to all requests. If no token is saved in your `TokenStorage`, the interceptor will attempt to generate one before continuing.

### 💰 Step 4: Profit

That's it! You now have a fully working authentication system for your Flutter app.

## 👨🏻‍💻 Authors

- [@ptrbrynt](https://www.github.com/ptrbrynt) at [Netsells](https://netsells.co.uk/)

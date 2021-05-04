/// Main passputter interface.
///
/// Includes methods for
abstract class PassputterInterface {
  /// Whether the user is logged in.
  bool get isLoggedIn;

  /// Log in with the given [email] and [password] credentials.
  Future<void> logIn({
    required String email,
    required String password,
  });

  /// Log out of the application
  Future<void> logOut();
}

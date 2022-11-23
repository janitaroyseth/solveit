import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthService {
  User? get currentUser;

  /// Signing in anonymously.
  Future<User?> signInAnonymously();

  /// Signing in using facebook.
  Future<UserCredential?> signInWithFacebook();

  /// Signing in with email and password.
  Future<User?> signInWithEmailAndPassword(String email, String password);

  /// Registering a new used with email and password.
  Future<User?> registerWithEmailAndPassword(String email, String password);

  /// Signing in with Google.
  Future<UserCredential?> signInWithGoogle();

  /// Sign out.
  Future<void> signOut();
}

/// The implemitasjon of the authentication service.
class Auth implements AuthService {
  final _fireBaseAuth = FirebaseAuth.instance;

  GoogleSignIn? _googleSignIn;
  final _facebookLogin = FacebookAuth.instance;

  @override
  User? get currentUser => _fireBaseAuth.currentUser;

  @override
  Future<User?> signInAnonymously() async {
    final userCredentials = await _fireBaseAuth.signInAnonymously();
    return userCredentials.user;
  }

  @override
  Future<UserCredential?> signInWithFacebook() async {
    final response = await _facebookLogin.login(permissions: [
      "public_profile",
      "email",
    ]);
    switch (response.status) {
      case LoginStatus.success:
        final accessToken = response.accessToken;
        final userCredential = await _fireBaseAuth.signInWithCredential(
          FacebookAuthProvider.credential(accessToken!.token),
        );
        return userCredential;
      case LoginStatus.cancelled:
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      case LoginStatus.failed:
        throw FirebaseAuthException(
          code: 'ERROR_FACEBOOK_LOGIN_FAILED',
          message: response.message,
        );
      case LoginStatus.operationInProgress:
        // TODO: Handle this case.
        break;
    }
  }

  @override
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    final UserCredential userCredential = await _fireBaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  @override
  Future<User?> registerWithEmailAndPassword(
      String email, String password) async {
    final UserCredential userCredential = await _fireBaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  @override
  Future<UserCredential?> signInWithGoogle() async {
    _googleSignIn = GoogleSignIn();
    final googleUser = await _googleSignIn?.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential = await _fireBaseAuth
            .signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        return userCredential;
      } else {
        throw FirebaseAuthException(
          code: "ERROR_MISSING_GOOGLE_ID_TOKEN",
          message: "Missing Google ID token",
        );
      }
    } else {
      throw FirebaseAuthException(
        code: "ERROR_ABORTED_BY_USER",
        message: "Sign in aborted by user",
      );
    }
  }

  @override
  Future<void> signOut() async {
    await _facebookLogin.logOut();
    await _googleSignIn?.signOut();
    await _fireBaseAuth.signOut();
  }
}

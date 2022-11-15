import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthService {
  User? get currentUser;

  /// Signing in anonymously.
  Future<User?> signInAnonymously();

  /// Signing in with Google.
  // Future<User?> signInWithGoogle();

  /// Sign out.
  Future<void> signOut();
}

/// The implemitasjon of the authentication service.
class Auth implements AuthService {
  final _fireBaseAuth = FirebaseAuth.instance;

  @override
  User? get currentUser => _fireBaseAuth.currentUser;

  @override
  Future<User?> signInAnonymously() async {
    final userCredentials = await _fireBaseAuth.signInAnonymously();
    return userCredentials.user;
  }

  // @override
  // Future<User?> signInWithGoogle() async {
  //   final googleSignIn = GoogleSignIn();
  //   final googleUser = await googleSignIn.signIn();
  //   if (googleUser != null) {
  //     final googleAuth = await googleUser.authentication;
  //     if (googleAuth.idToken != null) {
  //       final userCredential = await _fireBaseAuth
  //           .signInWithCredential(GoogleAuthProvider.credential(
  //         idToken: googleAuth.idToken,
  //         accessToken: googleAuth.accessToken,
  //       ));
  //       return userCredential.user;
  //     } else {
  //       throw FirebaseAuthException(
  //         code: "ERROR_MISSING_GOOGLE_ID_TOKEN",
  //         message: "Missing Google ID token",
  //       );
  //     }
  //   } else {
  //     throw FirebaseAuthException(
  //       code: "ERROR_ABORTED_BY_USER",
  //       message: "Sign in aborted by user",
  //     );
  //   }
  // }

  @override
  Future<void> signOut() async {
    // final googleSignIn = GoogleSignIn();
    // await googleSignIn.signOut();
    await _fireBaseAuth.signOut();
  }
}

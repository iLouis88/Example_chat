import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // signIn with email and password
  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('Email is not registered account');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password. Please check your password again');
      }
    }
  }

  // signInWithGoogle
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await _auth.signInWithCredential(credential);
    } catch (e) {
      throw Exception('Sign in with Google failed');
    }
  }

  // reset password with gmail and password method
  Future<void> resetPasswordWithGmailAndPassword(
      {required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Password reset failed');
    }
  }
}

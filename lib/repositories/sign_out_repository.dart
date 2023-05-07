import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignOutRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // signOut
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();
    } catch (e) {
      throw Exception('Sign out failed');
    }
  }
}

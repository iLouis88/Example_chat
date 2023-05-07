import 'package:firebase_auth/firebase_auth.dart';

class PhoneSignInRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // to sent otp end push to otpScreen
  Future<void> sendOtpPhoneNumber(
      {required String phoneNumber,
      required void Function(String verificationId) pushToOtp}) async {
    try {
      await _auth.verifyPhoneNumber(
        timeout: const Duration(seconds: 90),
        phoneNumber: '+84$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) async {
          // ANDROID ONLY!
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (error) {
          throw Exception(error.message);
        },
        codeSent: (String verificationId, int? resendToken) async {
          pushToOtp(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException {
      throw Exception('Login with phone number failed');
    }
  }

  // verify otp
  Future<void> verifyOTP(
      {required String verificationId,
      required String smsCode,
      required void Function()? onError}) async {
    try {
      var credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException {
      onError!();
      throw Exception('OTP verification failed');
    }
  }
}

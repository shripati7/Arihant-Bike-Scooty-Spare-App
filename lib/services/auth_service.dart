import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseAuth get auth => _auth;

  // Current User
  User? get currentUser => _auth.currentUser;

  // Auth State
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  String _verificationId = '';

  //==========================
  // Send OTP
  //==========================

  Future<void> sendOtp({
    required String phoneNumber,
    required Function() onCodeSent,
    required Function(String error) onError,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        onError(e.message ?? "OTP Verification Failed");
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        onCodeSent();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  //==========================
  // Verify OTP
  //==========================

  Future<UserCredential?> verifyOtp(
    String otp,
  ) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );

      return await _auth.signInWithCredential(
        credential,
      );
    } on FirebaseAuthException {
      return null;
    }
  }

  //==========================
  // Logout
  //==========================

  Future<void> logout() async {
    await _auth.signOut();
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'user_service.dart';

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
    try {
      debugPrint("========== SEND OTP ==========");
      debugPrint("Phone Number: $phoneNumber");

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          debugPrint("Auto Verification Completed");

          try {
            await _auth.signInWithCredential(credential);

            // Save user in Firestore (first login only)
            await UserService.instance.saveUser();

            debugPrint("Auto Login Success");
          } catch (e) {
            debugPrint("Auto Login Error: $e");
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          debugPrint("========== FIREBASE ERROR ==========");
          debugPrint("Code    : ${e.code}");
          debugPrint("Message : ${e.message}");
          debugPrint("===================================");

          onError("${e.code}\n${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          debugPrint("OTP Sent Successfully");

          _verificationId = verificationId;

          onCodeSent();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          debugPrint("Auto Retrieval Timeout");

          _verificationId = verificationId;
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      debugPrint("Unexpected Error: $e");
      onError(e.toString());
    }
  }

  //==========================
  // Verify OTP
  //==========================

  Future<UserCredential?> verifyOtp(String otp) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );

      final result = await _auth.signInWithCredential(credential);

      // Save user in Firestore (first login only)
      await UserService.instance.saveUser();

      debugPrint("OTP Verification Success");

      return result;
    } on FirebaseAuthException catch (e) {
      debugPrint("========== VERIFY OTP ERROR ==========");
      debugPrint("Code    : ${e.code}");
      debugPrint("Message : ${e.message}");
      debugPrint("======================================");

      return null;
    }
  }

  //==========================
  // Logout
  //==========================

  Future<void> logout() async {
    await _auth.signOut();

    debugPrint("User Logged Out");
  }
}

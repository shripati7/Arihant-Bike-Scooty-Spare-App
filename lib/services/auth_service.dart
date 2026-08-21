import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'user_service.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseAuth get auth => _auth;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  String _verificationId = '';

  // ==========================
  // Send OTP
  // ==========================

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
        verificationCompleted: (
          PhoneAuthCredential credential,
        ) async {
          try {
            final result = await _auth.signInWithCredential(
              credential,
            );

            await UserService.instance.saveUser();

            debugPrint(
              "Auto Login Success ${result.user?.uid}",
            );
          } catch (e) {
            debugPrint(
              "Auto Login Error: $e",
            );
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          debugPrint(
            "========== FIREBASE ERROR ==========",
          );
          debugPrint(
            "Code    : ${e.code}",
          );
          debugPrint(
            "Message : ${e.message}",
          );

          onError(
            "${e.code}\n${e.message}",
          );
        },
        codeSent: (
          String verificationId,
          int? resendToken,
        ) {
          _verificationId = verificationId;

          onCodeSent();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
        timeout: const Duration(
          seconds: 60,
        ),
      );
    } catch (e) {
      onError(
        e.toString(),
      );
    }
  }

  // ==========================
  // Verify OTP
  // ==========================

  Future<UserCredential?> verifyOtp(
    String otp,
  ) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );

      final result = await _auth.signInWithCredential(
        credential,
      );

      await UserService.instance.saveUser();

      debugPrint(
        "OTP Verification Success",
      );

      return result;
    } on FirebaseAuthException catch (e) {
      debugPrint(
        "========== VERIFY OTP ERROR ==========",
      );
      debugPrint(
        "Code    : ${e.code}",
      );
      debugPrint(
        "Message : ${e.message}",
      );

      return null;
    }
  }

  // ==========================
  // Logout
  // ==========================

  Future<void> logout() async {
    await _auth.signOut();

    debugPrint(
      "User Logged Out",
    );
  }
}

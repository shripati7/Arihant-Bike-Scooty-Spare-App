import 'package:flutter/material.dart';

import '../screens/main_navigation_screen.dart';
import '../services/auth_service.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();

  bool loading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> verifyOtp() async {
    if (_otpController.text.trim().length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter Valid OTP"),
        ),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    final result = await AuthService.instance.verifyOtp(
      _otpController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      loading = false;
    });

    if (result != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const MainNavigationScreen(),
        ),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid OTP"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify OTP"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),
            const Icon(
              Icons.lock_outline,
              color: Colors.red,
              size: 90,
            ),
            const SizedBox(height: 20),
            Text(
              "OTP sent to +91 ${widget.phoneNumber}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter OTP",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : verifyOtp,
              child: loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      "Verify OTP",
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

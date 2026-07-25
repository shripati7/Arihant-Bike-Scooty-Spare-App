import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  bool loading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> sendOtp() async {
    String phone = _phoneController.text.trim();

    if (phone.isEmpty) {
      showMessage("Enter Mobile Number");
      return;
    }

    if (phone.length != 10) {
      showMessage("Enter Valid Mobile Number");
      return;
    }

    setState(() {
      loading = true;
    });

    await AuthService.instance.sendOtp(
      phoneNumber: "+91$phone",
      onCodeSent: () {
        if (!mounted) return;

        setState(() {
          loading = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpScreen(
              phoneNumber: phone,
            ),
          ),
        );
      },
      onError: (error) {
        if (!mounted) return;

        setState(() {
          loading = false;
        });

        showMessage(error);
      },
    );
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),
            const Icon(
              Icons.phone_android,
              size: 90,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            const Text(
              "Login with Mobile Number",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Mobile Number",
                prefixText: "+91 ",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : sendOtp,
              child: loading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      "Send OTP",
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

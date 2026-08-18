import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/main_navigation_screen.dart';
import '../screens/subscription_screen.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import 'login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.instance.authStateChanges,
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // User Logged In
        if (snapshot.hasData) {
          return FutureBuilder(
            future: UserService.instance.getCurrentUser(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final user = userSnapshot.data;

              if (user == null) {
                return const LoginScreen();
              }

              // Subscription Disabled
              if (!user.isActive) {
                return const SubscriptionScreen();
              }

              // Trial Expired
              if (user.trialEndDate != null &&
                  user.trialEndDate!.toDate().isBefore(DateTime.now())) {
                return const SubscriptionScreen();
              }

              return const MainNavigationScreen();
            },
          );
        }

        // User Not Logged In
        return const LoginScreen();
      },
    );
  }
}

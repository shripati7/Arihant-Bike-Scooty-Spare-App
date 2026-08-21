import '../screens/dealer_registration_screen.dart';
import '../models/user_model.dart';
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
              if (user.role.isEmpty ||
                  user.shopId.isEmpty ||
                  user.shopCode.isEmpty) {
                return const DealerRegistrationScreen();
              }

              // Shop not created yet
              if (user.shopId.isEmpty) {
                return const DealerRegistrationScreen();
              }

              // Subscription Disabled
              if (!user.isActive) {
                return const SubscriptionScreen();
              }

              // Trial Expired
              if (user.trialEndDate != null &&
                  user.trialEndDate!.toDate().isBefore(DateTime.now())) {
                if (user.isActive) {
                  UserService.instance.updateUser(
                    UserModel(
                      uid: user.uid,
                      name: user.name,
                      phone: user.phone,
                      email: user.email,
                      address: user.address,
                      createdAt: user.createdAt,
                      role: user.role,
                      shopId: user.shopId,
                      shopCode: user.shopCode,
                      supplierId: user.supplierId,
                      isActive: false,
                      trialEndDate: user.trialEndDate,
                    ),
                  );
                }

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

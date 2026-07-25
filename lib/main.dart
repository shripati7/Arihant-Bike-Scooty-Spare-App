import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth/auth_wrapper.dart';
import 'firebase_options.dart';
import 'providers/cart_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ArihantApp());
}

class ArihantApp extends StatelessWidget {
  const ArihantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Arihant Bike & Scooty Spare',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.red,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          cardTheme: const CardThemeData(
            elevation: 4,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              minimumSize: const Size(
                double.infinity,
                50,
              ),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

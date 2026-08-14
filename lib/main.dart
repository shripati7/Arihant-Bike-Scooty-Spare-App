import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/cart_provider.dart';
import 'auth/auth_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const ArihantProductStudio(),
    ),
  );
}

class ArihantProductStudio extends StatelessWidget {
  const ArihantProductStudio({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Arihant Product Studio',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.red,
      ),
      home: const AuthWrapper(),
    );
  }
}

import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const ArihantProductStudio());
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
      home: const HomeScreen(),
    );
  }
}

import 'package:flutter/material.dart';
// Import your generated resource classes!
import 'package:example/resources/images.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Asset Generator Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Easy Asset Generator Demo')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Using a generated image asset
            Image.asset(
              Images.imgFlutterBrandlogo, // Use your generated asset constant!
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 24),
            const Text('No more typos. Enjoy 🚀'),
          ],
        ),
      ),
    );
  }
}

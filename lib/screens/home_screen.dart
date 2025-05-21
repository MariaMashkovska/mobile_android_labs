import 'package:flutter/material.dart';
import '../services/shared_prefs_user_service.dart';

class HomeScreen extends StatelessWidget {
  final SharedPrefsUserService userService;

  const HomeScreen({super.key, required this.userService});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Noise Sensor')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Noise Level: unknown silly',
              style: TextStyle(fontSize: 24, color: Colors.orange),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/profile'),
              child: const Text('Go to Profile'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/calendar'),
              child: const Text('Go to Calendar'),
            ),
          ],
        ),
      ),
    );
  }
}

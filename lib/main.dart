import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'services/shared_prefs_user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final userService = SharedPrefsUserService(prefs);
  final isLoggedIn = await userService.isLoggedIn();

  runApp(MyApp(initialRoute: isLoggedIn ? '/home' : '/login', userService: userService));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final SharedPrefsUserService userService;

  const MyApp({super.key, required this.initialRoute, required this.userService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.orange,
      ),
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => LoginScreen(userService: userService),
        '/register': (context) => RegisterScreen(userService: userService),
        '/profile': (context) => ProfileScreen(userService: userService),
        '/home': (context) => HomeScreen(userService: userService),
      },
    );
  }
}

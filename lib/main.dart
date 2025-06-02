import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_android/data/datasources/user_local_data_source_impl.dart';
import 'package:mobile_android/data/repositories/auth_repository_impl.dart';
import 'package:mobile_android/presentation/cubit/connectivity_cubit.dart';
import 'package:mobile_android/presentation/providers/auth_provider.dart';
import 'package:mobile_android/presentation/providers/noise_provider.dart';
import 'package:mobile_android/presentation/screens/calendar/calendar_screen.dart';
import 'package:mobile_android/presentation/screens/home/home_screen.dart';
import 'package:mobile_android/presentation/screens/login/login_screen.dart';
import 'package:mobile_android/presentation/screens/profile/profile_screen.dart';
import 'package:mobile_android/presentation/screens/register/register_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final localDataSource = UserLocalDataSourceImpl(prefs: prefs);
  final authRepo = AuthRepositoryImpl(localDataSource: localDataSource);
  final authProvider = AuthProvider(authRepo);
  await authProvider.loadUser();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authProvider),
        ChangeNotifierProvider(create: (_) => NoiseProvider()),
      ],
      child: BlocProvider(
        create: (_) => ConnectivityCubit(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final initialRoute = auth.isLoggedIn ? '/home' : '/login';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.orange,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.orange,
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.black,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.orange),
          bodyMedium: TextStyle(color: Colors.orange),
          titleLarge: TextStyle(color: Colors.orange),
        ),
      ),
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/calendar': (context) => const CalendarScreen(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_android/presentation/cubit/connectivity_cubit.dart';
import 'package:mobile_android/presentation/providers/auth_provider.dart';
import 'package:mobile_android/presentation/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  ConnectivityStatus _lastStatus = ConnectivityStatus.connected;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      if (!mounted) return;
      final status = context.read<ConnectivityCubit>().state;
      if (status == ConnectivityStatus.disconnected) {
        _showNoInternetDialog();
      }
    });
  }

  void _showNoInternetDialog() {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('No Internet'),
        content: const Text('You are offline. Please check your connection.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return BlocListener<ConnectivityCubit, ConnectivityStatus>(
      listener: (context, state) {
        if (_lastStatus == ConnectivityStatus.connected &&
            state == ConnectivityStatus.disconnected) {
          _showNoInternetDialog();
        }
        _lastStatus = state;
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text('Login', style: TextStyle(fontSize: 24)),
                const SizedBox(height: 16),
                CustomTextField(controller: emailController, label: 'Email'),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: passwordController,
                  label: 'Password',
                  obscure: true,
                ),
                const SizedBox(height: 16),
                if (auth.error != null)
                  Text(auth.error!, style: const TextStyle(color: Colors.red)),
                ElevatedButton(
                  onPressed: () async {
                    final connection =
                        context.read<ConnectivityCubit>().state;

                    if (connection == ConnectivityStatus.disconnected) {
                      _showNoInternetDialog();
                      return;
                    }

                    final success = await auth.login(
                      email: emailController.text.trim(),
                      password: passwordController.text,
                    );
                    if (success && context.mounted) {
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  },
                  child: const Text('Login'),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/register'),
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

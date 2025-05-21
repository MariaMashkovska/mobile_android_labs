import 'package:flutter/material.dart';
import 'package:mobile_android/presentation/providers/auth_provider.dart';
import 'package:mobile_android/presentation/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final dobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text('Register', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 16),
              CustomTextField(controller: nameController,
                  label: 'Name',),
              const SizedBox(height: 8),
              CustomTextField(controller: emailController,
                  label: 'Email',),
              const SizedBox(height: 8),
              CustomTextField(controller: passwordController,
                  label: 'Password', obscure: true,),
              const SizedBox(height: 8),
              CustomTextField(controller: dobController,
                  label: 'Date of Birth',),
              const SizedBox(height: 16),
              if (auth.error != null)
                Text(auth.error!, style: const TextStyle(color: Colors.red)),
              ElevatedButton(
                onPressed: () async {
                  final success = await auth.register(
                    name: nameController.text.trim(),
                    email: emailController.text.trim(),
                    password: passwordController.text,
                    dob: dobController.text.trim(),
                  );
                  if (success && context.mounted) {
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                },
                child: const Text('Sign Up'),
              ),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                child: const Text('Back to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

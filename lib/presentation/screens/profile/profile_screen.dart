import 'package:flutter/material.dart';
import 'package:mobile_android/presentation/providers/auth_provider.dart';
import 'package:mobile_android/presentation/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController dobController;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user!;
    nameController = TextEditingController(text: user.name);
    emailController = TextEditingController(text: user.email);
    dobController = TextEditingController(text: user.dob);
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomTextField(controller: nameController, label: 'Name'),
            const SizedBox(height: 8),
            CustomTextField(controller: emailController, label: 'Email'),
            const SizedBox(height: 8),
            CustomTextField(controller: dobController, label: 'Date of birth'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                auth.updateProfile(
                  name: nameController.text.trim(),
                  email: emailController.text.trim(),
                  dob: dobController.text.trim(),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile Updated')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

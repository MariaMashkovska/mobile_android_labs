import 'package:flutter/material.dart';
import '../services/shared_prefs_user_service.dart';

class LoginScreen extends StatefulWidget {
  final SharedPrefsUserService userService;

  const LoginScreen({Key? key, required this.userService}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _loginError = '';

  void _login() async {
    if (_formKey.currentState!.validate()) {
      bool success = await widget.userService.loginUser(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (success) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          _loginError = 'Невірна електронна пошта або пароль';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Вхід')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Електронна пошта'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введіть електронну пошту';
                  } else if (!RegExp(r'^[\w\-\.]+@lala\$').hasMatch(value.trim())) {
                    return 'Пошта має бути у форматі example@lala';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Пароль'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Пароль має містити щонайменше 6 символів';
                  }
                  return null;
                },
              ),
              if (_loginError.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _loginError,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text('Увійти'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text('Немає акаунту? Зареєструйтесь'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

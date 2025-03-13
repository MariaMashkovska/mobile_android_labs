import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MagicCounterScreen(),
    );
  }
}

class MagicCounterScreen extends StatefulWidget {
  const MagicCounterScreen({super.key});

  @override
  State<MagicCounterScreen> createState() => _MagicCounterScreenState();
}

class _MagicCounterScreenState extends State<MagicCounterScreen> {
  int _counter = 0;
  String _message = "";
  final TextEditingController _controller = TextEditingController();

  void _handleInput() {
    String input = _controller.text.trim();

    if (input == "avada kedavra") {
      setState(() {
        _counter = 0;
        _message = "Закляття спрацювало!";
      });
    } else if (input == "Крокоділо Бомбарділо") {
      setState(() {
        _message = "تم تنفيذ التعويذة! allah akbar"; //
      });
    } else {
      int? value = int.tryParse(input);
      if (value != null) {
        setState(() {
          _counter += value;
          _message = "";
        });
      } else {
        setState(() {
          _message = "Ти не тикай";
        });
      }
    }

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Магічний лічильник')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$_counter',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Введіть число або закляття...",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _handleInput(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _handleInput,
              child: const Text("Примінити магію"),
            ),
            const SizedBox(height: 16),
            Text(
              _message,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _message == "Ти не тикай" ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

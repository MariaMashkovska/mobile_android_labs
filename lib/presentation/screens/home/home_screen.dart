import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_android/presentation/cubit/connectivity_cubit.dart';
import 'package:mobile_android/presentation/providers/auth_provider.dart';
import 'package:mobile_android/presentation/providers/noise_provider.dart';
import 'package:mobile_android/presentation/widgets/user_info_card.dart';
import 'package:mobile_android/sensor/mqtt_noise_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _dialogShown = false;
  late MQTTNoiseService _mqttNoiseService;

  void _showConnectionLostDialog() {
    if (_dialogShown) return;
    _dialogShown = true;
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('No Internet'),
        content: const Text('Connection lost. Some features may not work.'),
        actions: [
          TextButton(
            onPressed: () {
              _dialogShown = false;
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout(AuthProvider auth) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await auth.logout();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void initState() {
    super.initState();

    _mqttNoiseService = MQTTNoiseService(
      host: '29ca9aa3e9614580b2b384d9a0290e8c.s1.eu.hivemq.cloud',
      port: 8883,
      clientId: 'noise_client_${DateTime.now().millisecondsSinceEpoch}',
      username: 'noise',
      password: 'Qwerty123',
      onNoiseData: (value) {
        final noiseProv = Provider.of<NoiseProvider>(context, listen: false);
        noiseProv.setNoise(value);
      },
    );

    _mqttNoiseService.connect();
  }

  @override
  void dispose() {
    _mqttNoiseService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final noise = Provider.of<NoiseProvider>(context);
    final user = auth.user;

    return BlocListener<ConnectivityCubit, ConnectivityStatus>(
      listener: (context, state) {
        if (state == ConnectivityStatus.disconnected) {
          _showConnectionLostDialog();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _confirmLogout(auth),
            ),
          ],
        ),
        body: user == null
            ? const Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UserInfoCard(user: user),
                const SizedBox(height: 20),
                Text(
                  'Noise per hour: ${noise.currentNoise.toStringAsFixed(1)} dB',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.person),
                  label: const Text('Profile'),
                  onPressed: () => Navigator.pushNamed(context, '/profile'),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Calendar'),
                  onPressed: () => Navigator.pushNamed(context, '/calendar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

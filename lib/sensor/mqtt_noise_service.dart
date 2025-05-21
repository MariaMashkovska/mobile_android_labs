import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

typedef OnNoiseData = void Function(double noise);

class MQTTNoiseService {
  final String host;
  final int port;
  final String clientId;
  final String? username;
  final String? password;
  final OnNoiseData onNoiseData;

  late final MqttServerClient _client;

  MQTTNoiseService({
    required this.host,
    required this.clientId,
    required this.onNoiseData,
    this.username,
    this.password,
    this.port = 8883,
  }) {
    _client = MqttServerClient.withPort(host, clientId, port)
      ..secure = true
      ..securityContext = SecurityContext.defaultContext
      ..keepAlivePeriod = 20
      ..logging(on: false)
      ..onConnected = _onConnected
      ..onDisconnected = _onDisconnected
      ..onSubscribed = _onSubscribed
      ..setProtocolV311();
  }

  Future<void> connect() async {
    final connMsg = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .startClean()
        .withWillQos(MqttQos.atMostOnce);

    if (username != null && password != null) {
      connMsg.authenticateAs(username!, password!);
    }

    _client.connectionMessage = connMsg;

    try {
      await _client.connect();
    } catch (e) {
      debugPrint('❌ MQTT connect exception: $e');
      _client.disconnect();
      return;
    }

    if (_client.connectionStatus?.state == MqttConnectionState.connected) {
      _client.subscribe('sensor/noise', MqttQos.atMostOnce);
      _client.updates?.listen(_onMessage);
    } else {
      debugPrint('❌ MQTT connection failed: ${_client.connectionStatus}');
      _client.disconnect();
    }
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage?>> messages) {
    for (final msg in messages) {
      final payload = MqttPublishPayload.bytesToStringAsString(
        (msg.payload as MqttPublishMessage).payload.message,
      );
      final double? value = double.tryParse(payload);
      if (value != null) {
        debugPrint('📡 Noise received: $value dB');
        onNoiseData(value);
      }
    }
  }

  void _onConnected() => debugPrint('✅ Connected to broker $host');
  void _onDisconnected() => debugPrint('❌ Disconnected from broker');
  void _onSubscribed(String topic) => debugPrint('✅ Subscribed to $topic');

  void disconnect() => _client.disconnect();
}

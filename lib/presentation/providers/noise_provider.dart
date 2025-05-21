import 'package:flutter/material.dart';

class NoiseProvider extends ChangeNotifier {
  double _currentNoise = 0;
  final List<double> _hourBuffer = [];
  final Map<DateTime, List<double>> _dailyAverages = {};

  double get currentNoise => _currentNoise;
  Map<DateTime, List<double>> get dailyNoise => _dailyAverages;

  void setNoise(double value) {
    _currentNoise = value;
    _hourBuffer.add(value);
    notifyListeners();
  }

  void storeHourlyAverage() {
    if (_hourBuffer.isEmpty) return;

    final avg = _hourBuffer.reduce((a, b) => a + b) / _hourBuffer.length;
    final roundedAvg = double.parse(avg.toStringAsFixed(1));
    _hourBuffer.clear();

    final today = DateTime.now();
    final dateKey = DateTime(today.year, today.month, today.day);

    _dailyAverages.putIfAbsent(dateKey, () => []);
    _dailyAverages[dateKey]!.add(roundedAvg);

    notifyListeners();
  }

  List<double> getNoiseForDate(DateTime date) {
    final key = DateTime(date.year, date.month, date.day);
    return _dailyAverages[key] ?? [];
  }
}

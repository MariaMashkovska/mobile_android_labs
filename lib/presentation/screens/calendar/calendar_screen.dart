import 'package:flutter/material.dart';
import 'package:mobile_android/presentation/providers/noise_provider.dart';
import 'package:mobile_android/presentation/widgets/simple_line_chart.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final noise = Provider.of<NoiseProvider>(context);
    final selectedDate = _selectedDay ?? DateTime.now();
    final dayAverages = noise.getNoiseForDate(selectedDate);

    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: Column(
        children: [
          TableCalendar<DateTime>(
            firstDay: DateTime.utc(2020),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() => _calendarFormat = format);
            },
          ),
          const SizedBox(height: 12),
          Text(
            'Average noise values on ${_formatDate(selectedDate)}:',
            style: const TextStyle(fontSize: 16, color: Colors.orange),
          ),
          if (dayAverages.isNotEmpty) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SimpleLineChart(values: dayAverages),
            ),
            const SizedBox(height: 8),
          ],
          Expanded(
            child: dayAverages.isEmpty
                ? const Center(child: Text('No data for this day'))
                : ListView.builder(
              itemCount: dayAverages.length,
              itemBuilder: (context, index) {
                final value = dayAverages[index];
                return ListTile(
                  leading: const Icon(Icons.graphic_eq),
                  title: Text('$value dB'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_app/shared/shared.dart';

class DayWidget extends ConsumerStatefulWidget {
  final DateTime day;

  const DayWidget({required this.day, super.key});

  @override
  ConsumerState<DayWidget> createState() => _DayWidgetState();
}

class _DayWidgetState extends ConsumerState<DayWidget> {
  @override
  Widget build(BuildContext context) {
    final tripNotifier = ref.watch(tripProvider.notifier);
    final tripState = ref.watch(tripProvider);

    // Get the current date without time and in local time
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    // Get the widget's date without time and in local time
    DateTime widgetDay = DateTime(widget.day.year, widget.day.month, widget.day.day);

    // Check if the widget's day is before today
    bool isPast = widgetDay.isBefore(today);

    // Check if this day is the selected day
    DateTime? selectedDay = tripState.daySelected != null
        ? DateTime(tripState.daySelected!.year, tripState.daySelected!.month, tripState.daySelected!.day)
        : null;

    bool isSelected = selectedDay != null && widgetDay == selectedDay;

    // Determine the background color
    Color backgroundColor;
    if (isSelected) {
      backgroundColor = Colors.deepOrange; // Selected day color
    } else if (isPast) {
      backgroundColor = Colors.grey; // Past day color
    } else {
      backgroundColor = Colors.black.withOpacity(0.5); // Upcoming day color
    }

    return Padding(
      padding: const EdgeInsets.all(5),
      child: GestureDetector(
        onTap: () => tripNotifier.selectDay(widget.day),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: backgroundColor,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Column(
              children: [
                Text(
                  getDay(widget.day.weekday),
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Text(
                  widget.day.day.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


String getDay(int i) {
  switch (i) {
    case 1:
      return 'L';
    case 2:
      return 'M';
    case 3:
      return 'M';
    case 4:
      return 'J';
    case 5:
      return 'V';
    case 6:
      return 'S';
    case 7:
      return 'D';
    default:
      return 'Error';
  }
}

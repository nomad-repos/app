import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_app/features/trips/presentation/presentation.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final trip = ref.watch(tripProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SfCalendar(
              view: CalendarView.day
            ),
          ],
        ),
      ),
    );
  }
}
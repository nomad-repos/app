import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_app/shared/shared.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late final CalendarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();

    // Initialize the controller's displayDate and selectedDate
    final trip = ref.read(tripProvider);
    _controller.displayDate = trip.daySelected ??
        (trip.trip != null
            ? HttpDate.parse(trip.trip!.tripStartDate)
            : DateTime.now());
    _controller.selectedDate = _controller.displayDate;
  }

  @override
  Widget build(BuildContext context) {
    final trip = ref.watch(tripProvider);
    

    // Move ref.listen into the build method
    ref.listen<TripState>(tripProvider, (previous, next) {
      if (previous?.daySelected != next.daySelected && next.daySelected != null) {
        // Update both displayDate and selectedDate
        _controller.displayDate = next.daySelected;
        _controller.selectedDate = next.daySelected;
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/iniciarsesion.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: const Color.fromARGB(255, 2, 15, 21).withOpacity(0.7),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ref.watch(tripProvider.notifier).getDayWidgets(),
                  ),
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SfCalendar(
                      controller: _controller,
                      view: CalendarView.day,
                      onViewChanged: (viewChangedDetails) {
                        // Schedule the state change after the build phase
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ref.read(tripProvider.notifier).selectDay(viewChangedDetails.visibleDates[0].toLocal());
                        });
                      },
                              
                      backgroundColor: Colors.transparent,
                      cellBorderColor: Colors.transparent,
                      todayHighlightColor: Colors.transparent,
                      selectionDecoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      viewHeaderHeight: 0,                    
                      headerHeight: 0,
                    
                      timeSlotViewSettings: TimeSlotViewSettings(
                        timeIntervalHeight: 50,
                        timeInterval: const Duration(hours: 1),
                        timeRulerSize: MediaQuery.of(context).size.width * 0.15,
                        timeTextStyle: const TextStyle(
                          color: Colors.white,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          context.push('/calendar_screen');   
        }, 
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.calendar_today),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),

    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
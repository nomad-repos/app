import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_app/features/trips/presentation/presentation.dart';
import 'package:nomad_app/shared/models/appointment.dart';
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
                      dataSource: GetEventDataSource(ref.watch(tripProvider).events),
                      onViewChanged: (viewChangedDetails) {
                        // Schedule the state change after the build phase
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ref.read(tripProvider.notifier).selectDay(viewChangedDetails.visibleDates[0].toLocal());
                        });
                      },

                      onTap: (calendarTapDetails) {
                        final appointment = calendarTapDetails.appointments!.first as GetEvent;
                        context.push('/map_activity_screen', extra: appointment);
                      },

                     appointmentBuilder: (context, calendarAppointmentDetails) {
                      final appointment = calendarAppointmentDetails.appointments.first as GetEvent;
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            Expanded( // Ajustamos la columna con un Expanded
                              flex: 1,
                              child: Column(                                
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(child: Container()),
                                  Text(
                                    appointment.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis, // Evitar desbordamientos
                                  ),
                                  Text(
                                    '${appointment.startTime} - ${appointment.finishTime}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                ],
                              ),
                            ),
                            Expanded( // Ajustamos el texto de la descripción con un Expanded
                              flex: 1,
                              child: Center(
                                child: Text(
                                  appointment.eventDescription,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    overflow: TextOverflow.ellipsis, // Acortamos si se desborda
                                  ),
                                  maxLines: 2, // Limitar a una línea para evitar desbordes
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
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
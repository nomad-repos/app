import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_app/features/trips/trip.dart';
import 'dart:io';
import 'package:nomad_app/shared/shared.dart';
import 'package:nomad_app/shared/widgets/trip/day_widget.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../helpers/services/services.dart';

final tripProvider = StateNotifierProvider<TripNotifier, TripState>((ref) {
  final keyValueStorage = KeyValueStorageImpl();
  final tripRepository = TripRepositoryImpl();

  return TripNotifier(
    keyValueStorage: keyValueStorage,
    tripRepository: tripRepository,
  );
});

class TripNotifier extends StateNotifier<TripState> {
  final KeyValueStorageServices keyValueStorage;
  final TripRepository tripRepository;

  TripNotifier({
    required this.keyValueStorage,
    required this.tripRepository,
  }) : super(TripState()) {
    getCategories();
  }

  Future<void> setTrip(Trip trip) async {
    final DateTime tripStartDate = HttpDate.parse(trip.tripStartDate);
    final DateTime tripEndDate = HttpDate.parse(trip.tripFinishDate);

    final daysFromStart = tripStartDate.difference(DateTime.now()).inDays;
    final daysFromEnd = tripEndDate.difference(DateTime.now()).inDays;

    final String text = daysFromStart > 0
        ? 'Faltan $daysFromStart días'
        : daysFromEnd > 0
            ? 'Estas en tu viaje'
            : 'Tu viaje terminó';

    final List<Location>? locations = await getLocations(trip.tripId);

    trip.tripLocations = locations;

    state = state.copyWith(
      trip: trip,
      dayRemaining: text,
    );
  }
  
  List<Widget> getDayWidgets() {
    final trip = state.trip;
    if (trip == null) return [];

    final DateTime tripStartDate = HttpDate.parse(trip.tripStartDate);
    final DateTime tripEndDate = HttpDate.parse(trip.tripFinishDate);

    final List<Widget> days = [];
    for (int i = 0; i < tripEndDate.difference(tripStartDate).inDays; i++) {
      days.add(
        DayWidget(day: tripStartDate.add(Duration(days: i))),
      );
    }
    return days;
  }

  void selectDay(DateTime day) {
    state = state.copyWith(
      daySelected: day,
    );
  }

  Future<List<Location>?> getLocations(int tripId) async {
    List<Location>? locations;

    try {
      final token = await keyValueStorage.getValue<String>('token');

      final resp = await tripRepository.getLocations(tripId,
          token!); // Si o si hay un token porque si no hay token no se puede acceder a esta pantalla.

      if (resp.statusCode == 200) {
        // Mapeo de la lista de países desde el JSON a objetos Country
        locations = (resp.data['locations'] as List)
            .map((location) => Location.fromJson(location))
            .toList();
      }
    } catch (e) {
      //TODO: Manejar los errores
    }

    return locations;
  }

  Future<List<Category>?> getCategories() async {
    List<Category>? categories;
    try {
      final token = await keyValueStorage.getValue<String>('token');

      final resp = await tripRepository.getCategories(token!);

      if (resp.statusCode == 200) {
        categories = (resp.data['categories'] as List).map((category) {
          return Category.fromJson(category);
        }).toList();

        state = state.copyWith(categories: categories);
      }
    } catch (e) {
      //TODO: Manejar los errores
    }
    return categories;
  }

  Future<List<GetEvent>?> getEvents() async {
    List<GetEvent>? events;
    try {
      final token = await keyValueStorage.getValue<String>('token');

      final resp = await tripRepository.getAllEvent(state.trip!.tripId, token!);

      events = (resp.data['events'] as List).map((event) {
        return GetEvent.fromJson(event);
      }).toList();

      state = state.copyWith(events: events);
    } catch (e) {
      //TODO: Manejar los errores
    }
    return events;
  }

  List<Appointment> getAppointments(List<GetEvent> events) {
    return events.map((event) {
      return Appointment(
        startTime: DateTime.parse(event.date +
            ' ' +
            event.startTime), // Combinamos la fecha y la hora de inicio
        endTime: DateTime.parse(event.date +
            ' ' +
            event.finishTime), // Combinamos la fecha y la hora de finalización
        subject: event.title,
        notes: event.eventDescription,
        id: event.eventId,
      );
    }).toList();
  }

  void selectCategory(String categoryName) {
    state = state.copyWith(selectedCategory: categoryName);
  }
}

class TripState {
  final bool isPosting;

  final Trip? trip;
  final String dayRemaining;
  final DateTime? daySelected;

  final List<Category> categories;
  final String selectedCategory;

  final List<GetEvent> events;

  TripState({
    this.isPosting = false,
    this.trip,
    this.dayRemaining = '',
    this.daySelected,
    this.selectedCategory = '',
    this.categories = const [],
    this.events = const [],
  });

  TripState copyWith({
    bool? isPosting,
    Trip? trip,
    String? dayRemaining,
    DateTime? daySelected,
    List<Category>? categories,
    String? selectedCategory,
    List<GetEvent>? events,
  }) =>
      TripState(
        isPosting: isPosting ?? this.isPosting,
        trip: trip ?? this.trip,
        dayRemaining: dayRemaining ?? this.dayRemaining,
        daySelected: daySelected ?? this.daySelected,
        categories: categories ?? this.categories,
        selectedCategory: selectedCategory ?? this.selectedCategory,
        events: events ?? this.events,
      );
}

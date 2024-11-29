
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nomad_app/features/trips/trip.dart';
import 'package:nomad_app/helpers/helpers.dart';
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
    final DateTime tripStartDate = DateTime.parse(trip.tripStartDate);
    final DateTime tripEndDate = DateTime.parse(trip.tripFinishDate);

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

    await getEvents();
  }

  List<Widget> getDayWidgets() {
    final trip = state.trip;
    if (trip == null) return [];

    final DateTime tripStartDate = DateTime.parse(trip.tripStartDate);
    final DateTime tripEndDate = DateTime.parse(trip.tripFinishDate);

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
        locations = (resp.data['localities'] as List)
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

      print(resp.data); 

      if (resp.statusCode == 200) {
        categories = (resp.data['categories'] as List).map((category) {
          return Category.fromJson(category);
        }).toList();

        state = state.copyWith(categories: categories);

        print(categories);
      }
    } catch (e) {
      //TODO: Manejar los errores
    }
    return categories;
  }

  Future<List<Event>?> getEvents() async {
    List<Event>? events;
    try {
      state = state.copyWith(isPosting: true);
      final token = await keyValueStorage.getValue<String>('token');

      final resp = await tripRepository.getAllEvent(state.trip!.tripId, token!);

      events = (resp.data['events'] as List).map((event) {
        return Event.fromJson(event);
      }).toList();


      for (Event event in events) {
        // Obtener la fecha del evento
        DateTime eventDate = event.eventDate; // Suponiendo que `date` es de tipo DateTime
        
        // Extraer las horas y minutos (suponiendo que están en formato "HH:mm")
        List<String> startTimeParts = event.eventStartTime.split(':');
        List<String> finishTimeParts = event.eventFinishTime.split(':');

        // Crear el DateTime para el inicio y el fin
        DateTime parsedStartTime = DateTime(
          eventDate.year,
          eventDate.month,
          eventDate.day,
          int.parse(startTimeParts[0]), // Hora de inicio
          int.parse(startTimeParts[1]), // Minuto de inicio
        );

        DateTime parsedFinishTime = DateTime(
          eventDate.year,
          eventDate.month,
          eventDate.day,
          int.parse(finishTimeParts[0]), // Hora de fin
          int.parse(finishTimeParts[1]), // Minuto de fin
        );

        // Asignar los valores de tiempo procesado a las propiedades del evento
        event.setParsedStartTime = parsedStartTime; // o usa el formato que necesites
        event.setParsedFinishTime = parsedFinishTime; // o usa el formato que necesites
      }
      state = state.copyWith(events: events);
      
      createMarkers();
    } catch (e) {
      print(e.toString());
    } finally {
      state = state.copyWith(isPosting: false);
    } 
    return events;
  }

  List<Appointment> getAppointments(List<GetEvent> events) {
    return events.map((event) {
      return Appointment(
        startTime: DateTime.parse('${event.date} ${event.startTime}'), // Combinamos la fecha y la hora de inicio
        endTime: DateTime.parse('${event.date} ${event.finishTime}'), // Combinamos la fecha y la hora de finalización
        subject: event.title,
        notes: event.eventDescription,
        id: event.eventId,
      );
    }).toList();
  }

  void selectCategory(String categoryName) {
    state = state.copyWith(selectedCategory: categoryName);
  }

  void createMarkers() {
    final List<Event> events = state.events;
    final Set<Marker> markers = {};

    for (Event event in events) {
      markers.add(
        Marker(
          markerId: MarkerId(event.eventId.toString()),
          position: LatLng(event.activity!.activityLatitude, event.activity!.activityLongitude),
          infoWindow: InfoWindow(
            title: event.activity!.activityName,
            snippet: "${event.eventDate.toString().split(' ')[0]}, ${event.eventStartTime} - ${event.eventFinishTime}",
          ),
        ),
      );
    }

    print(markers.length); 

    state = state.copyWith(markers: markers);

  }

  void deleteEvent(int eventId, BuildContext context) async {
    state = state.copyWith(isPosting: true);
    try {
      final token = await keyValueStorage.getValue<String>('token');

      await tripRepository.deleteEvent(eventId, token!);

      await getEvents();

      context.pop();
    
    } catch (e) {
      print(e.toString());
    } finally {
      state = state.copyWith(isPosting: false);
    } 
  }
}

class TripState {
  final bool isPosting;

  final Trip? trip;
  final String dayRemaining;
  final DateTime? daySelected;

  final List<Category> categories;
  final String selectedCategory;

  final List<Event> events;

  final Set<Marker> markers;

  TripState({
    this.isPosting = false,
    this.trip,
    this.dayRemaining = '',
    this.daySelected,
    this.selectedCategory = '',
    this.categories = const [],
    this.events = const [],

    this.markers = const {},

  });

  TripState copyWith({
    bool? isPosting,
    Trip? trip,
    String? dayRemaining,
    DateTime? daySelected,
    List<Category>? categories,
    String? selectedCategory,
    List<Event>? events,

    Set<Marker>? markers,
  }) =>
      TripState(
        isPosting: isPosting ?? this.isPosting,
        trip: trip ?? this.trip,
        dayRemaining: dayRemaining ?? this.dayRemaining,
        daySelected: daySelected ?? this.daySelected,
        categories: categories ?? this.categories,
        selectedCategory: selectedCategory ?? this.selectedCategory,
        events: events ?? this.events,

        markers: markers ?? this.markers,
      );
}

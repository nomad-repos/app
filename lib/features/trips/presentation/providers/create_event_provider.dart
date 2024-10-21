import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_app/features/trips/trip.dart';

import 'package:nomad_app/helpers/helpers.dart';
import 'package:nomad_app/shared/shared.dart';

final createEventProvider = StateNotifierProvider<CreateEventNotifier,CreateEventState>((ref) {
  final keyValueStorage = KeyValueStorageImpl();
  final tripRepository = TripRepositoryImpl();
  
  final tripNotifier = ref.watch(tripProvider.notifier); 
  final errorProvider = ref.watch(errorTripProvider.notifier);

  return CreateEventNotifier(
    keyValueStorage: keyValueStorage,
    tripRepository: tripRepository,

    tripNotifier: tripNotifier,
    errorProvider: errorProvider, 
  );
});


class CreateEventNotifier extends StateNotifier<CreateEventState> {
  final KeyValueStorageServices keyValueStorage;
  final TripRepository tripRepository;

  final TripNotifier tripNotifier;
  final ErrorTripNotifer errorProvider;

  CreateEventNotifier({ 
    required this.keyValueStorage,
    required this.tripRepository,

    required this.tripNotifier,
    required this.errorProvider,
  }): super( CreateEventState());

  void loadEventForEdit( GetEvent getEvent ) {
    // Inicializar el estado con los valores del evento
    state = state.copyWith(
      name: getEvent.title,
      description: getEvent.eventDescription,
      date: DateTime.parse(getEvent.date),
      startTime: parseTimeOfDay(getEvent.startTime),
      endTime: parseTimeOfDay(getEvent.finishTime),
    );
  }

  TimeOfDay parseTimeOfDay(String timeString) {
    // Dividir el string en partes separadas por ':'
    List<String> parts = timeString.split(':');
    
    // Verificar que al menos haya horas y minutos
    if (parts.length >= 2) {
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      // Validar que las horas y minutos estén dentro del rango válido
      if (hour >= 0 && hour <= 23 && minute >= 0 && minute <= 59) {
        return TimeOfDay(hour: hour, minute: minute);
      } else {
        throw const FormatException('Hora o minuto fuera de rango');
      }
    } else {
      throw const FormatException('Formato de tiempo incorrecto');
    }
  }

  
  void onNameChanged(String name) {state = state.copyWith(name: name);}
  void onDescriptionChanged(String description) {state = state.copyWith(description: description);}
  void onDateChanged(DateTime date) {state = state.copyWith(date: date);}
  void onStartTimeChanged(TimeOfDay? startTime) {state = state.copyWith(startTime: startTime);}
  void onEndTimeChanged(TimeOfDay? endTime) {state = state.copyWith(endTime: endTime);}

  void onEditChange( GetEvent getEvent, BuildContext context) async {
    loadEventForEdit( getEvent );
    state = state.copyWith(
      isEditing: true,
      getEvent: getEvent,
    );
    context.push('/create_event_screen');
  }

  void onCreateChange(){
    state = state.copyWith(
      isEditing: false,
      name: '',
      description: '',
      startTime: null, 
      endTime: null,
    );
  }

  void validateForm() {
    final isValid = state.name.isNotEmpty && state.description.isNotEmpty && state.date != null && state.startTime != null && state.endTime != null;
    state = state.copyWith(isValid: isValid);
  }

  Event createObjectEvent() {
    final event = Event(
      eventTitle: state.name, 
      eventDescription: state.description,
      eventDate: state.date!, 
      eventStartTime: DateTime(state.date!.year, state.date!.month, state.date!.day, state.startTime!.hour, state.startTime!.minute),
      eventFinishTime: DateTime(state.date!.year, state.date!.month, state.date!.day, state.endTime!.hour, state.endTime!.minute),
      tripId: tripNotifier.state.trip!.tripId,
    );
    return event;
  }

  void createEvent( BuildContext context ) async {
    validateForm();
    if (!state.isValid){
      errorProvider.setError(ErrorTripStatus.errorInvalidForm, null);
      return;
    }
    
    state = state.copyWith(isPosting: true);

    try {
      
      final token = await keyValueStorage.getValue<String>('token');
      final event = createObjectEvent();
      final activity = state.activity!; 
      final int locationId = tripNotifier.state.trip!.tripId;
 
      await tripRepository.createEvent(event, activity, token!, locationId);
      await tripNotifier.getEvents();
      context.push('/home_trip_screen');


    } catch (e) {
      errorProvider.setError(ErrorTripStatus.errorCreatingEvent, null);
    } finally {
      state = state.copyWith(isPosting: false);
    }
  }

  void updateEvent( BuildContext context ) async {
    validateForm();
    if (!state.isValid){
      errorProvider.setError(ErrorTripStatus.errorInvalidForm, null);
      return;
    }
    
    state = state.copyWith(isPosting: true);

    try {
      final token = await keyValueStorage.getValue<String>('token');

      // Terminar esta funcion.
      await tripRepository.updateEvent();
      await tripNotifier.getEvents();
      context.push('/home_trip_screen');


    } catch (e) {
      errorProvider.setError(ErrorTripStatus.errorCreatingEvent, null);
    } finally {
      state = state.copyWith(isPosting: false);
    }
  }

  void selectActivity(Activity activity) {
    state = state.copyWith(activity: activity);
  }
}

class CreateEventState {
  final bool isPosting;
  final bool isValid;
  final bool isEditing;

  final String name;
  final String description;
  final DateTime? date;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;

  final Event? event;
  final Activity? activity;
  final GetEvent? getEvent; 

  CreateEventState({
    this.isPosting = false,
    this.isValid = false,
    this.isEditing = false,

    this.name = '',
    this.description = '',
    this.date,
    this.startTime,
    this.endTime,

    this.event,
    this.activity,
    this.getEvent,
  });

  CreateEventState copyWith({
    bool? isPosting,
    bool? isValid,
    bool? isEditing,

    String? name,
    String? description,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,

    Event? event,
    Activity? activity,
    GetEvent? getEvent, 

  }) => CreateEventState(
    isPosting: isPosting ?? this.isPosting,
    isValid: isValid ?? this.isValid,
    isEditing: isEditing ?? this.isEditing,

    name: name ?? this.name,
    description: description ?? this.description,
    date: date ?? this.date,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,

    event: event ?? this.event,
    activity: activity ?? this.activity,
    getEvent: getEvent ?? this.getEvent,
  );
}
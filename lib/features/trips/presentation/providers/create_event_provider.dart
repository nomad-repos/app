import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nomad_app/helpers/helpers.dart';
import 'package:nomad_app/shared/shared.dart';

final createEventProvider = StateNotifierProvider<CreateEventNotifier,CreateEventState>((ref) {
  final keyValueStorage = KeyValueStorageImpl();
  final tripRepository = TripRepositoryImpl();
  final tripState = ref.watch(tripProvider); 

  return CreateEventNotifier(
    keyValueStorage: keyValueStorage,
    tripRepository: tripRepository,
    tripState: tripState,
  );
});


class CreateEventNotifier extends StateNotifier<CreateEventState> {
  final KeyValueStorageServices keyValueStorage;
  final TripRepository tripRepository;
  final TripState tripState;

  CreateEventNotifier({ 
    required this.keyValueStorage,
    required this.tripRepository,
    required this.tripState,
  }): super( CreateEventState());

  void loadEventForEdit() {
    // Inicializar el estado con los valores del evento
    state = state.copyWith(
      name: state.event!.eventTitle,
      description: '', // Aca debería haber un campo de descripción.
      date: state.event!.eventDate,
      startTime: TimeOfDay.fromDateTime(state.event!.eventStartTime),
      endTime: TimeOfDay.fromDateTime(state.event!.eventFinishTime),
    );
  }

  
  void onNameChanged(String name) {state = state.copyWith(name: name);}
  void onDescriptionChanged(String description) {state = state.copyWith(description: description);}
  void onDateChanged(DateTime date) {state = state.copyWith(date: date);}
  void onStartTimeChanged(TimeOfDay? startTime) {state = state.copyWith(startTime: startTime);}
  void onEndTimeChanged(TimeOfDay? endTime) {state = state.copyWith(endTime: endTime);}

  void validateForm() {
    final isValid = state.name.isNotEmpty && state.description.isNotEmpty && state.date != null && state.startTime != null && state.endTime != null;
    print(state.name);
    print(state.description);
    print(state.date);
    print(state.startTime);
    print(state.endTime);
    state = state.copyWith(isValid: isValid);
  }

  Event createObjectEvent() {
    final event = Event(
      eventTitle: state.name, 
      eventDate: state.date!, 
      eventStartTime: DateTime(state.date!.year, state.date!.month, state.date!.day, state.startTime!.hour, state.startTime!.minute),
      eventFinishTime: DateTime(state.date!.year, state.date!.month, state.date!.day, state.endTime!.hour, state.endTime!.minute),
      tripId: tripState.trip!.tripId,
    );
    return event;
  }

  void createEvent( BuildContext context ) async {
    validateForm();
    if (!state.isValid){
      showSnackbar(context, 'Todos los campos son requeridos', Colors.red);
      return;
    };
    
    state = state.copyWith(isPosting: true);

    try {
      final token = await keyValueStorage.getValue<String>('token');
      final event = createObjectEvent();
      
            // Guardar el evento (ya sea crear o actualizar)
      if (state.isEditing) {
        // Actualizar evento
      } else {
        //await tripRepository.createEvent(event, activity, token!);
      }
      

    } catch (e) {
      showSnackbar(context, 'Error al crear el evento', Colors.red);
    }
  }

  String getMonthName(int month) {
    switch (month) {
      case 1: return 'Enero';
      case 2: return 'Febrero';
      case 3: return 'Marzo';
      case 4: return 'Abril';
      case 5: return 'Mayo';
      case 6: return 'Junio';
      case 7: return 'Julio';
      case 8: return 'Agosto';
      case 9: return 'Septiembre';
      case 10: return 'Octubre';
      case 11: return 'Noviembre';
      case 12: return 'Diciembre';
      default: return '';
    }
  }

  String getFormattedDate() {
    if (state.date == null) return '';
    switch (state.date!.weekday) {
      case 1: return 'Lunes, ${state.date!.day} de ${getMonthName(state.date!.month)}';
      case 2: return 'Martes, ${state.date!.day} de ${getMonthName(state.date!.month)}';
      case 3: return 'Miércoles, ${state.date!.day} de ${getMonthName(state.date!.month)}';
      case 4: return 'Jueves, ${state.date!.day} de ${getMonthName(state.date!.month)}';
      case 5: return 'Viernes, ${state.date!.day} de ${getMonthName(state.date!.month)}';
      case 6: return 'Sábado, ${state.date!.day} de ${getMonthName(state.date!.month)}';
      case 7: return 'Domingo, ${state.date!.day} de ${getMonthName(state.date!.month)}';
      default: return '';
    }
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
  );
}
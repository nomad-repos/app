import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:nomad_app/shared/shared.dart';
import 'package:nomad_app/shared/widgets/trip/day_widget.dart';

final tripProvider = StateNotifierProvider<TripNotifier,TripState>((ref) {

  final userNotifier = ref.watch(userProvider.notifier); 

  return TripNotifier(
    userNotifier: userNotifier,
  );
});


class TripNotifier extends StateNotifier<TripState> {
  final UserNotifier userNotifier;

  TripNotifier({ 
    required this.userNotifier,
  }): super( TripState());

  setTrip(Trip trip) {
    final DateTime tripStartDate = HttpDate.parse(trip.tripStartDate);
    final DateTime tripEndDate =  HttpDate.parse(trip.tripFinishDate);
    
    final daysFromStart = tripStartDate.difference(DateTime.now()).inDays;
    final daysFromEnd = tripEndDate.difference(DateTime.now()).inDays;

    final String text = daysFromStart > 0 
      ? daysFromEnd > 0 
        ? 'Faltan $daysFromStart días'
        : 'Estas en tu viaje' 
      : 'Tu viaje terminó';

    state = state.copyWith(
      trip: trip,
      dayRemaining: text,
    );
  }

  List<Widget> getDayWidgets() {
    final trip = state.trip;
    if (trip == null) return [];

    final DateTime tripStartDate = HttpDate.parse(trip.tripStartDate);
    final DateTime tripEndDate =  HttpDate.parse(trip.tripFinishDate);

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
    print(state.daySelected);
  }

}

class TripState {
  final Trip? trip;
  final String dayRemaining;
  final DateTime? daySelected;  

  final List<String> categories;
  final String selectedCategory;


  TripState({
    this.trip,
    this.dayRemaining = '',
    this.daySelected,

    this.categories = const ["Restoran", "Transporte", "Shopping","Café", "Actividad"],
    this.selectedCategory = "",
  });

  TripState copyWith({
    Trip? trip,
    String? dayRemaining, 
    DateTime? daySelected,

    List<String>? categories,
    String? selectedCategory,

  }) => TripState(
    trip: trip ?? this.trip,
    dayRemaining: dayRemaining ?? this.dayRemaining,
    daySelected: daySelected ?? this.daySelected,

    categories: categories ?? this.categories,
    selectedCategory: selectedCategory ?? this.selectedCategory,
  );
}
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:nomad_app/shared/shared.dart';

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

}

class TripState {
  final Trip? trip;
  final String dayRemaining;

  TripState({
    this.trip,
    this.dayRemaining = '',
  });

  TripState copyWith({
    Trip? trip,
    String? dayRemaining, 
  }) => TripState(
    trip: trip ?? trip,
    dayRemaining: dayRemaining ?? this.dayRemaining,
  );
}
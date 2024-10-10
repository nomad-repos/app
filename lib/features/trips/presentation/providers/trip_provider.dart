import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_app/features/trips/trip.dart';
import 'dart:io';
import 'package:nomad_app/shared/shared.dart';

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
        ? daysFromEnd > 0
            ? 'Faltan $daysFromStart días'
            : 'Estas en tu viaje'
        : 'Tu viaje terminó';

    final List<Location>? locations = await getLocations(trip.tripId);

    trip.tripLocations = locations;

    state = state.copyWith(
      trip: trip,
      dayRemaining: text,
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

      final resp = await tripRepository.getCategories(
          token!); // Si o si hay un token porque si no hay token no se puede acceder a esta pantalla.

      if (resp.statusCode == 200) {

        // Mapeo de la lista de países desde el JSON a objetos Country
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

  void selectCategory(String categoryName) {
    state = state.copyWith(selectedCategory: categoryName);
    print('Selected Category: $categoryName');
  }
}

class TripState {
  final Trip? trip;
  final String dayRemaining;
  final String selectedCategory;
  final List<Category> categories;

  TripState({
    this.trip,
    this.dayRemaining = '',
    this.selectedCategory = '',
    this.categories = const [],
  });

  TripState copyWith({
    Trip? trip,
    String? dayRemaining,
    String? selectedCategory,
    List<Category>? categories,
  }) =>
      TripState(
        trip: trip ?? trip,
        dayRemaining: dayRemaining ?? this.dayRemaining,
        selectedCategory: selectedCategory ?? this.selectedCategory,
        categories: categories ?? this.categories,
      );
}

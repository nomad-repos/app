import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../helpers/helpers.dart';
import '../../../../shared/models/models.dart';
import '../../domain/domain.dart';
import '../../infrastructure/infrastructure.dart';

final findActivityProvider =
    StateNotifierProvider<FindActivityNotifier, FindActivityState>((ref) {
  final keyValueStorage = KeyValueStorageImpl();
  final tripRepository = TripRepositoryImpl();

  return FindActivityNotifier(
    keyValueStorage: keyValueStorage,
    tripRepository: tripRepository,
  );
});

class FindActivityNotifier extends StateNotifier<FindActivityState> {
  final KeyValueStorageServices keyValueStorage;
  final TripRepository tripRepository;

  FindActivityNotifier({
    required this.keyValueStorage,
    required this.tripRepository,
  }) : super(FindActivityState());

  // Actualizar la categoría seleccionada
  void setCategory(Category? category) {
    if (category == null) return;

    state = state.copyWith(
      selectedCategory: category,
    );
  }

  void onCategoryHomeChange(Category? category) {
    state = state.copyWith(
      categoryHome: category,
      selectedCategory: category,
    );
  }

  void setLocation(Location? location) {
    if (location == null) return;

    state = state.copyWith(
      selectedLocation: location,
    );
  }

  Future<List<Activity>?> getActivities(String location, int categoryId) async {
    List<Activity>? activities;
    try {
      final token = await keyValueStorage.getValue<String>('token');

      final resp = await tripRepository.getActivites(token!, location,
          categoryId); // Si o si hay un token porque si no hay token no se puede acceder a esta pantalla.

      if (resp.statusCode == 200) {
        // Mapeo de la lista de países desde el JSON a objetos Country
        activities = (resp.data['activities'] as List).map((activities) {
          return Activity.fromJson(activities);
        }).toList();

        state = state.copyWith(activities: activities);
      }
    } catch (e) {
      resetActivityList();
      //TODO: Manejar los errores
    }
    print(state.activities);
    return activities;
  }

  void selectCategory(Category category) {
    state = state.copyWith(selectedCategory: category);
    print('Selected Category: ${category.catergoryName}');
  }

  void resetActivityList() {
    state = state.copyWith(activities: []);
  }
}

class FindActivityState {
  final Category? categoryHome;

  final Category? selectedCategory;
  final Location? selectedLocation;
  final List<Activity>? activities;

  FindActivityState({
    this.categoryHome,
    this.selectedCategory,
    this.selectedLocation,
    this.activities = const [],
  });

  FindActivityState copyWith({
    Category? categoryHome,
    Category? selectedCategory,
    Location? selectedLocation,
    List<Activity>? activities,
  }) =>
      FindActivityState(
        categoryHome: categoryHome ?? this.categoryHome,
        selectedCategory: selectedCategory ?? this.selectedCategory,
        selectedLocation: selectedLocation ?? this.selectedLocation,
        activities: activities ?? this.activities,
      );
}

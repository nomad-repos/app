import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_app/features/trips/trip.dart';

import '../../../../helpers/helpers.dart';
import '../../../../shared/models/models.dart';

final findActivityProvider =
    StateNotifierProvider<FindActivityNotifier, FindActivityState>((ref) {
  final keyValueStorage = KeyValueStorageImpl();
  final tripRepository = TripRepositoryImpl();
  final createEventNotifier = ref.watch(createEventProvider.notifier);

  return FindActivityNotifier(
    keyValueStorage: keyValueStorage,
    tripRepository: tripRepository,
    createEventNotifier: createEventNotifier,
  );
});

class FindActivityNotifier extends StateNotifier<FindActivityState> {
  final KeyValueStorageServices keyValueStorage;
  final TripRepository tripRepository;
  final CreateEventNotifier createEventNotifier;

  FindActivityNotifier({
    required this.keyValueStorage,
    required this.tripRepository,
    required this.createEventNotifier,
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

  Future<List<GoogleActivity>?> getActivities(BuildContext context) async {
    state = state.copyWith(isPosting: true);
    
    validateFields();
    
    if (!state.isValid){
      showSnackbar(context,"Debes completar todos los campos", Colors.red);
      state = state.copyWith(isPosting: false);
      return null;
    }

    List<GoogleActivity>? activities;
    try {
      final token = await keyValueStorage.getValue<String>('token');
      final String location = '${state.selectedLocation!.latitude},${state.selectedLocation!.longitude}';
      final int categoryId = state.selectedCategory!.categoryId;

      final resp = await tripRepository.getActivites(token!, location, categoryId); 

      if (resp.statusCode == 200) {
        activities = (resp.data['activities'] as List).map((activities) {
          return GoogleActivity.fromJson(activities);
        }).toList();

        state = state.copyWith(activities: activities);
      }
    } catch (e) {
      resetActivityList();
    } finally {
      state = state.copyWith(isPosting: false);
    } 
    return activities;
  }

  void selectCategory(Category category) {
    state = state.copyWith(selectedCategory: category);
  }

  void resetActivityList() {
    state = state.copyWith(activities: []);
  }
  
  void validateFields() {
    final isValid = state.selectedCategory != null && state.selectedLocation != null;
    state = state.copyWith(isValid: isValid);
  }
}

class FindActivityState {
  final bool isValid;
  final bool isPosting;

  final Category? categoryHome;

  final Category? selectedCategory;
  final Location? selectedLocation;
  final List<GoogleActivity>? activities;

  FindActivityState({
    this.isValid = false,
    this.isPosting = false,

    this.categoryHome,
    this.selectedCategory,
    this.selectedLocation,
    this.activities = const [],
  });

  FindActivityState copyWith({
    bool? isValid,
    bool? isPosting,

    Category? categoryHome,
    Category? selectedCategory,
    Location? selectedLocation,
    List<GoogleActivity>? activities,
  }) =>
      FindActivityState(
        isValid: isValid ?? this.isValid,
        isPosting: isPosting ?? this.isPosting,

        categoryHome: categoryHome ?? this.categoryHome,
        selectedCategory: selectedCategory ?? this.selectedCategory,
        selectedLocation: selectedLocation ?? this.selectedLocation,
        activities: activities ?? this.activities,
      );
}

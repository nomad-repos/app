import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nomad_app/features/home/home.dart';
import 'package:nomad_app/helpers/helpers.dart';
import 'package:nomad_app/shared/shared.dart';
import 'package:nomad_app/shared/utils/utils.dart';

final planTripFormProvider =
    StateNotifierProvider<PlanTripNotifier, PlanTripState>((ref) {
  
  final keyValueStorage = KeyValueStorageImpl();
  final planTripRepository = PlanTripRepositoryImpl();
  
  final userState = ref.watch(userProvider);
  final errorHomeNotifier = ref.watch(errorHomeProvider.notifier); 
  final homeNotifier = ref.watch(homeProvider.notifier);

  return PlanTripNotifier(
    keyValueStorage: keyValueStorage,
    planTripRepository: planTripRepository,

    userState: userState,
    errorHomeNotifier : errorHomeNotifier,
    homeNotifer : homeNotifier,
  );
});

class PlanTripNotifier extends StateNotifier<PlanTripState> {

  final PlanTripRepository planTripRepository;
  final KeyValueStorageServices keyValueStorage;

  final UserState userState;
  final ErrorHomeNotifer errorHomeNotifier;
  final HomeNotifier homeNotifer;

  PlanTripNotifier({
    required this.planTripRepository,
    required this.keyValueStorage,

    required this.userState,
    required this.errorHomeNotifier,
    required this.homeNotifer,
  }) : super(PlanTripState()) {
    getCountries();
  }

  Future<void> getCountries() async {
    try {
      final token = await keyValueStorage.getValue<String>('token');

      // Asumes que siempre hay token, porque si no hay no se accede a esta pantalla.
      final resp = await planTripRepository.getCountries(token!);

      if (resp.statusCode == 200) {
        // Mapeo de la lista de países desde el JSON a objetos Country
        final List<Country> countries = (resp.data['countries'] as List)
            .map((country) => Country.fromJson(country))
            .toList();

        // Actualizar el estado con los países obtenidos
        state = state.copyWith(
          countries: countries,
        );
      }
    } catch (e) {
      
    }
  }

  Future<void> getCities(String isoCode) async {
    try {
      final token = await keyValueStorage.getValue<String>('token');

      // Asumes que siempre hay token, porque si no hay no se accede a esta pantalla.
      final resp = await planTripRepository.getCities(isoCode, token!);

      print(resp.data);

      if (resp.statusCode == 200) {
        // Mapeo de la lista de países desde el JSON a objetos Country
        final List<Location> locations = (resp.data['localities'] as List)
            .map((location) => Location.fromJson(location))
            .toList();

        // Actualizar el estado con los países obtenidos
        state = state.copyWith(
          locations: locations,
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> selectCountry(Country country) async {
    try {
      state = state.copyWith(
        selectedLocation: null,
        selectedCountry: country,
      );

      await getCities(country.isoCode);
    } catch (e) {
      //TODO: Manejar los errores
    }
  }

  void selectLocation(Location location) {
    state = state.copyWith(
      selectedLocation: location,
    );
  }

  bool locationInLocations() {
    return state.locations.contains(state.selectedLocation);
  }

  onNameChange(String value) {
    state = state.copyWith(
      name: value,
    );
  }

  void onValueChange(String key, dynamic value) {
    final updates = {
      'name': () => state = state.copyWith(name: value),
      'initDate': () => state = state.copyWith(initDate: value),
      'endDate': () => state = state.copyWith(endDate: value),
      'isAlone': () => state = state.copyWith(isAlone: value),
    };
    updates[key]
        ?.call(); // Si la clave existe, se llama la función correspondiente.
  }

  onLocationsChange(Location? location, String operation) {
    if (operation == 'add') {
      if (!state.selectedLocations.contains(state.selectedLocation)) {
        state = state.copyWith(selectedLocations: [
          ...state.selectedLocations,
          state.selectedLocation!
        ]);
      }
    } else {
      state = state.copyWith(
          selectedLocations: state.selectedLocations
              .where((loc) => loc != state.selectedLocation)
              .toList());
    }
  }

  bool isFormValid() {
    return state.name.isNotEmpty &&
        state.initDate.isNotEmpty &&
        state.endDate.isNotEmpty &&
        state.selectedLocations.isNotEmpty;
  }


  Future<bool> createTrip() async {
    if (!isFormValid()) {
      state = state.copyWith(isPosting: false);
      errorHomeNotifier.setError(ErrorHomeStatus.generalError, 'Por favor, completa todos los campos');
      return false;
    } else if (DateTime.parse(formatDate(state.initDate)).isAfter(DateTime.parse(formatDate(state.endDate)))) {
      state = state.copyWith(isPosting: false);
      errorHomeNotifier.setError(ErrorHomeStatus.datesError, null);
      return false;
    }

    state = state.copyWith(isPosting: true);

    try {
      final token = await keyValueStorage.getValue<String>('token'); // Delete
      final userId = userState.user!.userId;

      final locations = state.selectedLocations
          .map((location) => {
                "country_iso_code": location.isoCode,
                "locality_id": location.localityId,
              })
          .toList();

      await planTripRepository.createTrip(token!, userId, state.name, formatDate(state.initDate), formatDate(state.endDate), locations);
      await homeNotifer.getTrips();

      return true;

    } catch (e) {
      errorHomeNotifier.setError(ErrorHomeStatus.generalError, e.toString());
      return false;
    } finally {
      state = state.copyWith(isPosting: false);
    }
  }
}

class PlanTripState {
  final bool isPosting;

  final String name;
  final String initDate;
  final String endDate;
  final bool isAlone;
  final Country? selectedCountry;
  final Location? selectedLocation;

  final List<Location> selectedLocations;

  final List<Country> countries;
  final List<Location> locations;

  PlanTripState({
    this.isPosting = false,
    this.name = '',
    this.initDate = '',
    this.endDate = '',
    this.isAlone = true,
    this.selectedCountry,
    this.selectedLocation,
    this.selectedLocations = const [],
    this.countries = const [],
    this.locations = const [],
  });

  PlanTripState copyWith({
    bool? isPosting,
    String? name,
    String? initDate,
    String? endDate,
    bool? isAlone,
    Country? selectedCountry,
    Location? selectedLocation,
    List<Location>? selectedLocations,
    List<Country>? countries,
    List<Location>? locations,
  }) =>
      PlanTripState(
        isPosting: isPosting ?? this.isPosting,
        name: name ?? this.name,
        initDate: initDate ?? this.initDate,
        endDate: endDate ?? this.endDate,
        isAlone: isAlone ?? this.isAlone,
        selectedCountry: selectedCountry ?? this.selectedCountry,
        selectedLocation: selectedLocation ?? this.selectedLocation,
        selectedLocations: selectedLocations ?? this.selectedLocations,
        countries: countries ?? this.countries,
        locations: locations ?? this.locations,
      );
}

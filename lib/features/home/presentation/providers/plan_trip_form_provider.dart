import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nomad_app/features/home/home.dart';
import 'package:nomad_app/helpers/helpers.dart';
import 'package:nomad_app/shared/shared.dart';

final planTripFormProvider =
    StateNotifierProvider<PlanTripNotifier, PlanTripState>((ref) {
  
  final keyValueStorage = KeyValueStorageImpl();
  final planTripRepository = PlanTripRepositoryImpl();
  
  final userState = ref.watch(userProvider);
  final errorHomeNotifier = ref.watch(errorHomeProvider.notifier); 

  return PlanTripNotifier(
    keyValueStorage: keyValueStorage,
    planTripRepository: planTripRepository,

    userState: userState,
    errorHomeNotifier : errorHomeNotifier,
  );
});

class PlanTripNotifier extends StateNotifier<PlanTripState> {

  final PlanTripRepository planTripRepository;
  final KeyValueStorageServices keyValueStorage;

  final UserState userState;
  final ErrorHomeNotifer errorHomeNotifier;

  PlanTripNotifier({
    required this.planTripRepository,
    required this.keyValueStorage,

    required this.userState,
    required this.errorHomeNotifier,
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
        final List<Country> countries = (resp.data as List)
            .map((country) => Country.fromJson(country))
            .toList();

        // Actualizar el estado con los países obtenidos
        state = state.copyWith(
          countries: countries,
        );
      }
    } catch (e) {
      //TODO: Manejar errores
    }
  }

  Future<void> getCities(String isoCode) async {
    try {
      final token = await keyValueStorage.getValue<String>('token');

      // Asumes que siempre hay token, porque si no hay no se accede a esta pantalla.
      final resp = await planTripRepository.getCities(isoCode, token!);

      if (resp.statusCode == 200) {
        // Mapeo de la lista de países desde el JSON a objetos Country
        final List<Location> locations = (resp.data as List)
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

  String formatDate(String date) {
    // Parsear la fecha desde el formato dd/MM/yyyy
    DateTime parsedDate = DateTime.parse(
        '${date.split('/')[2]}-${date.split('/')[1]}-${date.split('/')[0]}');
    
    // Convertir al formato yyyy-MM-dd
    String formattedDate = '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';
    
    return formattedDate;
  }


  Future<void> createTrip() async {
    if (!isFormValid()) {
      state = state.copyWith(isPosting: false);
      return;
    }

    state = state.copyWith(isPosting: true);

    try {
      final token = await keyValueStorage.getValue<String>('token'); // Delete
      final userId = userState.user!.userId;



      final locations = state.selectedLocations
          .map((location) => {
                "country_iso": location.isoCode,
                "location_id": location.localityId,
              })
          .toList();

      print(locations);

      final resp = await planTripRepository.createTrip(token!, userId, state.name, formatDate(state.initDate), formatDate(state.endDate), locations);
      
      print(resp.statusCode);
      print(resp);
      //Aca va la creación del viaje.

    } catch (e) {
      print(e);
      errorHomeNotifier.setError(ErrorHomeStatus.generalError, e.toString());
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

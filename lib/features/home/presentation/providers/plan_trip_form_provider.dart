
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nomad_app/features/home/home.dart';
import 'package:nomad_app/helpers/helpers.dart';
import 'package:nomad_app/shared/shared.dart';

final planTripFormProvider = StateNotifierProvider<PlanTripNotifier,PlanTripState>((ref) {

  final keyValueStorage = KeyValueStorageImpl();
  final planTripRepository = PlanTripRepositoryImpl();

  return PlanTripNotifier(
    keyValueStorage: keyValueStorage,
    planTripRepository: planTripRepository,
  );
});


class PlanTripNotifier extends StateNotifier<PlanTripState> {
  final PlanTripRepository planTripRepository;
  final KeyValueStorageServices keyValueStorage;

  PlanTripNotifier({ 
    required this.planTripRepository,
    required this.keyValueStorage,
  }): super( PlanTripState() ){
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

  Future<void> getCities( String isoCode ) async {
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

  Future<void> selectCountry( Country country ) async {
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

  void selectLocation( Location location ) {
    state = state.copyWith(
      selectedLocation: location,
    );
  }

  bool locationInLocations() {
    return state.locations.contains(state.selectedLocation);
  }


  onNameChange( String value ){
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
    updates[key]?.call();  // Si la clave existe, se llama la función correspondiente.
  }

  
  onLocationsChange(Location? location, String operation){
    if (operation == 'add') {
      if (!state.selectedLocations.contains(state.selectedLocation)) {
        state = state.copyWith(selectedLocations: [...state.selectedLocations, state.selectedLocation!]);
      }
    } else {
      state = state.copyWith(selectedLocations: state.selectedLocations.where((loc) => loc != state.selectedLocation).toList());
    }
  }

  bool isFormValid() {
    return state.name.isNotEmpty && state.initDate.isNotEmpty && state.endDate.isNotEmpty && state.selectedLocations.isNotEmpty;
  }


  Future<void> createTrip() async {
    //TODO: Implementar esta función

    /*
      Hay que validar el formulario (función de arriba)
      Si el formulario es válido, se crear el viaje
      Si no es válido, se muestra un mensaje de error

      Hay que hacer la funcion que va a recibir los parametros necesarios para crear el viaje (ver los contratos)
      en el PlanTripRepository y su implementacion en PlanTripRepositoryImpl y tambien en PlanTripDS y su implemtacion en PlanTripDSImpl

      La funcion en el provider del PlanTripRepository 

      Solo para aclarar, se manejan futures y asincornias porque se tiene que esperar la respuesta de la API 

      Suerte :)
    */
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
  }) => PlanTripState(
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

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nomad_app/features/home/home.dart';
import 'package:nomad_app/helpers/helpers.dart';
import 'package:nomad_app/shared/shared.dart';

final homeProvider = StateNotifierProvider<HomeNotifier,HomeState>((ref) {

  final keyValueStorage = KeyValueStorageImpl();
  final homeRepository = HomeRepositoryImpl();
  final userNotifier = ref.watch(userProvider.notifier); 

  return HomeNotifier(
    keyValueStorage: keyValueStorage,
    homeRepository: homeRepository,
    userNotifier: userNotifier,
  );
});


class HomeNotifier extends StateNotifier<HomeState> {
  final HomeRepository homeRepository;
  final KeyValueStorageServices keyValueStorage;
  final UserNotifier userNotifier;

  HomeNotifier({ 
    required this.homeRepository,
    required this.keyValueStorage,
    required this.userNotifier,
  }): super( HomeState() );


  Future<void> getTrips( String userId, String token ) async { 
    try {
      final token = await keyValueStorage.getValue<String>('token');
      
      final resp = await homeRepository.getTrips( userId, token! ); // Si o si hay un token porque si no hay token no se puede acceder a esta pantalla.

      if (resp.statusCode == 200) {
        // Mapeo de la lista de países desde el JSON a objetos Country
        final List<Trip> trips = (resp.data['trips'] as List)
            .map((trip) => Trip.fromJson(trip))
            .toList();

        // Actualizar el estado con los países obtenidos
        state = state.copyWith(
          trips: trips,
        ); 
      }
    } catch (e) {
      //TODO: Manejar los errores
    }
  }
}

class HomeState {
  final List<Trip> trips;

  HomeState({
    this.trips = const [],
  });

  HomeState copyWith({
    List<Trip>? trips,
  }) => HomeState(
    trips: trips ?? this.trips,
  );
}
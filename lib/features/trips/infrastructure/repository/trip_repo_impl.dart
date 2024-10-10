
import 'package:nomad_app/features/trips/trip.dart';

class TripRepositoryImpl implements TripRepository{

  final TripDs tripDs;

  TripRepositoryImpl({
    TripDs? tripDs 
  }) : tripDs = tripDs ?? TripDSimpl();
  
  @override
  Future getLocations(int tripId, String token) {
    return tripDs.getLocations(tripId, token);
  }
  
  @override
  Future getCategories(String token) {
    return tripDs.getCategories(token);
  }
  
  @override
  Future getActivites(String token, String localityLocation, int categoryId) {
    return tripDs.getActivites(token, localityLocation, categoryId);
  }
}

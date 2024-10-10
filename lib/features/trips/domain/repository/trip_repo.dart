import 'package:nomad_app/shared/models/models.dart';

abstract class TripRepository {
  Future getLocations( int tripId, String token );
  
  Future<void> createEvent( Event event, Activity activity, String token );
  Future<void> getEvent( int eventId, String token );
  Future<void> getAllEvent( int tripId, String token );

  Future getCategories(String token);
  Future getActivites(String token, String localityLocation, int categoryId);
}
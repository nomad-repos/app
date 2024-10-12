import 'package:nomad_app/shared/models/models.dart';

abstract class TripDs {
  Future getLocations(int tripId, String token);

  Future<void> createEvent( Event event, Activity activity, String token, int locationId );
  Future<void> getEvent( int eventId, String token );
  Future getAllEvent( int tripId, String token );

  Future getCategories(String token);
  Future getActivites(String token, String localityLocation, int categoryId);
}

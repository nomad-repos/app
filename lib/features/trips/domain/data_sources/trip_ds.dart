import 'package:nomad_app/shared/models/models.dart';

abstract class TripDs {

  Future<void> createEvent( Event event, Activity activity, String token );
  Future<void> getEvent( int eventId, String token );
  Future<void> getAllEvent( int tripId, String token );

}

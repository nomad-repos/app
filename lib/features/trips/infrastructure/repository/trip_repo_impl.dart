
import 'package:nomad_app/features/trips/trip.dart';
import 'package:nomad_app/shared/models/activity.dart';
import 'package:nomad_app/shared/models/event.dart';

class TripRepositoryImpl implements TripRepository{

  final TripDs tripDs;

  TripRepositoryImpl({
    TripDs? tripDs 
  }) : tripDs = tripDs ?? TripDSimpl();

  @override
  Future<void> createEvent(Event event, Activity activity, String token) {
    return tripDs.createEvent(event, activity, token);
  }

  @override
  Future<void> getAllEvent(int tripId, String token) {
    return tripDs.getAllEvent(tripId, token);
  }

  @override
  Future<void> getEvent(int eventId, String token) {
    return tripDs.getEvent(eventId, token);
  }
}
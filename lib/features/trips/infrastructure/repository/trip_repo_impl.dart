
import 'package:nomad_app/features/trips/trip.dart';

class TripRepositoryImpl implements TripRepository{

  final TripDs tripDs;

  TripRepositoryImpl({
    TripDs? tripDs 
  }) : tripDs = tripDs ?? TripDSimpl();
}
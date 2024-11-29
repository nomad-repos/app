
import 'package:nomad_app/features/trips/trip.dart';
import 'package:nomad_app/shared/models/models.dart';

class TripRepositoryImpl implements TripRepository{

  final TripDs tripDs;

  TripRepositoryImpl({
    TripDs? tripDs 
  }) : tripDs = tripDs ?? TripDSimpl();

  @override
  Future<void> createEvent(Event event, Activity activity, String token, int locationId) {
    return tripDs.createEvent(event, activity, token, locationId);
  }

  @override
  Future getAllEvent(int tripId, String token) {
    return tripDs.getAllEvent(tripId, token);
  }

  @override
  Future<void> getEvent(int eventId, String token) {
    return tripDs.getEvent(eventId, token);
  }
  
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
  
  @override
  Future updateEvent( Event event, String token) {
    return tripDs.updateEvent(event, token);
  }
  
  @override
  Future addExpense(Expense expense, String token) {
    return tripDs.addExpense(expense, token);
  }
  
  @override
  Future getExpenses(int tripId, String token) {
    return tripDs.getExpenses(tripId, token);
  }
  
  @override
  Future deleteExpense(int expenseId, int userId, String token) {
    return tripDs.deleteExpense(expenseId, userId, token);
  }
  
  @override
  Future updateExpense(Expense expense, String token) {
    return tripDs.updateExpense(expense, token);
  }
  
  @override
  Future deleteEvent(int eventId, String token) {
    return tripDs.deleteEvent(eventId, token);
  }

  
}


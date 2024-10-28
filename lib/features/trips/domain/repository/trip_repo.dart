import 'package:nomad_app/shared/models/models.dart';

abstract class TripRepository {
  Future getLocations( int tripId, String token );
  
  Future createEvent( Event event, Activity activity, String token, int locationId );
  Future getEvent( int eventId, String token );
  Future getAllEvent( int tripId, String token );

  Future getCategories(String token);
  Future getActivites(String token, String localityLocation, int categoryId);

  Future updateEvent( Event event, String token );

  Future addExpense( Expense expense, String token );
  Future getExpenses (int tripId, String token);
    //TODO: ver los parametros que lleva
}
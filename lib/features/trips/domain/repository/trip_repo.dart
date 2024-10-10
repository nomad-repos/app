abstract class TripRepository {
  
  Future getLocations( int tripId, String token );

  Future getCategories(String token);

  Future getActivites(String token, String localityLocation, int categoryId);
}
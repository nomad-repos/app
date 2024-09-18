abstract class PlanTripRepository {
  
  Future getCountries( String token );
  Future getCities( String isoCode, String token ); 

}
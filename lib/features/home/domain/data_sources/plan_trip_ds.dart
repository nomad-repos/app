abstract class PlanTripDS {

  Future getCountries( String token );
  Future getCities( String isoCode, String token ); 

  //Future createTrip(int userId, String name, String initData, String endDate, String  )
}

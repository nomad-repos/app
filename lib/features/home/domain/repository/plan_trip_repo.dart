abstract class PlanTripRepository {
  Future getCountries(String token);
  Future getCities(String isoCode, String token);
  Future createTrip(
      String token, int userId, String name, DateTime initDate, DateTime endDate, List locations);
}

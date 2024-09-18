
import 'package:nomad_app/features/home/home.dart';

class PlanTripRepositoryImpl implements PlanTripRepository{

  final PlanTripDS planTripDS;

  PlanTripRepositoryImpl({
    PlanTripDS? planTripDS 
  }) : planTripDS = planTripDS ?? PlanTripDSimpl();

  @override
  Future getCountries(String token) {
    return planTripDS.getCountries(token);
  }

  @override
  Future getCities(String isoCode, String token) {
    return planTripDS.getCities(isoCode, token);
  }
}

import 'package:nomad_app/features/home/home.dart';

class HomeRepositoryImpl implements HomeRepository{

  final HomeDS homeDS;

  HomeRepositoryImpl({
    HomeDS? homeDS 
  }) : homeDS = homeDS ?? HomeDSimpl();

  @override
  Future getTrips(String userId, String token) {
    return homeDS.getTrips(userId, token);
  }
}
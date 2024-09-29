
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nomad_app/features/trips/trip.dart';


class TripDSimpl implements TripDs {

  final dio = Dio( 
    BaseOptions(
      baseUrl: dotenv.env['API_URL'] ?? 'No esta configurado el API_URL' //!En una variable de entorno esta el [API_URL].
    )
  );
  
  //? Implementación de la interfaz [TripDS].
}
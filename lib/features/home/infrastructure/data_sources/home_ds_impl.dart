
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:nomad_app/features/home/home.dart';

import '../../../../helpers/helpers.dart';


class HomeDSimpl implements HomeDS {

  final dio = Dio( 
    BaseOptions(
      baseUrl: dotenv.env['API_URL'] ?? 'No esta configurado el API_URL' //!En una variable de entorno esta el [API_URL].
    )
  );
  
  @override
  Future getTrips(String userId, String token) async {
    try {
        final resp = await dio.get( 
          '/trips/get_trips?user_id=$userId',
          options: Options(
            headers: {
              "authorization": "Bearer $token",
            },
        ));

        if (resp.statusCode == 200) {
          return resp;
        } 

      } on DioException catch (e) {
        if(e.response?.statusCode == 400 ){
          throw CustomError(e.response?.data['msg'] ?? 'Credenciales incorrectas' );
        }
        if ( e.type == DioExceptionType.connectionTimeout ){
          throw CustomError('Revisar conexión a internet.');
        }
        if( e.response?.statusCode == 401 ){
          throw CustomError('Localidades no encontradas.');
        }
        throw Exception();
    } catch (e) {
        throw Exception();
    }
  }
}
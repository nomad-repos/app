import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nomad_app/features/trips/trip.dart';

import '../../../../helpers/helpers.dart';

class TripDSimpl implements TripDs {
  final dio = Dio(BaseOptions(
      baseUrl: dotenv.env['API_URL'] ??
          'No esta configurado el API_URL' //!En una variable de entorno esta el [API_URL].
      ));

  @override
  Future getLocations(int tripId, String token) async {
    try {
      final resp = await dio.get('/trip/get_trip_locations?trip_id=$tripId',
          options: Options(
            headers: {
              "authorization": "Bearer $token",
            },
          ));

      if (resp.statusCode == 200) {
        return resp;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw CustomError(
            e.response?.data['msg'] ?? 'Credenciales incorrectas');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet.');
      }
      if (e.response?.statusCode == 500) {
        throw CustomError('Localidades no encontradas.');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future getCategories(String token) async {
    try {
      final resp = await dio.get('/events/get_categories',
          options: Options(
            headers: {
              "authorization": "Bearer $token",
            },
          ));

      if (resp.statusCode == 200) {
        return resp;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw CustomError(
            e.response?.data['msg'] ?? 'Credenciales incorrectas');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet.');
      }
      if (e.response?.statusCode == 500) {
        throw CustomError('Error en el servidor.');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }
  
  @override
  Future getActivites(String token, String localityLocation, int categoryId) async {
    try {
      final resp = await dio.get('/events/get_nearby_activities?locality_location=$localityLocation&category_id=$categoryId',
          options: Options(
            headers: {
              "authorization": "Bearer $token",
            },
          ));

      if (resp.statusCode == 200) {
        return resp;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw CustomError(
            e.response?.data['msg'] ?? 'Credenciales incorrectas');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet.');
      }
      if (e.response?.statusCode == 500) {
        throw CustomError('Error en el servidor.');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }
  
}

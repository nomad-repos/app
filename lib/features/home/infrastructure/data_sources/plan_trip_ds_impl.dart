import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:nomad_app/features/home/home.dart';

import '../../../../helpers/helpers.dart';

class PlanTripDSimpl implements PlanTripDS {
  final dio = Dio(BaseOptions(
      baseUrl: dotenv.env['API_URL'] ??
          'No esta configurado el API_URL' //!En una variable de entorno esta el [API_URL].
      ));

  @override
  Future getCountries(String token) async {
    try {
      final resp = await dio.get('/countries',
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
      if (e.response?.statusCode == 401) {
        throw CustomError('Localidades no encontradas.');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future getCities(String isoCode, String token) async {
    try {
      final resp =
          await dio.get('/trips/get_location?country_iso_code=$isoCode',
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
      if (e.response?.statusCode == 401) {
        throw CustomError('Localidades no encontradas.');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future createTrip(String token, int userId, String name, DateTime initDate,
      DateTime endDate, List locations) async {
    try {
      final createTripJson = {
        "user_id": userId,
        "trip_name": name,
        "start_date": initDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "locations": locations
      };

      final resp = await dio.post(
        '/trip/create_trip',
        data: createTripJson,
        options: Options(headers: {
          "authorization": "Bearer $token",
          "Content-Type": "application/json"
        }),
      );

      if (resp.statusCode == 200) {
        return resp.data;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw CustomError(
            e.response?.data['msg'] ?? 'Invalid format');
      }

      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet.');
      }

      if (e.response?.statusCode == 500) {
      throw CustomError(e.response?.data['msg'] ?? 'Error en el servidor');
    }
    throw Exception();
    } catch (e) {
      throw Exception();
    }
  }
}

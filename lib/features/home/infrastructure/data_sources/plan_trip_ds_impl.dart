import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:nomad_app/features/home/home.dart';
import 'package:nomad_app/shared/utils/utils.dart';

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
        await dio.get('/countries/get_localities?country_iso_code=$isoCode',
          options: Options(
            headers: {
              "authorization": "Bearer $token",
            },
          )
        );

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
  Future createTrip(String token, int userId, String name, String initDate,
      String endDate, List locations) async {
        
    try {
      final createTripJson = {
        "user_id": userId,
        "trip_name": name,
        "trip_start_date": initDate,
        "trip_finish_date": endDate,
        "localities": locations
      };

      final resp = await dio.post(
        '/trips/create_trip',
        data: createTripJson,
        options: Options(headers: {
          "authorization": "Bearer $token",
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

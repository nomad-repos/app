
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nomad_app/features/trips/trip.dart';
import 'package:nomad_app/helpers/helpers.dart';
import 'package:nomad_app/shared/models/activity.dart';
import 'package:nomad_app/shared/models/event.dart';


class TripDSimpl implements TripDs {

  final dio = Dio( 
    BaseOptions(
      baseUrl: dotenv.env['API_URL'] ?? 'No esta configurado el API_URL' //!En una variable de entorno esta el [API_URL].
    )
  );

  @override
  Future<void> createEvent(Event event, Activity activity, String token) async {
    try {
      final createEventJson = {    
          "event": {
            "event_title": event.eventTitle,
            "event_date": event.eventDate,
            "event_start_time": event.eventStartTime,
            "event_finish_time": event.eventFinishTime,
            "trip_id": event.tripId,
          },
          "activity":{
            "activity_title": activity.activityTitle,
            "activity_latitude": activity.activityLatitude,
            "activity_longitude": activity.activityLongitude,
            "activity_photo_url": activity.activityPhotoUrl,
            "locality_id": activity.localityId,
            "category_id": activity.categoryId,
        }
      };

      final resp = await dio.post(
        '/events/create_event',
        data: createEventJson,
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

  @override
  Future<void> getAllEvent(int tripId, String token) async {
    try {
      final resp = await dio.get('/events/get_all?=$tripId',
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ));

      if (resp.statusCode == 200) {
        return resp.data;
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
  Future<void> getEvent(int eventId, String token) async {
    try {
      final resp = await dio.get('/events/get_event?=$eventId',
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ));

      if (resp.statusCode == 200) {
        return resp.data;
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

}
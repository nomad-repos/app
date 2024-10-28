import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:nomad_app/features/trips/trip.dart';
import 'package:nomad_app/helpers/helpers.dart';
import 'package:nomad_app/shared/models/event.dart';
import 'package:nomad_app/shared/models/expense.dart';
import 'package:nomad_app/shared/utils/utils.dart';

import '../../../../shared/models/activity.dart';

class TripDSimpl implements TripDs {
  final dio = Dio(BaseOptions(
      baseUrl: dotenv.env['API_URL'] ??
          'No esta configurado el API_URL' //!En una variable de entorno esta el [API_URL].
      ));

  @override
  Future getLocations(int tripId, String token) async {
    try {
      final resp = await dio.get('/trips/get_trip_localities?trip_id=$tripId',
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
  Future getActivites(
      String token, String localityLocation, int categoryId) async {
    try {
      final resp = await dio.get(
          '/events/get_nearby_activities?locality_location=$localityLocation&category_id=$categoryId',
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
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<void> createEvent(
      Event event, Activity activity, String token, int locationId) async {
    try {
      final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

      final createEventJson = {
        "event": {
          "event_title": event.eventTitle,
          "event_description": event.eventDescription,
          "event_date": dateFormat.format(event.eventDate),
          "event_start_time": event.eventStartTime,
          "event_finish_time": event.eventFinishTime,
          "trip_id": event.tripId,
        },
        "activity": {
          "activity_address": activity.activityAddress,
          "activity_ext_id": activity.activityExtId,
          "activity_title": activity.activityName,
          "activity_latitude": activity.activityLatitude,
          "activity_longitude": activity.activityLongitude,
          "activity_photo_url": activity.activityUrlPhoto,
          "locality_id": locationId,
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
      print(e.response?.data);
      if (e.response?.statusCode == 400) {
        throw CustomError(e.response?.data['msg'] ?? 'Invalid format');
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
  Future getAllEvent(int tripId, String token) async {
    try {
      final resp = await dio.get('/events/get_all?trip_id=$tripId',
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
        throw CustomError(e.response?.data['msg'] ?? 'Invalid format');
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
  Future updateEvent(Event event, String token) async {
    try {
      final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

      final createEventJson = {
        "event_id": event.eventId,
        "event_title": event.eventTitle,
        "event_date": dateFormat.format(event.eventDate),
        "event_start_time": extractTime(event.eventStartTime),
        "event_finish_time": extractTime(event.eventFinishTime),
        "trip_id": event.tripId,
      };

      print(createEventJson);

      final resp = await dio.post(
        '/events/update_event',
        data: createEventJson,
        options: Options(headers: {
          "authorization": "Bearer $token",
        }),
      );

      print(resp);

      if (resp.statusCode == 200) {
        return resp.data;
      }
    } on DioException catch (e) {
      print(e.response?.data);
      if (e.response?.statusCode == 400) {
        throw CustomError(e.response?.data['msg'] ?? 'Invalid format');
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
  Future<void> addExpense(Expense expense, String token) async{
    try {
      print (expense.expenseAmount);
      final addExpenseJson = {
        
        "expense_description": expense.expenseDescription,
        "expense_amount": expense.expenseAmount,
        "expense_date": expense.expenseDate,
        "trip_id": expense.tripId,
        "category_id" : expense.categoryId,
        "user_id" : expense.userId,
        "expense_status" : expense.expenseStatus
    
      };

      print (addExpenseJson);

      final resp = await dio.post(
        '/wallet_screen',
        data: addExpenseJson,
        options: Options(headers: {
          "authorization": "Bearer $token",
        }),
      );
       print (resp.data);

      if (resp.statusCode == 200) {
        return resp.data;
      }

    } on DioException catch (e) {
      print(e.response?.data);
      if (e.response?.statusCode == 400) {
        throw CustomError(e.response?.data['msg'] ?? 'Invalid format');
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
  Future getExpenses(int tripId, String token) {
    // TODO: implement getExpenses
    throw UnimplementedError();
  }
}


import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../helpers/helpers.dart';
import '../../domain/domain.dart';


class AuthDSimpl implements AuthDS {

  final dio = Dio( 
    BaseOptions(
      baseUrl: dotenv.env['API_URL'] ?? 'No esta configurado el API_URL' //!En una variable de entorno esta el [API_URL].
    )
  );

  @override
  Future login( String email, String password) async {
      try {
          final loginJson = {
            "email" : email,
            "password" : password
          };

          final resp = await dio.post(
            '/login',
            data: loginJson,
          );

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
          throw CustomError('Inicio de sesión inválido.');
        }
        throw Exception();
    } catch (e) {
        throw Exception();
    }
  }

  @override
  Future checkAuthStatus(String token) async {
    try {
      final resp = await dio.post( 
        '/validate-token',
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
      ));

      if (resp.statusCode == 200) {
        return resp;
      }       
    } on DioException catch (e) {
        if( e.response?.statusCode == 400 || e.response?.statusCode == 401){
          throw CustomError('Token incorrecto.');
        }
        if ( e.type == DioExceptionType.connectionTimeout ){
          throw CustomError('Revisar conexión a internet');
        }
      throw Exception();
    } catch (e) {
        throw Exception();
    }
  }
  
  @override
  Future signUp(String name, String surname, String phone, String email, String password) async {
    try {
        final signUpJson = {
          "names"      : name,
          "last_names" : surname,
          "cellphone"  : phone,
          "email"      : email,
          "password"   : password
        };

        final resp = await dio.post(
          '/sign-up',
          data: signUpJson,
        );

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
          throw CustomError('Inicio de sesión inválido.');
        }
        throw Exception();
    } catch (e) {
        throw Exception();
    }
  }  
}
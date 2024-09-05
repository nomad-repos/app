
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
            '/auth/login',
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
        '/auth/validate-token',
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
  Future signUp(String name, String surname, String email, String password) async {
    try {
        final signUpJson = {
          "name"      : name,
          "surname"    : surname,
          "email"      : email,
          "password"   : password
        };

        final resp = await dio.post(
          '/auth/sign-up',
          data: signUpJson,
        );

        if (resp.statusCode == 200) {
          return resp;
        } 

      } on DioException catch (e) {
        if(e.response?.statusCode == 400 ){
          throw CustomError(e.response?.data['msg'] ?? 'Credenciales incorrectas' );
        }
        if( e.response?.statusCode == 500 ){
          throw CustomError(e.response?.data['msg'] ?? 'Error interno, intente más tarde.' );
        }
        if ( e.type == DioExceptionType.connectionTimeout ){
          throw CustomError('Revisar conexión a internet.');
        }
        throw Exception();
    } catch (e) {
        throw Exception();
    }
  }
  
  @override
  Future changePassword(String email, String password) async {
    try {
        final signUpJson = {
          "email"      : email,
          "new_password"   : password
        };

        final resp = await dio.post(
          '/auth/forgot-password/reset-password',
          data: signUpJson,
        );

        if (resp.statusCode == 200) {
          return resp;
        } 

      } on DioException catch (e) {
        if(e.response?.statusCode == 400 ){
          throw CustomError(e.response?.data['msg'] ?? 'Credenciales incorrectas' );
        }
        if( e.response?.statusCode == 500 ){
          throw CustomError(e.response?.data['msg'] ?? 'Error interno, intente más tarde.' );
        }
        if ( e.type == DioExceptionType.connectionTimeout ){
          throw CustomError('Revisar conexión a internet.');
        }
        throw Exception();
    } catch (e) {
        throw Exception();
    }
  }
  
  @override
  Future checkRecoveryCode(String email, String code) async {
    try {
        final signUpJson = {
          "email"  : email,
          "code"   : code
        };

        final resp = await dio.post(
          '/auth/forgot-password/validate-code',
          data: signUpJson,
        );

        if (resp.statusCode == 200) {
          return resp;
        } 

      } on DioException catch (e) {
        if(e.response?.statusCode == 400 ){
          throw CustomError(e.response?.data['msg'] ?? 'Credenciales incorrectas' );
        }
        if( e.response?.statusCode == 500 ){
          throw CustomError(e.response?.data['msg'] ?? 'Error interno, intente más tarde.' );
        }
        if ( e.type == DioExceptionType.connectionTimeout ){
          throw CustomError('Revisar conexión a internet.');
        }
        throw Exception();
    } catch (e) {
        throw Exception();
    }
  }
  
  @override
  Future sendRecoveryEmail(String email) async {
     try {
        final signUpJson = {
          "email"  : email,
        };

        final resp = await dio.post(
          '/auth/forgot-password/send-email',
          data: signUpJson,
        );

        if (resp.statusCode == 200) {
          return resp;
        } 

      } on DioException catch (e) {
        if(e.response?.statusCode == 400 ){
          throw CustomError(e.response?.data['msg'] ?? 'Credenciales incorrectas' );
        }
        if( e.response?.statusCode == 500 ){
          throw CustomError(e.response?.data['msg'] ?? 'Error interno, intente más tarde.' );
        }
        if ( e.type == DioExceptionType.connectionTimeout ){
          throw CustomError('Revisar conexión a internet.');
        }
        throw Exception();
    } catch (e) {
        throw Exception();
    }
  }  
}
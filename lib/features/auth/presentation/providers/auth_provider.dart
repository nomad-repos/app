
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_app/shared/shared.dart';

import '../../../../helpers/helpers.dart';

import '../../domain/domain.dart';
import '../../infrastructure/infrastructure.dart';

final authProvider = StateNotifierProvider<AuthNotifier,AuthState>((ref) {

  final authRepository = AuthRepositoryImpl();
  final keyValueStorage = KeyValueStorageImpl();

  final userNotifier = ref.watch(userProvider.notifier); 

  return AuthNotifier(
    authRepository: authRepository,
    keyValueStorage: keyValueStorage,
    userNotifier: userNotifier,
  );
});


class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final KeyValueStorageServices keyValueStorage;
  final UserNotifier userNotifier;

  AuthNotifier({ 
    required this.authRepository,
    required this.keyValueStorage,
    required this.userNotifier,
  }): super( AuthState() ) {
    checkAuthStatus(); 
  }

  Future<void> loginUser( String email, String password ) async { 
    try {
      final resp = await authRepository.login( email, password );

      if (resp.statusCode == 200){ 
        keyValueStorage.setKeyValue<String>('token', resp.data['access_token']);

        final User user = User.fromJson(resp.data['user']);    

        print(user);    

        userNotifier.saveUserData(user);

        state = state.copyWith(
          errorMessage: '',
          statusMessage: '',
          authStatus: AuthStatus.authenticated,
          registerStatus: RegisterStatus.registered,
        );

        _setLoggedUser(resp); 
      }
    } on CustomError catch (e) {
      logout( e.message ); 
    } catch (e){
      logout( e.toString() );
    }
  }

  //Verificamos el estado de la autentificación
  void checkAuthStatus() async {
    final token = await keyValueStorage.getValue<String>('token'); //Se puede especificar el tipo de dato porque lo escribimos como generico el getValue.
    if (token == null) return logout(); //Marco el estado como no autentificado
    try {
      final resp = await authRepository.checkAuthStatus(token); //Hacemos el trabajo de ver si el usuario esta autentificado o no.
      
      print(resp.data['user']);
      print(token);
      
      if (resp.statusCode == 200){
        
        final User user = User.fromJson(resp.data['user']);

        userNotifier.saveUserData(user);
        
        _setLoggedUser(resp); 
      }
    } catch (e) {
     logout();
    }
  }

  //Cambio el estado de la instancia del provider con el [copyWith] en caso de que se logue por primera vez o si el token es correcto.
  void _setLoggedUser(dynamic resp) async {
    state = state.copyWith(
      errorMessage: '',
      statusMessage: '',
      authStatus: AuthStatus.authenticated,
      registerStatus: RegisterStatus.registered,
    );
  }

  //Eliminamos el token y cambiamos el estado, esto ocurre cuando la persona le da al logout o ocurre algun error.
  Future<void> logout([ String? errorMessage ]) async {
    keyValueStorage.deleteKeyValue('token');
    state = state.copyWith(
      errorMessage: errorMessage,
      statusMessage: '',
      authStatus: AuthStatus.notAuthenticated,
      registerStatus: RegisterStatus.notRegistered,
    );
  }

  Future<void> registerUser( String name, String surname, String email, String password ) async {
    try {
      final resp = await authRepository.signUp( name, surname, email, password );

      if (resp.statusCode == 200){
        state = state.copyWith(
          registerStatus: RegisterStatus.registered,
          authStatus: AuthStatus.notAuthenticated,
          errorMessage: '',
          statusMessage: 'Usuario registrado correctamente. Ahora debe iniciar sesión.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        registerStatus: RegisterStatus.notRegistered,
        errorMessage: 'Error al registrarse, por favor intente de nuevo más tarde.',
        statusMessage: ''
      );
    }
  }

  //Metodo para enviar el correo de recuperacion de contraseña
  Future<bool> sendRecoveryEmail( String email ) async {
    try {
      final resp = await authRepository.sendRecoveryEmail( email );

      if (resp.statusCode == 200){
        state = state.copyWith(
          statusMessage: 'Correo enviado correctamente, revise su bandeja de entrada.',
          errorMessage: '',
        );
      }
      return true;
    } catch (e) {
      state = state.copyWith(
        statusMessage: '',
        errorMessage: 'Error al enviar el correo, por favor intente de nuevo más tarde.',
      );
    }
    return false;
  }

  //Metodo para verificar el codigo de recuperacion
  Future<bool> verifyCode( String email, String code ) async {
    try {
      final resp = await authRepository.checkRecoveryCode( email, code );

      if (resp.statusCode == 200){
        state = state.copyWith(
          statusMessage: 'Código verificado correctamente.',
          errorMessage: '',
        );
      }
      return true;
    } catch (e) {
      state = state.copyWith(
        statusMessage: '',
        errorMessage: 'Error al verificar el código, por favor intente de nuevo más tarde.',
      );
    }
    return false;
  }

  //Metodo para cambiar la contraseña
  Future<bool> resetPassword( String email, String password ) async {
    try {
      final resp = await authRepository.changePassword( email, password );

      if (resp.statusCode == 200){
        state = state.copyWith(
          statusMessage: 'Contraseña cambiada correctamente.',
          errorMessage: '',
        );
      }
      return true;
    } catch (e) {
      state = state.copyWith(
        statusMessage: '',
        errorMessage: 'Error al cambiar la contraseña, por favor intente de nuevo más tarde.',
      );
    }
    return false;
  }
}

//Clase para enumerar los estados de autentificacion posibles
enum AuthStatus { checking, authenticated, notAuthenticated }
enum RegisterStatus {checking, guest, notRegistered, registered }

//El provider necesita un notifier y un state, el state sirve como una representacion del estado actual en el proceso de logeo.
class AuthState {
  final AuthStatus authStatus;
  final RegisterStatus registerStatus;
  final String statusMessage;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking, 
    this.registerStatus = RegisterStatus.checking,
    this.statusMessage = '',
    this.errorMessage = '',
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    RegisterStatus? registerStatus,
    String? statusMessage,
    String? errorMessage,

  }) => AuthState(
    authStatus: authStatus ?? this.authStatus,
    registerStatus: registerStatus ?? this.registerStatus,
    statusMessage: statusMessage ?? this.statusMessage,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}
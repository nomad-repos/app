
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_app/features/auth/auth.dart';



///Provider del [goRouter] en [app_router.dart] escucha el estado de autentificación del usuario.
///
///Utiliza el [authProvider] ya que este le provee el estado de autentificación
final goRouterNotifierProvider = Provider((ref) {

  final authNotifier = ref.read(authProvider.notifier);

  return GoRouterNotifier(authNotifier);

});


///Implementacion
class GoRouterNotifier extends ChangeNotifier implements Listenable {

///Necesito la instancia de mi AuthNotifier para ver en que estado está
  final AuthNotifier _authNotifier;
  
///Este es el authStatus que viene en el AuthNotifier pero por defecto necesito inicializarlo con algun estado. En este caso el menos determinante es el checking.
  AuthStatus _authStatus = AuthStatus.checking;
  RegisterStatus _registerStatus = RegisterStatus.checking;

  GoRouterNotifier(this._authNotifier){
///En todo momento, cuando el conductor cambie de pantalla, esta pendiente del estado del auth. Cuando el [authNotifier] emita un nuevo estado (ej. se vence el token), cambia el estado del [authStatus].
    _authNotifier.addListener((state) { 
      authStatus = state.authStatus;
      registerStatus = state.registerStatus;
    });
  }

  AuthStatus get authStatus => _authStatus;

  set authStatus(AuthStatus value){
    _authStatus = value;
    notifyListeners();
  }

  RegisterStatus get registerStatus => _registerStatus;

  set registerStatus(RegisterStatus value){
    _registerStatus = value;
    notifyListeners();
  }
}
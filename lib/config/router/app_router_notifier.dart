
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_app/features/auth/presentation/presentation.dart';



final goRouterNotifierProvider = Provider((ref) {

  final authNotifier = ref.read(authProvider.notifier);

  return GoRouterNotifier(authNotifier);

});

class GoRouterNotifier extends ChangeNotifier implements Listenable {

  final AuthNotifier _authNotifier;
  
  AuthStatus _authStatus = AuthStatus.checking;
  RegisterStatus _registerStatus = RegisterStatus.checking;

  GoRouterNotifier(this._authNotifier){
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
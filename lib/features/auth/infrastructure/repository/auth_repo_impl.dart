
import '../../domain/domain.dart';
import '../infrastructure.dart';

class AuthRepositoryImpl implements AuthRepository{

  final AuthDS authDS;

  AuthRepositoryImpl({
    AuthDS? authDS 
  }) : authDS = authDS ?? AuthDSimpl();
  
  @override
  Future login( String email, String password ) {
    return authDS.login( email, password );
  }
  
  @override
  Future checkAuthStatus(String token) {
    return authDS.checkAuthStatus(token);
  }
  
  @override
  Future signUp(String name, String surname, String email, String password) {
    return authDS.signUp(name, surname, email, password);
  }
  
  @override
  Future changePassword(String email, String password) {
    return authDS.changePassword(email, password);
  }
  
  @override
  Future checkRecoveryCode(String email, String code) {
    return authDS.checkRecoveryCode(email, code);
  }
  
  @override
  Future sendRecoveryEmail(String email) {
    return authDS.sendRecoveryEmail(email);
  }
}
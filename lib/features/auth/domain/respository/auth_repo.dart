
abstract class AuthRepository {

  Future login( String email, String password );
  Future checkAuthStatus( String token );  

  Future signUp( String name, String surname,  String phone, String email, String password );

}

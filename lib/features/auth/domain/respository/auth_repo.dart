abstract class AuthRepository {

  Future login( String email, String password );
  Future checkAuthStatus( String token );  
  Future signUp( String name, String surname, String email, String password );

  //Recovery password methods
  Future sendRecoveryEmail( String email );
  Future checkRecoveryCode( String email, String code );
  Future changePassword( String email, String password );
}

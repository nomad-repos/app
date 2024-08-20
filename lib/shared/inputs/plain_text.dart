import 'package:formz/formz.dart';

// Define input validation errors
enum PlainTextError { empty, format }

// Extend FormzInput and provide the input type and error type.
class PlainText extends FormzInput<String, PlainTextError> {

  static final RegExp plainTextRegExp = RegExp(
    r'^[a-zA-Z\s]+$' 
  );

  // Call super.pure to represent an unmodified form input.
  const PlainText.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const PlainText.dirty( String value ) : super.dirty(value);



  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == PlainTextError.empty ) return 'El campo es requerido';
    if ( displayError == PlainTextError.format ) return 'Hay caracteres no permitidos'; 

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  PlainTextError? validator(String value) {
    
    if ( value.isEmpty || value.trim().isEmpty ) return PlainTextError.empty;
    if ( !plainTextRegExp.hasMatch(value) ) return PlainTextError.format;

    return null;
  }
}
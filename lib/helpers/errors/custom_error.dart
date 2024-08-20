
class CustomError implements Exception {
  final String message;

  CustomError(this.message);

  @override
  String toString() => message;
}


//Errores personalizados, asi como los de java.

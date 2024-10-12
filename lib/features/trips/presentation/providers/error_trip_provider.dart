
import 'package:flutter_riverpod/flutter_riverpod.dart';

final errorTripProvider = StateNotifierProvider<ErrorTripNotifer, ErrorTripState>((ref) {
  return ErrorTripNotifer();
});

class ErrorTripNotifer extends StateNotifier<ErrorTripState> {
  ErrorTripNotifer() : super(ErrorTripState());
  
  void setError(ErrorTripStatus type, String? message) {
    switch (type) {
      case ErrorTripStatus.generalError:
        state = state.copyWith(
          errorMessage: message ?? 'Ha ocurrido un error intenta más tarde',
          errorType: type
        );
        break;
      case ErrorTripStatus.errorInvalidForm:
        state = state.copyWith(
          errorMessage: message ?? 'Por favor completa todos los campos',
          errorType: type
        );
        break;
      case ErrorTripStatus.errorCreatingEvent:
        state = state.copyWith(
          errorMessage: message ?? 'Error al crear el evento',
          errorType: type
        );
        break;
      default:
        state = state.copyWith(
          errorMessage: '',
          errorType: ErrorTripStatus.none
        );
    }
  }
  
}

enum ErrorTripStatus {
  none,
  generalError,
  errorInvalidForm,
  errorCreatingEvent,
}

class ErrorTripState {
  final String errorMessage;
  final ErrorTripStatus errorType;

  ErrorTripState({
    this.errorMessage = '', 
    this.errorType = ErrorTripStatus.none
  });

  ErrorTripState copyWith({
    String? errorMessage,
    ErrorTripStatus? errorType
  }) {
    return ErrorTripState(
      errorMessage: errorMessage ?? this.errorMessage,
      errorType: errorType ?? this.errorType
    );
  }  
}

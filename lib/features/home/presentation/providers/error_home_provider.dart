
import 'package:flutter_riverpod/flutter_riverpod.dart';

final errorHomeProvider = StateNotifierProvider<ErrorHomeNotifer, ErrorHomerState>((ref) {
  return ErrorHomeNotifer();
});

class ErrorHomeNotifer extends StateNotifier<ErrorHomerState> {
  ErrorHomeNotifer() : super(ErrorHomerState());
  
  void setError(ErrorHomeStatus type, String? message) {
    switch (type) {
      case ErrorHomeStatus.generalError:
        state = state.copyWith(
          errorMessage: message ?? 'Ha ocurrido un error intenta más tarde',
          errorType: type
        );
        break;
      default:
        state = state.copyWith(
          errorMessage: '',
          errorType: ErrorHomeStatus.none
        );
    }
  }
  
}

enum ErrorHomeStatus {
  none,
  generalError,
}

class ErrorHomerState {
  final String errorMessage;
  final ErrorHomeStatus errorType;

  ErrorHomerState({
    this.errorMessage = '', 
    this.errorType = ErrorHomeStatus.none
  });

  ErrorHomerState copyWith({
    String? errorMessage,
    ErrorHomeStatus? errorType
  }) {
    return ErrorHomerState(
      errorMessage: errorMessage ?? this.errorMessage,
      errorType: errorType ?? this.errorType
    );
  }  
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import '../../../../shared/shared.dart';
import '../presentation.dart';


final resetPasswordFormProvider = StateNotifierProvider.autoDispose<ResetPasswordFormNotifier,ResetPasswordFormState>((ref) {

  final authNotifier = ref.watch(authProvider.notifier);

  return ResetPasswordFormNotifier(
    authNotifier: authNotifier
  );
});

class ResetPasswordFormNotifier extends StateNotifier<ResetPasswordFormState> {

  final AuthNotifier authNotifier;

  ResetPasswordFormNotifier({
    required this.authNotifier,
  }): super( ResetPasswordFormState() );
  
  onEmailChange( String value ) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isEmailValid: Formz.validate([ newEmail ])
    );
  }

  //Este no usa el form.validate porque es un texto simple, no tiene que, en principio, seguir ningunna estrctura como las de los correos.
  onVerificationCodeChange( String value ) {
    state = state.copyWith(
      verificationCode: value,
    );
  }

  onFirstPasswordChange( String value ) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      firstPassword: newPassword,
      arePasswordsValid: Formz.validate([ newPassword, state.secondPassword ])
    );
  } 

  onSecondPasswordChange( String value ) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      secondPassword: newPassword,
      arePasswordsValid: Formz.validate([ state.firstPassword, newPassword ])
    );
  }

  emailWasNotSent() {
    state = state.copyWith( wasEmailSent: false );
  }

  //Este metodo sirve para mandarle el correo al backend con el email del usuario.
  onEmailSubmit() async {
    _touchEmailField();
    state = state.copyWith( isPosting: true );
    final bool sent = await authNotifier.sendRecoveryEmail( state.email.value );
    if ( sent ) {
      state = state.copyWith( isPosting: false, wasEmailSent: true );
    } else {
      state = state.copyWith( isPosting: false );
    }
  }

  _touchEmailField() {
    final email    = Email.dirty(state.email.value);
    state = state.copyWith(
      email: email,
      isEmailValid: Formz.validate([ email ])
    );
  }

  onVericationCodeSubmit() async {
    state = state.copyWith( isPosting: true );
    final bool verified = await authNotifier.verifyCode( state.email.value, state.verificationCode );
    if ( verified ) {
      state = state.copyWith( isPosting: false, wasCodeVerified: true );
    } else {
      state = state.copyWith( isPosting: false );
    }
  }

  onPasswordSubmit() async {
    _touchPasswordsFields();
    if ( !state.arePasswordsValid ) return;
    state = state.copyWith( isPosting: true );
    final bool changed = await authNotifier.resetPassword( state.email.value, state.firstPassword.value );
    if ( changed ) {
      state = state.copyWith( isPosting: false, wasPasswordChanged: true );
    } else {
      state = state.copyWith( isPosting: false );
    }
  }

  _touchPasswordsFields() {
    final firstPassword  = Password.dirty(state.firstPassword.value);
    final secondPassword = Password.dirty(state.secondPassword.value);
    
    final bool arePasswordsValid = Formz.validate([ firstPassword, secondPassword ]);
    final bool arePasswordsEqual = state.firstPassword.value == state.secondPassword.value;

    state = state.copyWith(
      firstPassword: firstPassword,
      secondPassword: secondPassword,
      arePasswordsValid: arePasswordsValid && arePasswordsEqual
    );
  }
}

class ResetPasswordFormState {
  //Booleanos de control
  final bool isPosting;
  final bool isEmailValid;
  final bool arePasswordsValid;
  final bool wasEmailSent;
  final bool wasCodeVerified;
  final bool wasPasswordChanged;
  //Datos del formulario
  final Email email;
  final String verificationCode;
  final Password firstPassword;
  final Password secondPassword;

  ResetPasswordFormState({
    this.isPosting = false,
    this.isEmailValid = false,
    this.arePasswordsValid = false,
    this.wasEmailSent = false,
    this.wasCodeVerified = false,
    this.wasPasswordChanged = false,
    this.email = const Email.pure(),
    this.verificationCode = '',
    this.firstPassword = const Password.pure(),
    this.secondPassword = const Password.pure(),
  });

  ResetPasswordFormState copyWith({
    bool? isPosting,
    bool? isEmailValid,
    bool? arePasswordsValid,
    bool? wasEmailSent,
    bool? wasCodeVerified,
    bool? wasPasswordChanged,
    Email? email,
    String? verificationCode,
    Password? firstPassword,
    Password? secondPassword,
  }) => ResetPasswordFormState(
    isPosting: isPosting ?? this.isPosting,
    isEmailValid: isEmailValid ?? this.isEmailValid,
    arePasswordsValid: arePasswordsValid ?? this.arePasswordsValid,
    wasEmailSent: wasEmailSent ?? this.wasEmailSent,
    wasCodeVerified: wasCodeVerified ?? this.wasCodeVerified,
    wasPasswordChanged: wasPasswordChanged ?? this.wasPasswordChanged,
    email: email ?? this.email,
    verificationCode: verificationCode ?? this.verificationCode,
    firstPassword: firstPassword ?? this.firstPassword,
    secondPassword: secondPassword ?? this.secondPassword,
  );
}
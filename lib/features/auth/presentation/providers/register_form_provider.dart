import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import '../../../../shared/shared.dart';
import '../../auth.dart';



final registerFormProvider = StateNotifierProvider.autoDispose<RegisterFormNotifier,RegisterFormState>((ref) {

  final registerUserCallback = ref.watch(authProvider.notifier).registerUser;

  return RegisterFormNotifier(
    registerUserCallback : registerUserCallback
  );
});


class RegisterFormNotifier extends StateNotifier<RegisterFormState> {

  final Function(String, String, String, String, String) registerUserCallback;

  RegisterFormNotifier({
    required this.registerUserCallback,
  }): super( RegisterFormState() );

  onNameChange( String value ) {
    final newName = PlainText.dirty(value);
    state = state.copyWith(
      name: newName,
      isValid: Formz.validate([ newName, state.surname, state.email, state.password, state.phone])
    );
  }

  onSurnameChange( String value ) {
    final newSurname = PlainText.dirty(value);
    state = state.copyWith(
      surname: newSurname,
      isValid: Formz.validate([ state.name, newSurname, state.email, state.password, state.phone])
    );
  }

  onPhoneChange( String value ) {
    final newPhone = Number.dirty(value);
    state = state.copyWith(
      phone: newPhone,
      isValid: Formz.validate([ state.name, state.surname, state.email, state.password, newPhone ])
    );
  }
  
  onEmailChange( String value ) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([ state.name, state.surname, newEmail, state.password, state.phone ])
    );
  }

  onPasswordChanged( String value ) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([state.name, state.surname, state.email, newPassword, state.phone ])
    );
  }

  onFormSubmit() async {
    state = state.copyWith( isPosting: true );

    _touchEveryField();

    if ( !state.isValid ) return;

    await registerUserCallback( state.name.value, state.surname.value, state.email.value, state.password.value, state.phone.value );

    state = state.copyWith( isPosting: false );
    }

  _touchEveryField() {

    final email    = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final name     = PlainText.dirty(state.name.value);
    final surname  = PlainText.dirty(state.surname.value);
    final phone    = Number.dirty(state.phone.value);


    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      name: name,
      surname: surname,
      phone: phone,
      isValid: Formz.validate([ email, password, name, surname, phone ])
    );
  }

  cleanForm(){
    state = state.copyWith(
      isFormPosted: false,
      email: const Email.pure(),
      password: const Password.pure(),
      name: const PlainText.pure(),
      surname: const PlainText.pure(),
      phone: const Number.pure(),
      isValid: false
    );
  }

}


//! 1 - State del provider
class RegisterFormState {

  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;

  final Email email;
  final Password password;
  final PlainText name;
  final PlainText surname;
  final Number phone;

  RegisterFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.name = const PlainText.pure(),
    this.surname = const PlainText.pure(),
    this.phone = const Number.pure(),
  });

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
    PlainText? name,
    PlainText? surname,
    Number? phone,
  }) => RegisterFormState(
    isPosting: isPosting ?? this.isPosting,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isValid: isValid ?? this.isValid,
    email: email ?? this.email,
    password: password ?? this.password,
    name: name ?? this.name,
    surname: surname ?? this.surname,
    phone: phone ?? this.phone,
  );

  @override
  String toString() {
    return '''
  LoginFormState:
    isPosting: $isPosting
    isFormPosted: $isFormPosted
    isValid: $isValid
    email: $email
    password: $password
    name: $name
    surname: $surname
''';
  }
}
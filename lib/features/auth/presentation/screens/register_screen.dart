import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_app/features/auth/auth.dart';
import 'package:nomad_app/helpers/helpers.dart';
import 'package:nomad_app/shared/shared.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerForm = ref.watch(registerFormProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isNotEmpty) {
        showSnackbar(context, next.errorMessage, Colors.red);
      }
      if (next.statusMessage.isNotEmpty) {
        showSnackbar(context, next.statusMessage, Colors.green);
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/registro.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: const Color.fromARGB(255, 2, 15, 21).withOpacity(0.7),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.1), // Espacio adicional en la parte superior
                      const Text('Convertite en',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w200,
                              fontSize: 25)),
                      
                      const Text('nomad.',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 40)),
                      
                      const SizedBox(height: 50), // Espacio antes de los campos de texto
                      
                      CustomTextFormFieldAuth(
                        hint: 'Nombre',
                        keyboardType: TextInputType.name,
                        onChanged: (value) => ref.read(registerFormProvider.notifier).onNameChange(value),
                        errorMessage: registerForm.isFormPosted ? registerForm.name.errorMessage : null,
                      ),
                      
                      const SizedBox(height: 30),
                
                      CustomTextFormFieldAuth(
                        hint: 'Apellido',
                        keyboardType: TextInputType.name,
                        onChanged: (value) => ref.read(registerFormProvider.notifier).onSurnameChange(value),
                        errorMessage: registerForm.isFormPosted ? registerForm.surname.errorMessage : null,
                      ),
                
                      const SizedBox(height: 30),
                
                      CustomTextFormFieldAuth(
                        hint: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => ref.read(registerFormProvider.notifier).onEmailChange(value),
                        errorMessage: registerForm.isFormPosted ? registerForm.email.errorMessage : null,
                      ),
                
                      const SizedBox(height: 30),
                
                      CustomTextFormFieldAuth(
                        hint: 'Contraseña',
                        obscureText: true,
                        onChanged: (value) => ref.read(registerFormProvider.notifier).onPasswordChanged(value),
                        errorMessage: registerForm.isFormPosted ? registerForm.password.errorMessage : null,
                      ),
                      SizedBox(height: 50),
                       // Espacio antes del botón
                      CustomFilledButton(
                        text: 'Unirme',
                        width: double.infinity,
                        onPressed: () {
                          ref.read(registerFormProvider.notifier).onFormSubmit();    
                          FocusScope.of(context).unfocus();
                        },
                      ),
                
                      SizedBox(height: MediaQuery.of(context).size.height * 0.1), // Espacio adicional en la parte inferior
                    
                    ],
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: ref.watch(registerFormProvider).isPosting,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

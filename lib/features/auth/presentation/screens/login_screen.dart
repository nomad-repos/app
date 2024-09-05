import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_app/features/auth/auth.dart';
import 'package:nomad_app/helpers/helpers.dart';

import 'package:nomad_app/shared/shared.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final loginForm = ref.watch(loginFormProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isNotEmpty) {
        showSnackbar(context, next.errorMessage, Colors.red);
      }
    });

    return Scaffold(
        body: Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/iniciarsesion.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            color: const Color.fromARGB(255, 2, 15, 21).withOpacity(0.7),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Expanded(child: Container()),

                CustomTextFormFieldAuth(
                  hint: 'Email',
                  onChanged: (value) => ref.watch(loginFormProvider.notifier).onEmailChange(value),
                  errorMessage: loginForm.isFormPosted ? loginForm.email.errorMessage : null,
                ),

                const SizedBox(height: 30),

                CustomTextFormFieldAuth(
                  hint: 'Contraseña',
                  obscureText: true,
                  onChanged: (value) => ref.watch(loginFormProvider.notifier).onPasswordChanged(value),
                  errorMessage: loginForm.isFormPosted ? loginForm.password.errorMessage : null,
                ),

                TextButton(
                  onPressed: () {
                    context.push('/reset_password');
                  },
                  style: TextButton.styleFrom(
                    splashFactory:
                        NoSplash.splashFactory, // Elimina el efecto de splash
                  ),
                  child: const Text('¿Olvidaste tu contraseña?',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300)),
                ),
                
                Expanded(child: Container()),

                CustomFilledButton(
                    text: 'Iniciar sesión',
                    width: double.infinity,
                    onPressed: () {
                      ref.watch(loginFormProvider.notifier).onFormSubmit(); 
                      FocusScope.of(context).unfocus();
                    }
                  ),
                const SizedBox(height: 20),

                CustomFilledButton(
                  text: 'Registrarse',
                  width: double.infinity,
                  buttonColor: Colors.transparent,
                  onPressed: () {
                    context.push('/register');
                  }
                ),

                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    splashFactory:
                        NoSplash.splashFactory, // Elimina el efecto de splash
                  ),
                  child: const Text('Continuar como invitado',
                    style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w300
                    )
                  ),
                ),
              ],
            ),
          ),
        ),

        Visibility(
          visible: ref.watch(loginFormProvider).isPosting ,
          child: Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        ),

      ],
    ));
  }
}

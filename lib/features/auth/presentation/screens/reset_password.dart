import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_app/features/auth/auth.dart';
import 'package:nomad_app/helpers/helpers.dart';
import 'package:nomad_app/shared/shared.dart';

class ResetPassword extends ConsumerWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    ref.listen(authProvider, (previous, next) {
      if ( next.errorMessage.isEmpty ) return;
        showSnackbar( context, next.errorMessage, Colors.red );
    });

    ref.listen(resetPasswordFormProvider, (previous, next) {
      if (next.wasPasswordChanged){
        context.pushReplacement('/login');
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
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withOpacity(0.7),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color.fromARGB(139, 255, 255, 255),
                  const Color.fromARGB(255, 1, 23, 38).withOpacity(0.6),
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ref.watch(resetPasswordFormProvider).wasEmailSent
                  ? ref.watch(resetPasswordFormProvider).wasCodeVerified
                      ? const _WriteNewPassword() //Hacer el formulario
                      : const _WriteVerificationCode()
                  : const _ForgotPasswordCard(),
              ),
              Visibility(
                visible: ref.watch(resetPasswordFormProvider).isPosting ,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              ) ,
            ],
          ),
        ),
      ],
    ));
  }
}

class _ForgotPasswordCard extends ConsumerWidget {
  const _ForgotPasswordCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final resetFormNotifier = ref.watch(resetPasswordFormProvider.notifier);

    return Column(
      children: [
        Expanded(child: Container()),
        Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40)),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Column(
              children: [
                
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          context.pop();
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Color.fromARGB(255, 5, 68, 95),
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  'Olvidé mi contraseña',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: Colors.transparent),
                    ),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'Correo electrónico',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: const BorderSide(
                              color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: const BorderSide(
                              color: Colors.transparent),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: const BorderSide(
                              color: Colors.transparent),
                        ),
                      ),
                      onChanged: (value) => resetFormNotifier.onEmailChange(value),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomFilledButton(
                  text: 'Enviar código',
                  buttonColor: const Color.fromARGB(255, 51, 101, 138),
                  onPressed: () {
                    resetFormNotifier.onEmailSubmit();
                    FocusScope.of(context).unfocus();
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        Expanded(child: Container()),
      ],
    );
  }
}

class _WriteVerificationCode extends ConsumerWidget {

  const _WriteVerificationCode({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final resetFormNotifier = ref.watch(resetPasswordFormProvider.notifier);

    return Column(
      children: [
        Expanded(child: Container()),
        Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40)
            ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Column(
              children: [
                
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          context.pop();
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Color.fromARGB(255, 5, 68, 95),
                        ),
                      ),
                    ],
                  ),
                ),
        
                const Text(
                  'Código de verificación',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        
                const SizedBox(height: 10),
        
                const Text(
                  'Se envió un código de verificación a tu email',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w200,
                    overflow: TextOverflow.ellipsis
                  ),
                ),
                
                const SizedBox(height: 30),
        
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: Colors.transparent),
                    ),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'Código de verificación',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: const BorderSide(
                              color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: const BorderSide(
                              color: Colors.transparent),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: const BorderSide(
                              color: Colors.transparent),
                        ),
                      ),
                      onChanged: (value) => resetFormNotifier.onVerificationCodeChange(value),
                    ),
                  ),
                ),
                
                const SizedBox(height: 10),
                
                CustomFilledButton(
                  text: 'Enviar',
                  buttonColor: const Color.fromARGB(255, 51, 101, 138),
                  onPressed: () {
                    resetFormNotifier.onVericationCodeSubmit();
                    FocusScope.of(context).unfocus(); 
                  }  
                  
                ),
                
                const SizedBox(height: 20),
        
                TextButton(
                  onPressed: () {
                    ref.watch(resetPasswordFormProvider.notifier).emailWasNotSent();
                  },
                  style: TextButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                  ),
                  child: const Text(
                    'Volver',
                    style: TextStyle(
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(child: Container()),
      ],
    );
  }
}

class _WriteNewPassword extends ConsumerWidget {
  const _WriteNewPassword({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final resetFormNotifier = ref.watch(resetPasswordFormProvider.notifier);

    return Column(
      children: [
        Expanded(child: Container()),
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

        Expanded(child: Container()),
        
        const Text('La contraseña debe tener un mínimo de 8 caracteres',
            textAlign: TextAlign.center,
            style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w200,)),
      
        const SizedBox(height: 30),
        
        CustomTextFormFieldAuth(
          hint: 'Contraseña',
          obscureText: true,
          onChanged: (value) => resetFormNotifier.onFirstPasswordChange(value),
        ),

        const SizedBox(height: 15),
        
        CustomTextFormFieldAuth(
          hint: 'Contraseña',
          obscureText: true,
          onChanged: (value) => resetFormNotifier.onSecondPasswordChange(value),
        ),

        Expanded(child: Container()),
        
        CustomFilledButton(
          text: 'Enviar',
          buttonColor: const Color.fromARGB(255, 51, 101, 138),
          onPressed: () {
            resetFormNotifier.onPasswordSubmit();
            FocusScope.of(context).unfocus(); 

            if ( !ref.read(resetPasswordFormProvider).arePasswordsValid ){
              showSnackbar( context, 'Las contraseñas no son iguales', Colors.red );
            }
          },
        ),
        Expanded(child: Container()),
      ],
    );
  }
}
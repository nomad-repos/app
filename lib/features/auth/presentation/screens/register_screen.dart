import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_app/shared/shared.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(children: [
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
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      const CustomTextFormField(hint: 'Nombre'),
                      const SizedBox(height: 30),
                      const CustomTextFormField(hint: 'Apellido'),
                      const SizedBox(height: 30),
                      const CustomTextFormField(hint: 'Email'),
                      const SizedBox(height: 30),
                      const CustomTextFormField(
                        hint: 'Contraseña',
                        obscureText: true,
                      ),

                      
                      Expanded(child: Container()),
                      CustomFilledButton(
                          text: 'Unirme',
                          width: double.infinity,
                          onPressed: () {}),
                      Expanded(child: Container()),
                    ])))
      ]),
    );
  }
}

//Suerte con la pantalla. Acordate de poner el Scaffold y el SafeArea.

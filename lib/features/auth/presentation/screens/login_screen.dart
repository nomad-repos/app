import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_app/shared/shared.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/iniciarsesion.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.7),
              ),
            ),    
        
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
        
                    Expanded(child: Container()),
                    
                    const CustomTextFormField(
                      hint: 'Email',
                    ),
        
                    const SizedBox(height: 30),
        
                    const CustomTextFormField(
                      hint: 'Contraseña',
                      obscureText: true,
                    ),
        
                    TextButton(
                      onPressed: (){
                        context.push('/reset_password');
                      },
                      style: TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,  // Elimina el efecto de splash
                      ),
                      child: const Text(
                        '¿Olvidaste tu contraseña?', 
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300
                        )
                      ),
                    ),
        
                    Expanded(child: Container()),
        
                    CustomFilledButton(
                      text: 'Iniciar sesión', 
                      width: double.infinity,
                      buttonColor: Colors.deepOrange,
                      onPressed: (){}
                    ),
        
                    SizedBox(height: 20),
        
                    CustomFilledButton(
                      text: 'Registrarse',
                      width: double.infinity,
                      buttonColor: Colors.transparent,
                      onPressed: (){}
                    ),
        
                    TextButton(
                      onPressed: (){},
                      style: TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,  // Elimina el efecto de splash
                      ),
                      child: const Text(
                        'Continuar como invitado', 
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300
                        )
                      ),
                    ),
                    
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
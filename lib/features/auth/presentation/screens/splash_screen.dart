import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Configuramos el controlador de animación
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Duración de 3 segundos para la animación
      vsync: this,
    );

    // Configuramos una animación de opacidad
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Iniciar la animación
    _controller.forward();

    // Navegar a la siguiente pantalla después de 3 segundos
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        context.go('/login'); // Cambia a la ruta /login después de la animación
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF6600), // Fondo naranja
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation, // Opacidad animada
          child: const Text(
            'nomad.',
            style: TextStyle(
              fontSize: 50.0,
              fontFamily: 'ArchivoBlack',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}


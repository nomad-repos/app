import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_app/config/config.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Bloquea la orientación del dispositivo en vertical
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Carga las variables de entorno desde el archivo .env
  await dotenv.load(fileName: ".env");

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Utiliza el provider de gouter para la navegación
    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      theme: AppTheme().getTheme(), 
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'), // Define los locales soportados
      ],
      routerConfig: goRouter, // Configuración del router
      debugShowCheckedModeBanner: false, // Oculta el banner de modo debug
    );
  }
}
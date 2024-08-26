import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  ThemeData getTheme() => ThemeData(
      //Aca adentro van los temas personalizados de la aplicación.
      colorSchemeSeed: Colors.cyan.shade900,
      textTheme: GoogleFonts.nunitoTextTheme(),

    );
  }

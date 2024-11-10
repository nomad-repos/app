import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatTimeOfDay(TimeOfDay? time) {
  if (time == null) return "-";
  final now = DateTime.now();
  final date = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  return DateFormat('HH:mm').format(date);
}

String getMonthName(int month) {
    switch (month) {
      case 1: return 'Enero';
      case 2: return 'Febrero';
      case 3: return 'Marzo';
      case 4: return 'Abril';
      case 5: return 'Mayo';
      case 6: return 'Junio';
      case 7: return 'Julio';
      case 8: return 'Agosto';
      case 9: return 'Septiembre';
      case 10: return 'Octubre';
      case 11: return 'Noviembre';
      case 12: return 'Diciembre';
      default: return '';
    }
  }

  String getFormattedDate(DateTime? date ) {
    if (date == null) return '';
    switch (date.weekday) {
      case 1: return 'Lunes, ${date.day} de ${getMonthName(date.month)}';
      case 2: return 'Martes, ${date.day} de ${getMonthName(date.month)}';
      case 3: return 'Miércoles, ${date.day} de ${getMonthName(date.month)}';
      case 4: return 'Jueves, ${date.day} de ${getMonthName(date.month)}';
      case 5: return 'Viernes, ${date.day} de ${getMonthName(date.month)}';
      case 6: return 'Sábado, ${date.day} de ${getMonthName(date.month)}';
      case 7: return 'Domingo, ${date.day} de ${getMonthName(date.month)}';
      default: return '';
    }
  }


String extractTime(String datetimeStr) {
  // Parsear la cadena a un objeto DateTime
  DateTime datetime = DateFormat("yyyy-MM-dd HH:mm").parse(datetimeStr);

  // Formatear el objeto DateTime para extraer solo la hora
  String time = DateFormat("HH:mm:ss").format(datetime);

  return time;
}

String formatDateDateTime(DateTime date) {
  // Formatear la fecha al formato dd/MM/yyyy
  String formattedDate = DateFormat('yyyy-MM-dd').format(date);

  return formattedDate;
}

String formatDate(String date) {
  // Parsear la fecha desde el formato dd/MM/yyyy
  DateTime parsedDate = DateTime.parse(
      '${date.split('/')[2]}-${date.split('/')[1]}-${date.split('/')[0]}');
  
  // Convertir al formato yyyy-MM-dd
  String formattedDate = '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';
  
  return formattedDate;
}
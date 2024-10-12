import 'dart:io';

import 'package:nomad_app/shared/models/models.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class GetEventDataSource extends CalendarDataSource {
  GetEventDataSource(List<GetEvent> source) {
    for (GetEvent event in source) {
      DateTime date = HttpDate.parse(event.date);

      DateTime startTime = DateTime.parse("1970-01-01 ${event.startTime}"); 
      DateTime finishTime = DateTime.parse("1970-01-01 ${event.finishTime}");  

      // Combinamos la fecha con las horas de inicio y fin
      event.parsedStartTime = DateTime(date.year, date.month, date.day, startTime.hour, startTime.minute);
      event.parsedFinishTime = DateTime(date.year, date.month, date.day, finishTime.hour, finishTime.minute);
    }

    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].parsedStartTime;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].parsedFinishTime;
  }

  @override
  String getSubject(int index) {
    return appointments![index].title;
  }

  @override
  String getNotes(int index) {
    return appointments![index].eventDescription;
  }

  @override
  int getId(int index) {
    return appointments![index].eventId;
  }
}

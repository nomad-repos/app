  

import 'package:nomad_app/shared/models/models.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class GetEventDataSource extends CalendarDataSource {
  GetEventDataSource(List<Event> source) {

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

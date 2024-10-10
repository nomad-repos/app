import 'dart:convert';

import 'package:nomad_app/shared/models/activity.dart';

Event eventFromJson(String str) => Event.fromJson(json.decode(str));

String eventToJson(Event data) => json.encode(data.toJson());

class Event {
    String eventTitle;
    DateTime eventDate;
    DateTime eventStartTime;
    DateTime eventFinishTime;
    int tripId;
    Activity? activity;

    Event({
        required this.eventTitle,
        required this.eventDate,
        required this.eventStartTime,
        required this.eventFinishTime,
        required this.tripId,
        this.activity,
    });

    factory Event.fromJson(Map<String, dynamic> json) => Event(
        eventTitle: json["event_title"],
        eventDate: DateTime.parse(json["event_date"]),
        eventStartTime: DateTime.parse(json["event_start_time"]),
        eventFinishTime: DateTime.parse(json["event_finish_time"]),
        tripId: json["trip_id"],
    );

    Map<String, dynamic> toJson() => {
        "event_title": eventTitle,
        "event_date": eventDate.toIso8601String(),
        "event_start_time": eventStartTime.toIso8601String(),
        "event_finish_time": eventFinishTime.toIso8601String(),
        "trip_id": tripId,
    };

    set setActivity(Activity activity) {
      this.activity = activity;
    }

    Activity get getActivity {
      return activity!;
    }
}
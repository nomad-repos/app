// To parse this JSON data, do
//
//     final event = eventFromJson(jsonString);

import 'dart:convert';

import 'package:nomad_app/shared/models/activity.dart';

Event eventFromJson(String str) => Event.fromJson(json.decode(str));

String eventToJson(Event data) => json.encode(data.toJson());

class Event {
    final Activity? activity;
    final DateTime eventDate;
    final String eventDescription;
    final String eventFinishTime;
    final String eventStartTime;
    final String eventTitle;
    int? eventId;
    final int tripId;

    DateTime? parsedStartTime;
    DateTime? parsedFinishTime;

    Event({
        required this.activity,
        required this.eventDate,
        required this.eventDescription,
        required this.eventFinishTime,
        required this.eventStartTime,
        required this.eventTitle,
        required this.tripId,
        this.eventId,
    });

    factory Event.fromJson(Map<String, dynamic> json) => Event(
        activity: Activity.fromJson(json["activity"]),
        eventDate: DateTime.parse(json["event_date"]),
        eventDescription: json["event_description"],
        eventFinishTime: json["event_finish_time"],
        eventStartTime: json["event_start_time"],
        eventTitle: json["event_title"],
        eventId: json["event_id"],
        tripId: json["trip_id"],
    );

    Map<String, dynamic> toJson() => {
        "event_date": "${eventDate.year.toString().padLeft(4, '0')}-${eventDate.month.toString().padLeft(2, '0')}-${eventDate.day.toString().padLeft(2, '0')}",
        "event_description": eventDescription,
        "event_finish_time": eventFinishTime,
        "event_start_time": eventStartTime,
        "event_title": eventTitle,
        "trip_id": tripId,
    };

    set setParsedStartTime(DateTime parsedStartTime) {this.parsedStartTime = parsedStartTime;}
    DateTime get getParsedStartTime {return parsedStartTime!;}

    set setParsedFinishTime(DateTime parsedFinishTime) {this.parsedFinishTime = parsedFinishTime;}
    DateTime get getParsedFinishTime {return parsedFinishTime!;}
}

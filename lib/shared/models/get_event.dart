// To parse this JSON data, do
//
//     final getEvent = getEventFromJson(jsonString);

import 'dart:convert';

GetEvent getEventFromJson(String str) => GetEvent.fromJson(json.decode(str));

String getEventToJson(GetEvent data) => json.encode(data.toJson());

class GetEvent {
    final OwnActivity activity;
    final String date;
    final String eventDescription;
    final int eventId;
    final String finishTime;
    final String startTime;
    final String title;
    final int tripId;

    DateTime? parsedStartTime;
    DateTime? parsedFinishTime;

    GetEvent({
        required this.activity,
        required this.date,
        required this.eventDescription,
        required this.eventId,
        required this.finishTime,
        required this.startTime,
        required this.title,
        required this.tripId,

        this.parsedStartTime,
        this.parsedFinishTime,
    });

    factory GetEvent.fromJson(Map<String, dynamic> json) => GetEvent(
        activity: OwnActivity.fromJson(json["activity"]),
        date: json["date"],
        eventDescription: json["event_description"],
        eventId: json["event_id"],
        finishTime: json["finish_time"],
        startTime: json["start_time"],
        title: json["title"],
        tripId: json["trip_id"],
    );

    Map<String, dynamic> toJson() => {
        "activity": activity.toJson(),
        "date": date,
        "event_description": eventDescription,
        "event_id": eventId,
        "finish_time": finishTime,
        "start_time": startTime,
        "title": title,
        "trip_id": tripId,
    };

    set setParsedStartTime(DateTime parsedStartTime) {this.parsedStartTime = parsedStartTime;}
    DateTime get getParsedStartTime {return parsedStartTime!;}

    set setParsedFinishTime(DateTime parsedFinishTime) {this.parsedFinishTime = parsedFinishTime;}
    DateTime get getParsedFinishTime {return parsedFinishTime!;
  }
}

class OwnActivity {
    final String activityAdress;
    final String activityExtId;
    final int activityId;
    final double activityLatitude;
    final double activityLongitude;
    final String activityName;
    final String activityUrlPhoto;
    final int localityId;

    OwnActivity({
        required this.activityAdress,
        required this.activityExtId,
        required this.activityId,
        required this.activityLatitude,
        required this.activityLongitude,
        required this.activityName,
        required this.activityUrlPhoto,
        required this.localityId,
    });

    factory OwnActivity.fromJson(Map<String, dynamic> json) => OwnActivity(
        activityAdress: json["activity_adress"],
        activityExtId: json["activity_ext_id"],
        activityId: json["activity_id"],
        activityLatitude: double.parse(json["activity_latitude"].toString()),
        activityLongitude: double.parse(json["activity_longitude"].toString()),
        activityName: json["activity_name"],
        activityUrlPhoto: json["activity_url_photo"],
        localityId: json["locality_id"],
    );

    Map<String, dynamic> toJson() => {
        "activity_adress": activityAdress,
        "activity_ext_id": activityExtId,
        "activity_id": activityId,
        "activity_latitude": activityLatitude,
        "activity_longitude": activityLongitude,
        "activity_name": activityName,
        "activity_url_photo": activityUrlPhoto,
        "locality_id": localityId,
    };
}

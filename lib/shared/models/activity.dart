// To parse this JSON data, do
//
//     final activity = activityFromJson(jsonString);

import 'dart:convert';

Activity activityFromJson(String str) => Activity.fromJson(json.decode(str));

String activityToJson(Activity data) => json.encode(data.toJson());

class Activity {
    final String activityAddress;
    final String activityExtId;
    final int activityId;
    final double activityLatitude;
    final double activityLongitude;
    final String activityName;
    final String activityUrlPhoto;
    final int localityId;

    Activity({
        required this.activityAddress,
        required this.activityExtId,
        required this.activityId,
        required this.activityLatitude,
        required this.activityLongitude,
        required this.activityName,
        required this.activityUrlPhoto,
        required this.localityId,
    });

    factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        activityAddress: json["activity_address"],
        activityExtId: json["activity_ext_id"],
        activityId: json["activity_id"],
        activityLatitude: json["activity_latitude"]?.toDouble(),
        activityLongitude: json["activity_longitude"]?.toDouble(),
        activityName: json["activity_name"],
        activityUrlPhoto: json["activity_url_photo"],
        localityId: json["locality_id"],
    );

    Map<String, dynamic> toJson() => {
        "activity_address": activityAddress,
        "activity_ext_id": activityExtId,
        "activity_id": activityId,
        "activity_latitude": activityLatitude,
        "activity_longitude": activityLongitude,
        "activity_name": activityName,
        "activity_url_photo": activityUrlPhoto,
        "locality_id": localityId,
    };
}

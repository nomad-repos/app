// To parse this JSON data, do
//
//     final googleActivity = googleActivityFromJson(jsonString);

import 'dart:convert';

GoogleActivity googleActivityFromJson(String str) => GoogleActivity.fromJson(json.decode(str));

String googleActivityToJson(GoogleActivity data) => json.encode(data.toJson());

class GoogleActivity {
    final String activityAddress;
    final String activityExtId;
    final ActivityLocation activityLocation;
    final String activityName;
    final String activityPhotosUri;

    GoogleActivity({
        required this.activityAddress,
        required this.activityExtId,
        required this.activityLocation,
        required this.activityName,
        required this.activityPhotosUri,
    });

    factory GoogleActivity.fromJson(Map<String, dynamic> json) => GoogleActivity(
        activityAddress: json["activity_address"],
        activityExtId: json["activity_ext_id"],
        activityLocation: ActivityLocation.fromJson(json["activity_location"]),
        activityName: json["activity_name"],
        activityPhotosUri: json["activity_photos_uri"],
    );

    Map<String, dynamic> toJson() => {
        "activity_address": activityAddress,
        "activity_ext_id": activityExtId,
        "activity_location": activityLocation.toJson(),
        "activity_name": activityName,
        "activity_photos_uri": activityPhotosUri,
    };
}

class ActivityLocation {
    final double latitude;
    final double longitude;

    ActivityLocation({
        required this.latitude,
        required this.longitude,
    });

    factory ActivityLocation.fromJson(Map<String, dynamic> json) => ActivityLocation(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
    };
}

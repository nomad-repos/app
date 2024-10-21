import 'dart:convert';

Activity acivityFromJson(String str) => Activity.fromJson(json.decode(str));

String acivityToJson(Activity data) => json.encode(data.toJson());

class Activity {
    String activityAddress;
    String activityExtId;
    String activityName;
    String activityPhotosUri;
    double activityLatitude;
    double activityLongitude;

    Activity({
        required this.activityAddress,
        required this.activityExtId,
        required this.activityName,
        required this.activityPhotosUri,
        required this.activityLatitude,
        required this.activityLongitude,
    });

    factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        activityAddress: json["activity_address"],
        activityExtId: json["activity_ext_id"],
        activityLongitude: json["activity_longitude"],
        activityLatitude: json["activity_latitude"],
        activityName: json["activity_name"],
        activityPhotosUri: json["activity_url_photo"],
    );

    Map<String, dynamic> toJson() => {
        "activity_address": activityAddress,
        "activity_ext_id": activityExtId,
        "activity_latitude": activityLatitude,
        "activity_longitude": activityLongitude,
        "activity_name": activityName,
        "activity_url_photo": activityPhotosUri,
    };
}

class ActivityLocation {
    double latitude;
    double longitude;

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

import 'dart:convert';

Activity acivityFromJson(String str) => Activity.fromJson(json.decode(str));

String acivityToJson(Activity data) => json.encode(data.toJson());

class Activity {
    String activityAddress;
    String activityExtId;
    ActivityLocation activityLocation;
    String activityName;
    String activityPhotosUri;

    Activity({
        required this.activityAddress,
        required this.activityExtId,
        required this.activityLocation,
        required this.activityName,
        required this.activityPhotosUri,
    });

    factory Activity.fromJson(Map<String, dynamic> json) => Activity(
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

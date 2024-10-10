
import 'dart:convert';

Activity activityFromJson(String str) => Activity.fromJson(json.decode(str));

String activityToJson(Activity data) => json.encode(data.toJson());

class Activity {
    String activityTitle;
    double activityLatitude;
    double activityLongitude;
    String? activityPhotoUrl;
    int localityId;
    int categoryId;

    Activity({
        required this.activityTitle,
        required this.activityLatitude,
        required this.activityLongitude,
        this.activityPhotoUrl,
        required this.localityId,
        required this.categoryId,
    });

    factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        activityTitle: json["activity_title"],
        activityLatitude: json["activity_latitude"]?.toDouble(),
        activityLongitude: json["activity_longitude"]?.toDouble(),
        activityPhotoUrl: json["activity_photo_url"],
        localityId: json["locality_id"],
        categoryId: json["category_id"],
    );

    Map<String, dynamic> toJson() => {
        "activity_title": activityTitle,
        "activity_latitude": activityLatitude,
        "activity_longitude": activityLongitude,
        "activity_photo_url": activityPhotoUrl,
        "locality_id": localityId,
        "category_id": categoryId,
    };
}

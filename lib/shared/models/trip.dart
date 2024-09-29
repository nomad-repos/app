// To parse this JSON data, do
//
//     final trip = tripFromJson(jsonString);

import 'dart:convert';

Trip tripFromJson(String str) => Trip.fromJson(json.decode(str));

String tripToJson(Trip data) => json.encode(data.toJson());

class Trip {
    int tripId;
    String photoUrl;
    String tripFinishDate;
    String tripName;
    String tripStartDate;
    String tripState;

    Trip({
        required this.tripId,
        required this.photoUrl,
        required this.tripFinishDate,
        required this.tripName,
        required this.tripStartDate,
        required this.tripState,
    });

    factory Trip.fromJson(Map<String, dynamic> json) => Trip(
        tripId: json["trip_id"],
        photoUrl: json["photo_url"],
        tripFinishDate: json["trip_finish_date"],
        tripName: json["trip_name"],
        tripStartDate: json["trip_start_date"],
        tripState: json["trip_state"],
    );

    Map<String, dynamic> toJson() => {
        "trip_id": tripId,
        "photo_url": photoUrl,
        "trip_finish_date": tripFinishDate,
        "trip_name": tripName,
        "trip_start_date": tripStartDate,
        "trip_state": tripState,
    };
}

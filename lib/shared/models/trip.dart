import 'dart:convert';

Trip tripFromJson(String str) => Trip.fromJson(json.decode(str));

String tripToJson(Trip data) => json.encode(data.toJson());

class Trip {
    String tripName;
    int tripId;
    int destination;
    String state;

    Trip({
        required this.tripName,
        required this.tripId,
        required this.destination,
        required this.state,
    });

    factory Trip.fromJson(Map<String, dynamic> json) => Trip(
        tripName: json["trip_name"],
        tripId: json["trip_id"],
        destination: json["destination"],
        state: json["state"],
    );

    Map<String, dynamic> toJson() => {
        "trip_name": tripName,
        "trip_id": tripId,
        "destination": destination,
        "state": state,
    };
}
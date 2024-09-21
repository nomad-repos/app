import 'dart:convert';

Location locationFromJson(String str) => Location.fromJson(json.decode(str));

String locationToJson(Location data) => json.encode(data.toJson());

class Location {
  String localityName;
  double latitude;
  double longitude;
  String isoCode;
  String localityId;

  Location({
    required this.localityName,
    required this.latitude,
    required this.longitude,
    required this.isoCode,
    required this.localityId
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        localityName: json["locality_name"],
        latitude: (json["locality_latitude"] is String)
            ? double.parse(json["locality_latitude"])
            : json["locality_latitude"],
        longitude: (json["locality_longitude"] is String)
            ? double.parse(json["locality_longitude"])
            : json["locality_longitude"],
        isoCode: json["iso_code"],
        localityId: json["locality_id"],
      );

  Map<String, dynamic> toJson() => {
        "locality_name": localityName,
        "locality_latitude": latitude,
        "longitude": longitude,
        "iso_code": isoCode,
        "locality_id": localityId
      };

  @override
  String toString() {
    return localityName;
  }
}

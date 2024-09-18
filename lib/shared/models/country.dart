
import 'dart:convert';

Country countryFromJson(String str) => Country.fromJson(json.decode(str));

String countryToJson(Country data) => json.encode(data.toJson());

class Country {
    String isoCode;
    String countryName;

    Country({
        required this.isoCode,
        required this.countryName,
    });

    factory Country.fromJson(Map<String, dynamic> json) => Country(
        isoCode: json["country_iso_code"],
        countryName: json["country_name"],
    );

    Map<String, dynamic> toJson() => {
        "country_iso_code": isoCode,
        "country_name": countryName,
    };

  @override
  String toString() => countryName;
}


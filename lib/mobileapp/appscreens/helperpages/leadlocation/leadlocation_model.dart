// To parse this JSON data, do
//
//     final leadLocations = leadLocationsFromJson(jsonString);

import 'dart:convert';

List<LeadLocations> leadLocationsFromJson(String str) =>
    List<LeadLocations>.from(
        json.decode(str).map((x) => LeadLocations.fromJson(x)));

String leadLocationsToJson(List<LeadLocations> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LeadLocations {
  LeadLocations({
    this.country = '',
    this.state = '',
    this.city = '',
  });

  String? country;
  String? state;
  String? city;

  factory LeadLocations.fromJson(Map<String, dynamic> json) => LeadLocations(
        country: json["Country"],
        state: json["State"],
        city: json["City"],
      );

  Map<String, dynamic> toJson() => {
        "Country": country,
        "State": state,
        "City": city,
      };
}

// To parse this JSON data, do
//
//     final locationModel = locationModelFromJson(jsonString);

import 'dart:convert';

LocationModel locationModelFromJson(String str) => LocationModel.fromJson(json.decode(str));

String locationModelToJson(LocationModel data) => json.encode(data.toJson());

class LocationModel {
  List<Address> addresses;

  LocationModel({
    required this.addresses,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
    addresses: List<Address>.from(json["addresses"].map((x) => Address.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "addresses": List<dynamic>.from(addresses.map((x) => x.toJson())),
  };
}

class Address {
  String address;
  double latitude;
  double longitude;

  Address({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    address: json["address"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
  };
}

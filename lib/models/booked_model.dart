// To parse this JSON data, do
//
//     final bookedCarModel = bookedCarModelFromJson(jsonString);

import 'dart:convert';

List<BookedCarModel> bookedCarModelFromJson(String str) => List<BookedCarModel>.from(json.decode(str).map((x) => BookedCarModel.fromJson(x)));

String bookedCarModelToJson(List<BookedCarModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BookedCarModel {
  String carName;
  String carImage;
  String rent;
  String pickAddress;
  String dropAddress;
  String distance;
  DateTime bookDate;

  BookedCarModel({
    required this.carName,
    required this.carImage,
    required this.rent,
    required this.pickAddress,
    required this.dropAddress,
    required this.distance,
    required this.bookDate,
  });

  factory BookedCarModel.fromJson(Map<String, dynamic> json) => BookedCarModel(
    carName: json["carName"],
    carImage: json["carImage"],
    rent: json["rent"],
    pickAddress: json["pickAddress"],
    dropAddress: json["dropAddress"],
    distance: json["distance"],
    bookDate: DateTime.parse(json["bookDate"]),
  );

  Map<String, dynamic> toJson() => {
    "carName": carName,
    "carImage": carImage,
    "rent": rent,
    "pickAddress": pickAddress,
    "dropAddress": dropAddress,
    "distance": distance,
    "bookDate": bookDate.toIso8601String(),
  };
}

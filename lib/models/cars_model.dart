// To parse this JSON data, do
//
//     final carsModel = carsModelFromJson(jsonString);

import 'dart:convert';

CarsModel carsModelFromJson(String str) => CarsModel.fromJson(json.decode(str));

String carsModelToJson(CarsModel data) => json.encode(data.toJson());

class CarsModel {
  List<Car> cars;

  CarsModel({
    required this.cars,
  });

  factory CarsModel.fromJson(Map<String, dynamic> json) => CarsModel(
    cars: List<Car>.from(json["cars"].map((x) => Car.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "cars": List<dynamic>.from(cars.map((x) => x.toJson())),
  };
}

class Car {
  String carName;
  String carImage;
  String carRent;
  bool isFavorite;

  Car({
    required this.carName,
    required this.carImage,
    required this.carRent,
    required this.isFavorite,
  });

  factory Car.fromJson(Map<String, dynamic> json) => Car(
    carName: json["carName"],
    carImage: json["carImage"],
    carRent: json["carRent"],
    isFavorite: json["isFavorite"],
  );

  Map<String, dynamic> toJson() => {
    "carName": carName,
    "carImage": carImage,
    "carRent": carRent,
    "isFavorite": isFavorite,
  };
}

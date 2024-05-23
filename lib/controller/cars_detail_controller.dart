import 'dart:convert';

import 'package:car_app/models/cars_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CarsDetailController extends GetxController {




  List<Car> cars = [];
  RxBool loading = false.obs;

  getCarDetails() async {
    loading.value = true;
   final String jsonData = await rootBundle.loadString("assets/json/cars_details.json");
   var data = json.decode(jsonData);

   List<dynamic> carsList = data['cars'];

   cars = carsList.map((items) => Car.fromJson(items)).toList();

   print(cars.toString());

   loading.value = false;
  }




}
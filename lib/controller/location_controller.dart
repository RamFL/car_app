import 'dart:convert';
import 'dart:developer';

import 'package:car_app/models/location_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LocationController extends GetxController {
  List<Address> addressList = [];

  getLocation() async {
    final String jsonData =
        await rootBundle.loadString("assets/json/address.json");
    var data = json.decode(jsonData);

    List<dynamic> locationList = data['addresses'];

    addressList = locationList.map((item) => Address.fromJson(item)).toList();

    print(addressList.toString());
    print(addressList[0].address);
  }

  var distance = ''.obs;
  RxBool loading1 = false.obs;
  getDistance(
      String pickLat, String pickLng, String dropLat, String dropLng) async {
    log("Distance fetching start......");
    // loading1.value = true;

    try {
      String makeUrl =
          "https://router.project-osrm.org/route/v1/driving/$pickLng,$pickLat;$dropLng,$dropLat?overview=false";
      var url = Uri.parse(makeUrl);
      log(url.toString());

      var response = await http.get(url);

      if (response.statusCode == 200) {
        log("Distance fetching status code 200........");

        var jsonData = jsonDecode(response.body);
        log(jsonData.toString());

        if (jsonData['code'] == "Ok") {
          double dis = jsonData['routes'][0]['distance'] / 1000;
          distance.value = dis.toStringAsFixed(2);
          print("Distance: ${distance.value}");
        }
        // loading1.value = false;
      } else {
        // loading1.value = false;
        Get.snackbar(
          'Error',
          'Unknown error occur distance fetching',
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.black54,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      // loading1.value = false;
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: const Text('Error'),
              contentPadding: const EdgeInsets.all(20),
              children: [Text(e.toString())],
            );
          });
      throw e.toString();
    }
  }
}

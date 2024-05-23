import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/booked_model.dart';

class BookedCarsScreen extends StatefulWidget {
  const BookedCarsScreen({super.key});

  @override
  State<BookedCarsScreen> createState() => _BookedCarsScreenState();
}

class _BookedCarsScreenState extends State<BookedCarsScreen> {

  List<BookedCarModel> bookedCars = [];


  late SharedPreferences sp;

  getSharedPrefrences() async {
    sp = await SharedPreferences.getInstance();
    readFromSp();
  }

  readFromSp() {
    //
    List<String>? carListString = sp.getStringList('bookedCars');
    if (carListString != null) {
      bookedCars = carListString
          .map((car) => BookedCarModel.fromJson(json.decode(car)))
          .toList();
    }
    setState(() {});

    print(bookedCars.length);
    //
  }

  @override
  void initState() {
    getSharedPrefrences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booking Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
      ),
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: ListView.builder(

          itemCount: bookedCars.length,
          itemBuilder: (context, index) {

            var data = bookedCars.reversed.toList()[index];


            return Container(
              width: Get.width,
              height: Get.height * 0.38,
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              decoration: BoxDecoration(
                // color: Colors.red,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 2
                  ),
                ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(data.carName.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),),
                      Text(DateFormat('hh:mm a, dd/MM/yyyy').format(data.bookDate).toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,),),
                    ],
                  ),
                  Center(
                    child: SizedBox(
                      height: Get.height * 0.15,
                      width: Get.width * 0.5,
                      child: Image.asset(data.carImage.toString(), fit: BoxFit.fill,),
                    ),
                  ),
                  Text("Distance(KM): ${data.distance.toString()}.", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,),),
                  SizedBox(height: 5),
                  Text("Pick Address: ${data.pickAddress.toString()}.", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,),),
                  SizedBox(height: 5),
                  Text("Drop Address: ${data.dropAddress.toString()}.", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,),),

                ],
              ),
            );
          },),
      ),
    );
  }
}

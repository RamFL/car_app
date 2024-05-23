import 'package:car_app/booked_car_screen.dart';
import 'package:car_app/car_details_screen.dart';
import 'package:car_app/constant.dart';
import 'package:car_app/controller/cars_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  CarsDetailController carController = Get.put(CarsDetailController());

  @override
  void initState() {
    carController.getCarDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.location_on_outlined), // Your icon here
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.bookmark_added, size: 30,), // Your icon here
            onPressed: () {
              Get.to(() => BookedCarsScreen());
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle_sharp, size: 30,), // Your icon here
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Brands",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              brandLogos(),
              SizedBox(height: 15),
              Text(
                "Available Cars Near You",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              carsNearYou(),
              SizedBox(height: 15),
              Text(
                "Promo",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              promo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget brandLogos() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: logos.length,
          itemBuilder: (context, index) {
            return Container(
              // height: 50,
              width: 60,
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54.withOpacity(0.1),
                    spreadRadius: 3,
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Image.asset(logos[index].toString()),
              ),
            );
          }),
    );
  }

  Widget carsNearYou() {
    return SizedBox(
      width: Get.width,
      height: Get.height * 0.3,
      child: Obx(
        () => carController.loading.value
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.black54,
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: carController.cars.length,
                itemBuilder: (context, index) {
                  var data = carController.cars[index];

                  return InkWell(
                    onTap: () {
                      Get.to(() => CarDetailsScreen(data: data));
                    },
                    child: Container(
                      // height: 50,
                      width: Get.width * 0.5,
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(15),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.black54.withOpacity(0.1),
                        //     spreadRadius: 3,
                        //     blurRadius: 2,
                        //   ),
                        // ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data.carName.toString(),
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black54.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  data.isFavorite == false
                                      ? Icons.favorite_border_outlined
                                      : Icons.favorite,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Image.asset(data.carImage.toString()),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "\$${data.carRent.toString()}/day",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.star,
                                size: 16,
                              ),
                              Text(
                                "4.9",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
      ),
    );
  }

  Widget promo() {
    return Obx(
      () => carController.loading.value
          ? SizedBox(
              height: Get.height * 0.3,
              width: Get.width,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: carController.cars.length,
              itemBuilder: (context, index) {

                var data = carController.cars[index];

                return InkWell(
                  onTap: () {
                    Get.to(() => CarDetailsScreen(data: data));
                  },
                  child: Container(
                    height: Get.height * 0.22,
                    width: Get.width,
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(15),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.black54.withOpacity(0.1),
                      //     spreadRadius: 3,
                      //     blurRadius: 2,
                      //   ),
                      // ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(data.carImage.toString()),
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.black54.withOpacity(0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    data.isFavorite == false ? Icons.favorite_border_outlined : Icons.favorite,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data.carName.toString(),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "\$${data.carRent.toString()}/day",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}

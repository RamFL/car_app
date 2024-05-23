import 'dart:convert';

import 'package:car_app/booked_car_screen.dart';
import 'package:car_app/controller/location_controller.dart';
import 'package:car_app/models/cars_model.dart';
import 'package:car_app/models/location_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/booked_model.dart';

class CarDetailsScreen extends StatefulWidget {
  final Car data;
  const CarDetailsScreen({super.key, required this.data});

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  LocationController lController = Get.put(LocationController());
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<BookedCarModel> bookedCars = [];


  late SharedPreferences sp;

  getSharedPrefrences() async {
    sp = await SharedPreferences.getInstance();
    readFromSp();
  }

  saveIntoSp() {
    //
    List<String> carListString =
    bookedCars.map((car) => jsonEncode(car.toJson())).toList();
    sp.setStringList('bookedCars', carListString);
    //
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
    lController.getLocation();
    getSharedPrefrences();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          widget.data.carName.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        actions: [
          Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              color: Colors.black54.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.data.isFavorite == false
                  ? Icons.favorite_border_outlined
                  : Icons.favorite,
              size: 20,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      pickUpLocation2(),
                      SizedBox(height: 10),
                      dropLocation(),
                      SizedBox(height: 8),
                      Obx(
                        () => lController.distance.isNotEmpty
                            ? Text(
                                "Distance: ${lController.distance.value.toString()} km",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: Get.width,
                height: Get.height * 0.3,
                child: Image.asset(widget.data.carImage),
              ),
              // pickUpLocation(),
              SizedBox(height: Get.height * 0.25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                      text: TextSpan(
                    children: [
                      TextSpan(
                          text: "\$${widget.data.carRent}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                      TextSpan(
                          text: "/day",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  )),
                  rentNowButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget rentNowButton() {
    return InkWell(
      onTap: () async {
        if (formKey.currentState!.validate()){
          final prefs = await SharedPreferences.getInstance();
          var val = prefs.getString("name");
          print("User ID: $val");

          if (val != null) {

            setState(() {
              pickController.text = "";
              dropController.text = "";
              bookedCars.add(BookedCarModel(
                carName: widget.data.carName,
                carImage: widget.data.carImage,
                rent: widget.data.carRent,
                pickAddress: pickAddress.toString(),
                dropAddress: dropAddress.toString(),
                distance: lController.distance.value,
                bookDate: DateTime.now(),
              ));

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return BookingStatusDialog();
                },
              );

              saveIntoSp();

            });
            readFromSp();
            print("Car booked");
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return MyDialog();
              },
            );
          }
        }

      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 10.h),
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(8)),
        child: Text(
          "Rent Now",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget pickUpLocation() {
    return Autocomplete<Address>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        return lController.addressList.where((Address item) => item.address
            .toLowerCase()
            .contains(textEditingValue.text.toLowerCase()));
      },
      fieldViewBuilder: (BuildContext context, TextEditingController controller,
          FocusNode focusNode, VoidCallback onFieldSubmitted) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: Get.width,
            child: TextFormField(
              controller: controller,
              focusNode: focusNode,
              onFieldSubmitted: (String value) {
                // csController.specialtyValue.value = value;
                onFieldSubmitted();
                // print(csController.specialtyValue.value);
              },
              validator: (input) {
                if (input!.isEmpty) {
                  return 'PickUp location should not be empty';
                }
              },
              decoration: InputDecoration(
                hintText: "Search pickup location",
                fillColor: Colors.grey.shade300,
                filled: true,
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                suffixIcon: Icon(Icons.add_location_alt_rounded),
                // border: InputBorder.none,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.transparent),
                ),

                // enabledBorder: OutlineInputBorder(
                //     borderRadius: BorderRadius.circular(5),
                //     borderSide: BorderSide(
                //       color: Colors.black,
                //     )),
                // border: OutlineInputBorder(
                //     borderRadius: BorderRadius.circular(5),
                //     borderSide: BorderSide(color: Colors.transparent)),
                // focusedBorder: OutlineInputBorder(
                //     borderRadius: BorderRadius.circular(5),
                //     borderSide: BorderSide(color: Colors.black)),
                // helperStyle: TextStyle(color:, fontSize: 5),
                hintStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        );
      },
      onSelected: (Address address) {
        // addController.text = address.address;
        setState(() {});
        print("Address: ${address.address}");
      },
      optionsViewBuilder: (
        BuildContext context,
        AutocompleteOnSelected<Address> onSelected,
        Iterable<Address> options,
      ) {
        return Align(
          alignment: Alignment.topCenter,
          child: Material(
            elevation: 4.0,
            color: Colors.blueGrey.shade50,
            child: SizedBox(
              height: Get.width * 0.5,
              width: Get.width,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final Address data = options.elementAt(index);

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: GestureDetector(
                        onTap: () {
                          onSelected(data);
                          // setState(() {});
                          // csController.specialtyValue.value = option;
                          // onSelected(option);
                          // print(csController.specialtyValue.value);
                        },
                        child: Text(options.elementAt(index).address,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ))),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  TextEditingController pickController = TextEditingController();
  TextEditingController dropController = TextEditingController();

  double? pickLat;
  double? pickLang;
  double? dropLat;
  double? dropLang;
  String? pickAddress;
  String? dropAddress;

  Widget pickUpLocation2() {
    return TypeAheadField(
      itemBuilder: (context, item) {
        return Align(
          alignment: Alignment.topCenter,
          child: ListTile(
            onTap: () {
              pickController.text = item.address;
              pickAddress = pickController.text;
              pickLat = item.latitude;
              pickLang = item.longitude;
              print("$pickAddress, $pickLat, $pickLang");
            },
            title: Text(item.address),
          ),
        );
      },
      controller: pickController,
      onSelected: (value) {
        // pickController.text = value.address;
        // print("${value.latitude}, ${value.longitude}");
      },
      suggestionsCallback: (value) {
        return lController.addressList.where((ele) {
          return ele.address.toLowerCase().startsWith(value.toLowerCase());
        }).toList();
      },
      builder: (context, controller, focusNode) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            child: TextFormField(
              controller: controller,
              focusNode: focusNode,
              validator: (input) {
                if (input!.isEmpty) {
                  return 'PickUp location should not be empty';
                }
              },
              decoration: InputDecoration(
                hintText: "Search pickup location",
                fillColor: Colors.grey.shade300,
                filled: true,
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                suffixIcon: Icon(Icons.my_location_outlined),
                // border: InputBorder.none,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.transparent),
                ),

                // enabledBorder: OutlineInputBorder(
                //     borderRadius: BorderRadius.circular(5),
                //     borderSide: BorderSide(
                //       color: Colors.black,
                //     )),
                // border: OutlineInputBorder(
                //     borderRadius: BorderRadius.circular(5),
                //     borderSide: BorderSide(color: Colors.transparent)),
                // focusedBorder: OutlineInputBorder(
                //     borderRadius: BorderRadius.circular(5),
                //     borderSide: BorderSide(color: Colors.black)),
                // helperStyle: TextStyle(color:, fontSize: 5),
                hintStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget dropLocation() {
    return TypeAheadField(
      itemBuilder: (context, item) {
        return Align(
          alignment: Alignment.topCenter,
          child: ListTile(
            onTap: () {
              dropController.text = item.address;
              dropAddress = dropController.text;
              dropLat = item.latitude;
              dropLang = item.longitude;
              print("$dropAddress, $dropLat, $dropLang");

              if (formKey.currentState!.validate()) {
                // showDialog(
                //   context: context,
                //   barrierDismissible: false,
                //   builder: (context) {
                //     return Container(
                //       color: Colors.transparent,
                //       child: const Center(
                //         child: CircularProgressIndicator(
                //           color: Colors.white,
                //         ),
                //       ),
                //     );
                //   },
                // );
                lController.getDistance(
                  pickLat.toString(),
                  pickLang.toString(),
                  dropLat.toString(),
                  dropLang.toString(),
                );
              }
            },
            title: Text(item.address),
          ),
        );
      },
      controller: dropController,
      onSelected: (value) {
        // pickController.text = value.address;
        // print("${value.latitude}, ${value.longitude}");
      },
      suggestionsCallback: (value) {
        return lController.addressList.where((ele) {
          return ele.address.toLowerCase().startsWith(value.toLowerCase());
        }).toList();
      },
      builder: (context, controller, focusNode) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            child: TextFormField(
              controller: controller,
              focusNode: focusNode,
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Drop location should not be empty';
                }
              },
              decoration: InputDecoration(
                hintText: "Search drop location",
                fillColor: Colors.grey.shade300,
                filled: true,
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                suffixIcon: Icon(Icons.pin_drop_sharp),
                // border: InputBorder.none,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.transparent),
                ),

                // enabledBorder: OutlineInputBorder(
                //     borderRadius: BorderRadius.circular(5),
                //     borderSide: BorderSide(
                //       color: Colors.black,
                //     )),
                // border: OutlineInputBorder(
                //     borderRadius: BorderRadius.circular(5),
                //     borderSide: BorderSide(color: Colors.transparent)),
                // focusedBorder: OutlineInputBorder(
                //     borderRadius: BorderRadius.circular(5),
                //     borderSide: BorderSide(color: Colors.black)),
                // helperStyle: TextStyle(color:, fontSize: 5),
                hintStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class MyDialog extends StatefulWidget {
  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Enter your details',
        style: TextStyle(fontSize: 18),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                fillColor: Colors.grey.shade300,
                filled: true,
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                fillColor: Colors.grey.shade300,
                filled: true,
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                fillColor: Colors.grey.shade300,
                filled: true,
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final pref = await SharedPreferences.getInstance();

              pref.setString("name", _nameController.text.trim());
              pref.setString("phNumber", _phoneController.text.trim());
              pref.setString("email", _emailController.text.trim());

              // Process data
              print('Name: ${pref.getString("name")}');
              print('Phone: ${pref.getString("phNumber")}');
              print('Email: ${pref.getString("email")}');
              Navigator.of(context).pop();
            }
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}

class BookingStatusDialog extends StatefulWidget {
  @override
  State<BookingStatusDialog> createState() => _BookingStatusDialogState();
}

class _BookingStatusDialogState extends State<BookingStatusDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text('Booking Successful', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 50,
          ),
          SizedBox(height: 20),
          Text(
            'Your booking has been confirmed successfully!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Get.to(() => BookedCarsScreen());
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}

import 'package:car_app/firstpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Image.asset("assets/images/logo.png"),
            SizedBox(height: 60),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Luxary Car Rental In New York.",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 38,
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Rent a Car online Today & Enjoy the Best Deals,Rates & Accessories ",
                style: TextStyle(
                  color: Colors.white60,
                  //fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            // SizedBox(height: 20),
            Spacer(),
            // ElevatedButton(onPressed: () {},
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            //       child: Text('Let\'s Go!', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500,),),
            //     ),
            //   style: ElevatedButton.styleFrom(
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8.0),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffFFFFFF),
                  minimumSize: const Size.fromHeight(45),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12), // <-- Radius
                  ),
                ),
                onPressed: () {
                  Get.offAll(() => FirstPage());

                },
                child: Text(
                  "Let's Go!   >>>",
                  style:
                  TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
            SizedBox(height: 20),




          ],
        ),
      ),

    );
  }
}

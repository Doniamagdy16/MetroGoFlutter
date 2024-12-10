import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:metrof/start_page.dart';

import 'gas_calc.dart';
import 'location_page.dart';

class Home_Page extends StatelessWidget {
  const Home_Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("GoRide",style: TextStyle(color: Colors.teal),),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            ElevatedButton(onPressed: (){
              Get.to(Start_Page());
            }, child: Text("Metro Stations"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.teal),
              ),
            ),
            //Gas cals
            SizedBox(height: 10,),

            ElevatedButton(onPressed: (){
              Get.to(Location_page());
            }, child: Text("get nearest station"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.teal),
              ),
            ),
            //Gas cals
            SizedBox(height: 10,),
            ElevatedButton(onPressed: (){Get.to(Gas_calc());},
              child: Text("Gas calc"),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.teal)
              ),

            ),
          ],
        ),
      ),

    );
  }
}

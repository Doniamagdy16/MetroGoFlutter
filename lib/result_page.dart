import 'dart:io';
import 'package:flutter/material.dart';
//import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'functions.dart';
class Result_Page extends StatelessWidget {
  Result_Page({super.key});
  // FlutterTts flutterTts = FlutterTts();
  // Future<void> speak() async {
  //   flutterTts.setSpeechRate(0.5);
  //   flutterTts.setVolume(1.0);
  //   flutterTts.setPitch(1.0);
  //   await flutterTts.speak("hello");
  // }


  @override
  Widget build(BuildContext context) {
    final data = Get.arguments as Map;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Metro Stations",style: TextStyle(color: Colors.teal),),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body:
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("The route form ${data['start']} to ${data['end']}",
              style: TextStyle(fontSize: 25),),
            SizedBox(height: 20,),
            Expanded(
              child: ListView.builder(
                  itemCount: data['data'].length,
                  itemBuilder: (context,index) {
                    return ListTile(
                      title: Column(
                        children: [
                          Text("${data['data'][index]}",
                            style: const TextStyle(fontSize: 20),),
                          Divider(
                            color: Colors.deepPurple,
                            thickness: 1,
                            height: 1,
                          ),
                          SizedBox(height: 8,),

                        ],

                      ),
                   //   trailing: IconButton(onPressed: speak, icon: Icon(Icons.surround_sound_rounded)),

                    );

                  }
              ),
            ),

          ],
        ),
      ),

    );
  }
}
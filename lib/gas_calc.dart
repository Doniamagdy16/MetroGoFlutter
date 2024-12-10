import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:metrof/station.dart';

class Gas_calc extends StatefulWidget {
  Gas_calc({super.key});

  @override
  State<Gas_calc> createState() => _Gas_calcState();
}

class _Gas_calcState extends State<Gas_calc> {
  final places=<String>[].obs;
  final original_places=<String>[];
  String current_location="";

  final visited=<String>[].obs;

  final all_lat_long=<Station>[].obs;

  final stations=<Station>[].obs;

  final same_distance=0.0.obs;

  final best_distance=0.0.obs;

  final same_coast1=0.0.obs;

  final best_coast=0.0.obs;

  final entered_controller=TextEditingController();

  final place="".obs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchLocation();
  }
  Future<String?> get_location() async{
    //get current location
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar("error", "wrong location");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar("error",'Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
          "error",'Location permissions are permanently denied, we cannot request permissions.');
    }
    final position=await Geolocator.getCurrentPosition();
    final addresses =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    var area = addresses.first.subAdministrativeArea;
    return area;
  }
  void fetchLocation() async {
    String?location = await get_location();
    location!=null?current_location=location:current_location="";
    entered_controller.text=current_location;
  }

  @override
  Widget build(BuildContext context) {
    original_places.clear();
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Gas Calc"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
     body: SingleChildScrollView(
       scrollDirection: Axis.vertical,
       child: Column(
         children: [
           Padding(
             padding: const EdgeInsets.all(20),
             child: TextField(decoration: InputDecoration(
               hintText: "Enter place here",
               border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
             controller: entered_controller,

             ),
           ),
           SizedBox(
             height: 20,
           ),
           Padding(
             padding: const EdgeInsets.all(12.0),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 ElevatedButton.icon(onPressed: (){
                   place.value=entered_controller.text;
                   same_distance.value=0;
                   best_distance.value=0;
                   if(place.value==""){
                     Get.snackbar('Gas cal', "please enter valid place");

                   }
                   if(places.contains(place.value)){
                     Get.snackbar('Gas cal', "this place entered before");
                   }
                   else{
                     places.add(place.value);
                     original_places.add(place.value);
                     entered_controller.clear();
                      }

                 }, icon: Icon(Icons.add), label:Text( "add place"),
                 style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.teal)
                 )
                   ,),
                 Obx(() {
                   return ElevatedButton.icon(onPressed:places.length>=1||same_distance.value!=0||best_distance.value!=0? (){
                     places.clear();
                     same_distance.value=0;
                     best_distance.value=0;
                     }:null, icon: Icon(Icons.clear), label: Text("clear"),
                       style: ButtonStyle(backgroundColor:places.length>=1||same_distance.value!=0||best_distance.value!=0?
                       MaterialStateProperty.all(Colors.teal):
                       MaterialStateProperty.all(Colors.grey[200])
                       )
                   );
                 })

               ],
             ),
           ),
           SizedBox(
             height: 20,
           ),
           Obx(() {
             return  ElevatedButton(onPressed:places.length>=2? (){

               get_cal(places);


               //places.clear();

             }:null, child: Text("get result"),
               style: ButtonStyle(
                   backgroundColor:places.length>=2? MaterialStateProperty.all(Colors.teal)
                       :MaterialStateProperty.all(Colors.grey[200])

               ),);
           }),

           SizedBox(
             height: 20,
           ),
           Obx(() => Column(
             children:
             places.map((place) => Text("${place}")).toList(),
           )
           ),
           Padding(
             padding: const EdgeInsets.all(10.0),
             child: Obx(() {
               return same_distance.value!=0&&best_distance.value!=0?
                 same_distance.value==best_distance.value?Text(
                 "the routes are $original_places\n distance is in range from   ${(same_distance.value/2).toInt()} to ${(same_distance.value).toInt()} km \ncost is in range form ${(same_coast1.value/2).toInt()} to ${(same_coast1.value).toInt()}  pounds for gasoline"
               ):
                   Text("1- the routes are $original_places\n distance is in range from   ${(same_distance.value/2).toInt()} to ${(same_distance.value).toInt()} km  \ncost is in range form ${(same_coast1.value/2).toInt()} to ${(same_coast1.value).toInt()}  pounds for gasoline\n the best route\n \n2- the routes are $visited\n distance is in range from   ${(best_distance.value/2).toInt()} to ${(best_distance.value).toInt()} km  \n cost is in range form ${(best_coast.value/2).toInt()} to ${(best_coast.value).toInt()}  pounds for gasoline\n")
                   :Text("");


             }),
           )
         ],
       ),
     ),
    );
  }

  Future<void> get_cal(List<String> places) async {
    original_places.clear();
    original_places.addAll(places);
    same_distance.value=0;
    best_distance.value=0;
    best_coast.value=0;
    same_coast1.value=0;
    all_lat_long.clear();
    visited.clear();
    for(String place in places){
      try {
        final locations = await locationFromAddress(place);
        var latitude1 = locations.first.latitude;
        var longitude1 = locations.first.longitude;
        all_lat_long.add(Station.nameAndlatlong(place, latitude1, longitude1));
      } catch (e) {
        Get.snackbar("Gas Calc", "No address found for place $place");
      }
    }

    //same order input
    for (int i = 0; i < all_lat_long.length - 1; i++) {
      if (i < all_lat_long.length) {
        same_distance.value= same_distance.value+Geolocator.distanceBetween(
            all_lat_long[i].latitude, all_lat_long[i].longitude,
            all_lat_long[i + 1].latitude, all_lat_long[i + 1].longitude) as double;
      }

    }
    if (same_distance.value != 0) same_distance.value = ((same_distance.value / 1000)*2) ;
    else same_distance.value = 0;
    double d = (same_distance / 2) ;
    same_coast1.value = (d * 8) ;
    //best rout
    double lat1=0,lat2=0,lon1=0,lon2=0;
    // int index=size+i;

    visited.add(places[0]);
    place.value=places[0];
    for(int i=0;i<places.length;i++){
      for(Station stat in all_lat_long) {
        if (stat.name ==place.value ) {
          lat1 = stat.latitude;
          lon1 = stat.longitude;
          break;
        }
      }
      for(int j=0;j<places.length;j++) {
        if (!visited.contains(places[j])) {
          for(Station place in all_lat_long) {
            if (place.name == places[j]) {
              lat2 = place.latitude;
              lon2 = place.longitude;
              break;
            }
          }
          var distance = Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
          stations.add(Station.byNameAndDistance(places[j], distance));
        }
    }
      if(!stations.isEmpty) {
        var reduce = stations.reduce((dist1, dist2) =>
        dist1.distance < dist2.distance ? dist1 : dist2);
        place.value=reduce.name;
        print(place.value);
        visited.add(place.value);
        best_distance.value += reduce.distance ;
        stations.clear();
      }
    }
    if (best_distance.value != 0) {
      best_distance.value = ((best_distance.value / 1000)*2);
    } else best_distance.value = 0;
    double d2 = (best_distance / 2) ;
    best_coast.value = (d2 * 8);
    // print("2-the routes are $visited");
    // print("$best_distance");
    // print("$best_coast");
    // if(same_distance.value==best_distance.value){
    //   print(" the routes are $places\n");
    //   print("distance is in range from   ${same_distance/2} to $same_distance km  \n");
    //   print("cost is in range form ${same_coast1/2} to $same_coast1  pounds for gasoline");
    // }
    // else{
    //   print("1- the routes are $places\n");
    //   print("distance is in range from   ${same_distance.value/2} to $same_distance km  \n");
    //   print("cost is in range form ${same_coast1/2} to $same_coast1  pounds for gasoline");
    //   print("the best route\n");
    //   print("2- the routes are $visited\n");
    //   print("distance is in range from   ${best_distance/2} to $best_distance km  \n");
    //   print("cost is in range form ${best_coast/2} to $best_coast  pounds for gasoline");
    // }
    places.clear();

  }
}

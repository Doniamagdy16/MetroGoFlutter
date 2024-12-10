import 'package:flutter/material.dart';
//import 'package:flutter_tts/flutter_tts.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:metrof/station.dart';

class Location_page extends StatefulWidget {
   Location_page({super.key});

  @override
  State<Location_page> createState() => _Location_pageState();
}

class _Location_pageState extends State<Location_page> {
  final address_controller=TextEditingController();

  var current_location="";
  var nearst_station="".obs;
  var all_data=<Station>[];
  var distances=<double>[];

   @override
   void initState() {
     // TODO: implement initState
     super.initState();
     fetchLocation();
     all_data=[new Station.nameAndlatlong("helwan",29.848889,31.334167),
         new Station.nameAndlatlong("ain helwan",29.862778,31.325052),
         new Station.nameAndlatlong("helwan university",29.868889  ,31.320278),
         new Station.nameAndlatlong("hadayeq helwan",29.897222,31.304167),
         new Station.nameAndlatlong("el-maasara", 29.906111,31.299722),
         new Station.nameAndlatlong("tora el-asmant",29.925833,31.287777),
         new Station.nameAndlatlong("kozzika",29.936111,31.281667),
         new Station.nameAndlatlong("tora el-balad",29.946389,31.273611),
         new Station.nameAndlatlong("thakanat el-maadi",29.952778,31.263333),
         new Station.nameAndlatlong("maadi",29.959722,31.258056),
         new Station.nameAndlatlong("hadayeq el-maadi",29.97,31.250556),
         new Station.nameAndlatlong("dar el-salam",29.981944,31.242222),
         new Station.nameAndlatlong("el-zahraa",29.995278,31.231667),
         new Station.nameAndlatlong("mar girgis",30.005833,31.229444),
         new Station.nameAndlatlong("el-malek el-saleh", 30.016944,31.230833),
         new Station.nameAndlatlong("al sayeda zeinab", 30.029167,31.235278),
         new Station.nameAndlatlong("saad zaghloul",30.036667,31.238056),
         new Station.nameAndlatlong("sadat", 30.044444,31.235556),
         new Station.nameAndlatlong("nasser",30.053611,31.238889),
         new Station.nameAndlatlong("urabi",30.0575,31.2425),
         new Station.nameAndlatlong("al-shohadaa",30.0625,31.246111),
         new Station.nameAndlatlong("ghamra", 30.068889,31.264722),
         new Station.nameAndlatlong("el-demerdash",30.077222,31.277778),
         new Station.nameAndlatlong("manshiet el-sadr",30.082222, 31.287778),
         new Station.nameAndlatlong("kobri el-qobba",30.086944,31.293889),
         new Station.nameAndlatlong("hammamat el-qobba",30.0875,31.298056),
         new Station.nameAndlatlong("saray el-qobba",30.098056,31.304722),
         new Station.nameAndlatlong("hadayeq el-zaitoun",30.105278,31.31),
         new Station.nameAndlatlong("helmeyet el-zaitoun",30.114444,31.313889),
         new Station.nameAndlatlong("el-matareyya",30.121389,31.313889),
         new Station.nameAndlatlong("ain shams",30.131111,31.319167),
         new Station.nameAndlatlong("ezbet el-Nakhl",30.139167,31.324444),
         new Station.nameAndlatlong("el-marg",30.152222,31.335556),
         new Station.nameAndlatlong("new el-marg",30.163333,31.338333),
         new Station.nameAndlatlong("el mounib",29.981389,31.211944),
         new Station.nameAndlatlong("sakiat mekki",29.995556,31.208611),
         new Station.nameAndlatlong("omm el misryeen",30.005278,31.208056),
         new Station.nameAndlatlong("giza",30.010556,31.206944),
         new Station.nameAndlatlong("faisal",30.017222,31.203889),
         new Station.nameAndlatlong("cairo university",30.026111,31.201111),
         new Station.nameAndlatlong("el behoos",30.035833,31.200278),
         new Station.nameAndlatlong("dokki",30.038333,31.211944),
         new Station.nameAndlatlong("opera",30.041944,31.225278),
         new Station.nameAndlatlong("mohamed naguib",30.045278,31.244167),
         new Station.nameAndlatlong("ataba",30.0525,31.246944),
         new Station.nameAndlatlong("massara",30.071111 ,31.245),
         new Station.nameAndlatlong("road el-farag", 30.080556,31.245556),
         new Station.nameAndlatlong("sainte teresa",30.088333,31.245556),
         new Station.nameAndlatlong("khalafawy",30.098056,31.245278),
         new Station.nameAndlatlong("mezallat",30.105,31.246667),
         new Station.nameAndlatlong("koliet el-zeraa", 30.113889,31.248611),
         new Station.nameAndlatlong("shobra el kheima", 30.1225,31.244722),
         new Station.nameAndlatlong("adly mansour", 30.146944,31.421389),
         new Station.nameAndlatlong("el haykestep", 30.143889,31.404722),
         new Station.nameAndlatlong("omar ibn el khattab", 30.140556,31.394167),
         new Station.nameAndlatlong("qubaa", 30.134722,31.3838891),
         new Station.nameAndlatlong("hisham barakat", 30.131111,31.372778),
         new Station.nameAndlatlong("el-nozha", 30.128333,31.360000),
         new Station.nameAndlatlong("el-shams club", 30.122222,31.343889),
         new Station.nameAndlatlong("alf masken", 30.118056 ,31.339722),
         new Station.nameAndlatlong("heliopolis square", 30.108056,31.338056),
         new Station.nameAndlatlong("Haroun", 30.101111,31.332778),
         new Station.nameAndlatlong("al ahram",  30.091389,31.326389),
         new Station.nameAndlatlong("koleyet el banat", 30.083611,31.328889),
         new Station.nameAndlatlong("cairo stadium", 30.073056 ,31.3175),
         new Station.nameAndlatlong("fair zone", 30.073333 ,31.301111),
         new Station.nameAndlatlong("el-abaseya", 30.069722 ,31.280833),
         new Station.nameAndlatlong("abdou pasha", 30.064722,31.274722),
         new Station.nameAndlatlong("el geish", 30.0625,31.266944),
         new Station.nameAndlatlong("bab el shaaria",  30.053889,31.256111),
         new Station.nameAndlatlong("maspero", 30.055556,31.232222),
         new Station.nameAndlatlong("zamalek", 30.0625,31.2225),
         new Station.nameAndlatlong("kit kat", 30.06666,31.213056),
         new Station.nameAndlatlong("Sudan", 30.069722,31.205278),
         new Station.nameAndlatlong("imbaba", 30.075833,31.2075),
         new Station.nameAndlatlong("el-bohy", 30.082222,31.210556),
         new Station.nameAndlatlong("el-qawmia", 30.093333,31.208889),
         new Station.nameAndlatlong("Ring Road",  30.096389 ,31.199722),
         new Station.nameAndlatlong("rod al-farag corridor", 30.101944,31.184167),
         new Station.nameAndlatlong("al tawfikeya", 30.065278,31.2025),
         new Station.nameAndlatlong("wadi el nile", 30.063889,31.201111),
         new Station.nameAndlatlong("gameat al dewal al arabeya", 30.050833,31.199722),
         new Station.nameAndlatlong("boulaq al dakrour", 30.036111,31.196389)
     ];


   }

   @override
  Widget build(BuildContext context) {
     distances.clear();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Nearest Station",style: TextStyle(color: Colors.teal),),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20,left: 20,right: 50),
            child: TextField(
              controller: address_controller,
            decoration: InputDecoration(
              hintText: "enter the address here",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),

            ),

            ),
          ),
          ElevatedButton(onPressed: ()async{
             try {
               distances.clear();
               final address = address_controller.text;
               print("dddd$address");
               final locations = await locationFromAddress(address);
               var latitude1 = locations.first.latitude;
               var longitude1 = locations.first.longitude;
               for (Station station in all_data) {
                              var longitude2 = station.longitude;
                              var latitude2 = station.latitude;
                              distances.add(Geolocator.distanceBetween(latitude1, longitude1, latitude2, longitude2));
                            }
               double min =distances.reduce((a, b) =>a>b?b:a);
               int index = distances.indexOf(min);
               nearst_station.value=all_data[index].name;
               print("nearest station is ${nearst_station.value}");
             } catch (e) {
               Get.snackbar("Metro Go", "please enter valid place or check the connection");
             }


          }, child:Text("get station") ,
            style: ButtonStyle(
              backgroundColor:MaterialStateProperty.all(Colors.teal)

          ),),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Obx(() {
              return nearst_station.value==""?Text(""): Text("The nearest metro station to ${address_controller.text} is ${nearst_station.value}",style: TextStyle(fontSize: 15),);
     }),
          )
           ],
      ),

    );
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
    address_controller.text=current_location;
  }
}

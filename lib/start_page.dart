import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:metrof/result_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'functions.dart';
import 'gas_calc.dart';
import 'location_page.dart';
class Start_Page extends StatelessWidget {
  Start_Page({super.key});
  TextEditingController start_controller=TextEditingController();
  var start="".obs;
  TextEditingController end_controller=TextEditingController();
  var end="".obs;
  var all_data=[];
  var selectS=false.obs;
  var selectE=false.obs;
  var items=<String>[
    "abdou pasha", "adly mansour", "ain helwan", "ain shams", "alf masken", "al ahram",
    "al-shohadaa", "al tawfikeya", "al sayeda zeinab", "ataba", "bab el shaaria", "boulaq al dakrour", "cairo stadium", "cairo university", "dar el-salam", "dokki", "el-abaseya",
    "el behoos", "el-bohy", "el-demerdash", "el geish", "el haykestep", "el-maasara",
    "el-malek el-saleh", "el-marg", "el-matareyya", "el mounib", "el-nozha",
    "el-qawmia", "el-shams club", "el-zahraa", "ezbet el-Nakhl", "fair zone",
    "faisal", "gameat al dewal al arabeya", "ghamra", "giza", "hadayeq el-maadi",
    "hadayeq el-zaitoun", "hadayeq helwan", "hammamat el-qobba", "helmeyet el-zaitoun", "heliopolis square",
    "Haroun", "helwan", "helwan university", "hisham barakat", "imbaba", "kit kat",
    "khalafawy", "kobri el-qobba", "koleyet el banat", "koliet el-zeraa", "kozzika",
    "maadi", "maspero", "mar girgis", "massara", "manshiet el-sadr", "mohamed naguib",
    "mezallat", "new el-marg", "nasser", "omar ibn el khattab", "omm el misryeen",
    "opera", "qubaa", "Ring Road", "road el-farag", "rod al-farag corridor", "saad zaghloul",
    "sainte teresa", "sakiat mekki", "sadat", "saray el-qobba", "shobra el kheima",
    "Sudan", "thakanat el-maadi", "tora el-asmant", "tora el-balad", "urabi",
    "wadi el nile", " wadi hoff", "zamalek"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Metro Stations",style: TextStyle(color: Colors.teal),),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0,left: 6),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("start station"),
                  ),
                  SizedBox(width: 20,),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: DropdownMenu<String>(dropdownMenuEntries: items.map((item)=>DropdownMenuEntry(value: item, label: item)).toList(),
                      hintText: "please select",
                      width: 200,
                      controller: start_controller,
                      enableSearch: true,
                      enableFilter: true,
                      requestFocusOnTap: true,
                      onSelected: (selected){
                        start.value=selected!;
                        selectS.value=true;

                      },

                    ),
                  ),
                  Obx(() {
                    return IconButton(onPressed:start.value!="" ?()async{
                      final locations = await locationFromAddress("${start.value} metro station");
                      var latitude1 = locations.first.latitude;
                      var longitude1 = locations.first.longitude;
                      final uri =
                      Uri.parse("google.navigation:q=$latitude1,$longitude1");
                      launchUrl(uri);

                    }:null, icon: Icon(Icons.location_on,color: Color(Colors.teal.value),));

                  })

                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("end station"),
                  ),
                  SizedBox(width: 25,),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: DropdownMenu<String>(dropdownMenuEntries: items.map((item)=>DropdownMenuEntry(value: item, label: item)).toList(),
                        hintText: "please select",
                        width: 200,
                        controller: end_controller,
                        enableSearch: true,
                        enableFilter: true,
                        requestFocusOnTap: true,
                        onSelected: (selected) {
                          selectE.value=true;
                          end.value = selected!;

                        }
                    ),
                  ),
                  Obx(() {
                    return IconButton(onPressed:end.value!=""? ()async{
                      final locations = await locationFromAddress("${end.value} metro station");
                      var latitude1 = locations.first.latitude;
                      var longitude1 = locations.first.longitude;
                      final uri =
                      Uri.parse("google.navigation:q=$latitude1,$longitude1");
                      launchUrl(uri);
                    }:null, icon: Icon(Icons.location_on,color: Color(Colors.teal.value),));

                  })
                   ],
              ),

              Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Obx(() {
                    return ElevatedButton(onPressed: selectE.value==true&& selectE.value==true ? (){
                      // start=start_controller.text;
                      // end=end_controller.text;
                      if( start.value==end.value){
                        Fluttertoast.showToast(
                            msg: "please choose valid stations",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            //timeInSecForIosWeb: 3,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        return;
                      }
                      all_data=result(start.value, end.value);
                      Get.to(Result_Page(),arguments: {'data':all_data,'start':start,'end':end});
                      //Get.to(Result_Page());
                      end_controller.clear();
                      start_controller.clear();
                      selectE.value=false;
                      selectS.value=false;

                    }:null, child: Text("get result"),
                      style:selectE.value==false? ButtonStyle(

                          backgroundColor: MaterialStateProperty.all(Colors.grey[200]))
                          : ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.teal)

                      ),

                    );

                  })

              ),
              //nearest station




            ],
          ),
        ),
      ),
    );
  }
  List<String> result(String start,String end) {

    List<String> ResultText = [];
    ResultText.clear();

    List<String> Line1 = [
      "helwan",
      "ain helwan",
      "helwan university",
      "wadi hoff",
      "hadayeq helwan",
      "el-maasara",
      "tora el-asmant",
      "kozzika",
      "tora el-balad",
      "thakanat el-maadi",
      "maadi",
      "hadayeq el-maadi",
      "dar el-salam",
      "el-zahraa",
      "mar girgis",
      "el-malek el-saleh",
      "al sayeda zeinab",
      "saad zaghloul",
      "sadat",
      "nasser",
      "urabi",
      "al-shohadaa",
      "ghamra",
      "el-demerdash",
      "manshiet el-sadr",
      "kobri el-qobba",
      "hammamat el-qobba",
      "saray el-qobba",
      "hadayeq el-zaitoun",
      "helmeyet el-zaitoun",
      "el-matareyya",
      "ain shams",
      "ezbet el-Nakhl",
      "el-marg",
      "new el-marg"
    ];
    List<String> Line2 = [
      "el mounib",
      "sakiat mekki",
      "omm el misryeen",
      "giza",
      "faisal",
      "cairo university",
      "el behoos",
      "dokki",
      "opera",
      "sadat",
      "mohamed naguib",
      "ataba",
      "al-shohadaa",
      "massara",
      "road el-farag",
      "sainte teresa",
      "khalafawy",
      "mezallat",
      "koliet el-zeraa",
      "shobra el kheima"
    ];
    List<String> Line3 = [
      "adly mansour",
      "el haykestep",
      "omar ibn el khattab",
      "qubaa",
      "hisham barakat",
      "el-nozha",
      "el-shams club",
      "alf masken",
      "heliopolis square",
      "Haroun",
      "al ahram",
      "koleyet el banat",
      "cairo stadium",
      "fair zone",
      "el-abaseya",
      "abdou pasha",
      "el geish",
      "bab el shaaria",
      "ataba",
      "nasser",
      "maspero",
      "zamalek",
      "kit kat",
      "Sudan",
      "imbaba",
      "el-bohy",
      "el-qawmia",
      "Ring Road",
      "rod al-farag corridor"
    ];
    // eltfre3a
    List<String> Line4 = [
      "adly mansour",
      "el haykestep",
      "omar ibn el khattab",
      "qubaa",
      "hisham barakat",
      "el-nozha",
      "el-shams club",
      "alf masken",
      "heliopolis square",
      "Haroun",
      "al ahram",
      "koleyet el banat",
      "cairo stadium",
      "fair zone",
      "el-abaseya",
      "abdou pasha",
      "el geish",
      "bab el shaaria",
      "ataba",
      "nasser",
      "maspero",
      "zamalek",
      "kit kat",
      "al tawfikeya",
      "wadi el nile",
      "gameat al dewal al arabeya",
      "boulaq al dakrour"
      ,
      "cairo university"
    ];

    List<String> line1 = [];
    List<String> line2 = [];
    //var data = [];
    StringBuffer data= StringBuffer();
    // List<String> line4 = [];
    List<String> exchanges = ["sadat", "nasser", "al-shohadaa", "ataba"];
    List<String> all_available_routes = [];
    List<String> stations = [];
    Functions functions =  Functions();
    int same_line = 0;
    if (Line1.contains(start) && Line1.contains(end)) {
      same_line = 1;
      line1 = Line1;
      line2 = Line2;
      // line3 = Line3;
      // line4 = Line4;
    } else if (Line2.contains(start) && Line2.contains(end)) {
      same_line = 1;
      line1 = Line2;
      line2 = Line1;
      // line3 = Line3;
      // line4 = Line4;
    } else if (Line3.contains(start) && Line3.contains(end)) {
      same_line = 1;
      line1 = Line3;
      line2 = Line1;
      // line3 = Line2;
      // line4 = Line4;
    }
    //eltfre3a
    else if (Line4.contains(start) && Line4.contains(end)) {
      same_line = 1;
      line1 = Line4;
      line2 = Line1;
      // line3 = Line2;
      // line4 = Line3;
    }
    //diff lines

    else {
      if (Line1.contains(start)) {
        if (Line2.contains(end)) {
          line1 = Line1;
          line2 = Line2;
          // line3 = Line3;
          // line4 = Line4;
          same_line = 2;
        } else if (Line3.contains(end)) {
          line1 = Line1;
          line2 = Line3;
          // line3 = Line2;
          // line4 = Line4;
          same_line = 2;
        }
        //eltfre3a
        else if (Line4.contains(end)) {
          line1 = Line1;
          line2 = Line4;
          // line3 = Line2;
          // line4 = Line3;
          same_line = 2;
        }
      } else if (Line2.contains(start)) {
        if (Line1.contains(end)) {
          line1 = Line2;
          line2 = Line1;
          // line3 = Line3;
          // line4 = Line4;
          same_line = 2;
        } else if (Line3.contains(end)) {
          line1 = Line2;
          line2 = Line3;
          // line3 = Line1;
          // line4 = Line4;
          same_line = 2;
        } else if (Line4.contains(end)) {
          line1 = Line2;
          line2 = Line4;
          // line3 = Line1;
          // line4 = Line3;
          same_line = 2;
        }
      } else if (Line3.contains(start)) {
        if (Line1.contains(end)) {
          same_line = 2;
          line1 = Line3;
          line2 = Line1;
          // line3 = Line2;
          // line4 = Line4;
        } else if (Line2.contains(end)) {
          same_line = 2;
          line1 = Line3;
          line2 = Line2;
          // line3 = Line1;
          // line4 = Line4;
        } else if (Line4.contains(end)) {
          same_line = 2;
          line1 = Line3;
          line2 = Line4;
          // line3 = Line1;
          // line4 = Line2;
        }
        //eltfre3a
      } else if (Line4.contains(start)) {
        if (Line1.contains(end)) {
          same_line = 2;
          line1 = Line4;
          line2 = Line1;
          // line3 = Line2;
          // line4 = Line3;
        } else if (Line2.contains(end)) {
          same_line = 2;
          line1 = Line4;
          line2 = Line2;
          // line3 = Line1;
          // line4 = Line3;
        } else if (Line3.contains(end)) {
          same_line = 2;
          line1 = Line4;
          line2 = Line3;
          // line3 = Line1;
          // line4 = Line2;
        }
      }
    }
    List<String> startline = line1;
    List<String> endline = line2;
    String ex_station = "";
    int count = 0;
    if (same_line == 1) {
      stations.clear();
      data.write(functions.getRoutesInSame(line1, ResultText, count, start, end));

      //if start or end exist in more than one line
      if (Line1 != line1 && (Line1.contains(start) || Line1.contains(end))) {
        ex_station = "";
        if (Line1.contains(start)) {
          ex_station = functions.getNearestStation(
              Line1, start, exchanges, line1, all_available_routes, end);
          stations.add(ex_station);
          all_available_routes.clear();
          functions.getRoutesBetweenTwoLines(
              all_available_routes,
              ResultText,
              count,
              ex_station,
              start,
              Line1,
              line1,
              end);
          //another available route of line1 or line2
          if (Line2.contains(end)) {
            if (ex_station == "sadat")
              ex_station = "al-shohadaa";
            else
              ex_station = "sadat";
            all_available_routes.clear();
            functions.getRoutesBetweenTwoLines(
                all_available_routes,
                ResultText,
                count,
                ex_station,
                start,
                Line1,
                Line2,
                end);
            stations.add(ex_station);
          }
          if (Line1.contains(end)) {
            all_available_routes.clear();
            functions.getRoutesInSame(Line1, ResultText, count, start, end);
            stations.add(ex_station);
          }
        }
        if (Line1.contains(end)) {
          ex_station = functions.getNearestStation(
              line1, start, exchanges, Line1, all_available_routes, end);
          all_available_routes.clear();
          functions.getRoutesBetweenTwoLines(
              all_available_routes,
              ResultText,
              count,
              ex_station,
              start,
              line1,
              Line1,
              end);
          stations.add(ex_station);
        }
      }
      if (Line2 != line1 && (Line2.contains(start) || Line2.contains(end))) {
        ex_station = ""; //save nearst station
        if (Line2.contains(start)) {
          ex_station = functions.getNearestStation(
              Line2, start, exchanges, line1, all_available_routes, end);
          all_available_routes.clear();
          ResultText.clear();
          //if transition between line1 and line2 and start is ex station
          functions.getRoutesBetweenTwoLines(
              all_available_routes,
              ResultText,
              count,
              ex_station,
              start,
              Line2,
              line1,
              end);
          stations.add(ex_station);
          //another available route of line1 or line2
          if (Line1.contains(end) && Line1 == line1) {
            if (ex_station == "sadat")
              ex_station = "al-shohadaa";
            else
              ex_station = "sadat";
            all_available_routes.clear();
            functions.getRoutesBetweenTwoLines(
                all_available_routes,
                ResultText,
                count,
                ex_station,
                start,
                Line2,
                Line1,
                end);
            stations.add(ex_station);
          }
          if (Line2.contains(end)) {
            all_available_routes.clear();
            functions.getRoutesInSame(Line2, ResultText, count, start, end);
          }
        }
        if (Line2.contains(end)) {
          ex_station = functions.getNearestStation(
              line1, start, exchanges, Line2, all_available_routes, end);
          all_available_routes.clear();
          functions.getRoutesBetweenTwoLines(
              all_available_routes,
              ResultText,
              count,
              ex_station,
              start,
              line1,
              Line2,
              end);
          stations.add(ex_station);
        }
      }
      if (line1 != Line3 && (Line3.contains(start) || Line3.contains(end))) {
        ex_station = "";
        if (Line3.contains(start)) {
          //if start and end in Line3 and Line4 3shan ma3amlsh elly b3d kit kat 5t geded
          if ((Line3.contains(start) && Line4.contains(end)) ||
              (Line4.contains(start) && Line3.contains(end)))
            ex_station = "kit kat";
          else
            ex_station = functions.getNearestStation(
                Line3, start, exchanges, line1, all_available_routes, end);
          all_available_routes.clear();
          functions.getRoutesBetweenTwoLines(
              all_available_routes,
              ResultText,
              count,
              ex_station,
              start,
              Line3,
              line1,
              end);
          stations.add(ex_station);
          if (Line3.contains(end)) {
            all_available_routes.clear();
            functions.getRoutesInSame(Line3, ResultText, count, start, end);
          }
        } else if (Line3.contains(end)) {
          if ((Line3.contains(start) && Line4.contains(end)) ||
              (Line4.contains(start) && Line3.contains(end)))
            ex_station = "kit kat";
          else
            ex_station = functions.getNearestStation(
                line1, start, exchanges, Line3, all_available_routes, end);
          all_available_routes.clear();
          functions.getRoutesBetweenTwoLines(
              all_available_routes,
              ResultText,
              count,
              ex_station,
              start,
              line1,
              Line3,
              end);
          stations.add(ex_station);
        }
      }
      if (line1 != Line4 && line1 != Line3) {
        ex_station = "";
        if (Line4.contains(start) && !Line3.contains(start)) {
          ex_station = functions.getNearestStation(
              Line4, start, exchanges, line1, all_available_routes, end);
          all_available_routes.clear();
          functions.getRoutesBetweenTwoLines(
              all_available_routes,
              ResultText,
              count,
              ex_station,
              start,
              Line4,
              line1,
              end);
          stations.add(ex_station);
          if (Line4.contains(end)) {
            all_available_routes.clear();
            functions.getRoutesInSame(Line4, ResultText, count, start, end);
          }
        }
        if (Line4.contains(end) && !Line3.contains(end)) {
          if (Line3.contains(start)) {
            ex_station = "kit kat";
            functions.getRoutesBetweenTwoLines(
                all_available_routes,
                ResultText,
                count,
                ex_station,
                start,
                Line3,
                Line4,
                end);
            stations.add(ex_station);
          } else {
            ex_station = functions.getNearestStation(
                line1, start, exchanges, Line4, all_available_routes, end);
            all_available_routes.clear();
            // ResultText.append("--------------------------\n");
            functions.getRoutesBetweenTwoLines(
                all_available_routes,
                ResultText,
                count,
                ex_station,
                start,
                line1,
                Line4,
                end);
            stations.add(ex_station);
          }
        }
      }
    } else if (same_line == 2) {
      ex_station = functions.getNearestStation(
          line1, start, exchanges, line2, all_available_routes, end);
      stations.add(ex_station);
      all_available_routes.clear();
      functions.getRoutesBetweenTwoLines(all_available_routes, ResultText,
          count,
          ex_station,
          start,
          line1,
          line2,
          end);
      if (line1 == Line1 && line2 == Line2 ||
          line1 == Line2 && line2 == Line1) {
        all_available_routes.clear();
        if (ex_station == "sadat") {
          ex_station = "al-shohadaa";
        } else if (ex_station == "al-shohadaa") ex_station = "sadat";
        stations.add(ex_station);
        functions.getRoutesBetweenTwoLines(
            all_available_routes,
            ResultText,
            count,
            ex_station,
            start,
            line1,
            line2,
            end);
      }
      //if start or ends exist in many lines

      if ((Line1.contains(start) && Line1 != line1) ||
          (Line1.contains(end) && Line1 != line2)) {
        if (Line1.contains(start)) {
          line1 = Line1;
          ex_station = functions.getNearestStation(
              line1, start, exchanges, line2, all_available_routes, end);
        } else if ((Line1.contains(end) && Line1 != line2)) {
          line2 = Line1;
          ex_station = functions.getNearestStation(
              line1, start, exchanges, line2, all_available_routes, end);
        }
        all_available_routes.clear();
        stations.add(ex_station);
        functions.getRoutesBetweenTwoLines(
            all_available_routes,
            ResultText,
            count,
            ex_station,
            start,
            line1,
            line2,
            end);
        line1 = startline;
        line2 = endline;
      }
      if ((Line2.contains(start) && Line2 != line1) ||
          (Line2.contains(end) && Line2 != line2)) {
        if (Line2.contains(start)) {
          line1 = Line2;
          ex_station = functions.getNearestStation(
              line1, start, exchanges, line2, all_available_routes, end);
          stations.add(ex_station);
        } else if (Line2.contains(end)) {
          line2 = Line2;
          ex_station = functions.getNearestStation(
              line1, start, exchanges, line2, all_available_routes, end);
          stations.add(ex_station);
        }
        all_available_routes.clear();
        functions.getRoutesBetweenTwoLines(
            all_available_routes,
            ResultText,
            count,
            ex_station,
            start,
            line1,
            line2,
            end);
        line1 = startline;
        line2 = endline;
      }

      if ((Line3.contains(start) && Line3 != line1) ||
          (Line3.contains(end) && Line3 != line2)) {
        if (Line3.contains(start)) {
          line1 = Line3;
          if (Line4.contains(end) && Line4 != line2) {
            ex_station = "kit kat";
            all_available_routes.clear();
            functions.getRoutesBetweenTwoLines(
                all_available_routes,
                ResultText,
                count,
                ex_station,
                start,
                line1,
                Line4,
                end);
            stations.add(ex_station);
          } else {
            ex_station = functions.getNearestStation(
                line1, start, exchanges, line2, all_available_routes, end);
            all_available_routes.clear();
            functions.getRoutesBetweenTwoLines(
                all_available_routes,
                ResultText,
                count,
                ex_station,
                start,
                line1,
                line2,
                end);
            stations.add(ex_station);
          }
        } else if (Line3.contains(end)) {
          if (Line4.contains(start)) {
            ex_station = "kit kat";
            all_available_routes.clear();
            functions.getRoutesBetweenTwoLines(
                all_available_routes,
                ResultText,
                count,
                ex_station,
                start,
                Line4,
                Line3,
                end);
            stations.add(ex_station);
          } else {
            line2 = Line3;
            ex_station = functions.getNearestStation(
                line1, start, exchanges, line2, all_available_routes, end);
            all_available_routes.clear();
            functions.getRoutesBetweenTwoLines(
                all_available_routes,
                ResultText,
                count,
                ex_station,
                start,
                line1,
                line2,
                end);
            stations.add(ex_station);
          }
        }
        line1 = startline;
        line2 = endline;
      }

      if ((Line4.contains(start) && Line4 != line1) ||
          (Line4.contains(end) && Line4 != line2)) {
        if (Line4.contains(start) && !Line3.contains(start)) {
          line1 = Line4;
          if (Line3.contains(end)) {
            ex_station = "kit kat";
            all_available_routes.clear();
            functions.getRoutesBetweenTwoLines(
                all_available_routes,
                ResultText,
                count,
                ex_station,
                start,
                Line4,
                Line3,
                end);
            stations.add(ex_station);
          } else {
            ex_station = functions.getNearestStation(
                line1, start, exchanges, line2, all_available_routes, end);
            functions.getRoutesBetweenTwoLines(
                all_available_routes,
                ResultText,
                count,
                ex_station,
                start,
                Line4,
                line2,
                end);
            stations.add(ex_station);
          }
        } else if (Line4.contains(end) && !Line3.contains(end)) {
          line2 = Line4;
          if (Line3.contains(start)) {
            ex_station = "kit kat";
            all_available_routes.clear();
            functions.getRoutesBetweenTwoLines(
                all_available_routes,
                ResultText,
                count,
                ex_station,
                start,
                Line3,
                Line4,
                end);
            stations.add(ex_station);
          } else {
            ex_station = functions.getNearestStation(
                line1, start, exchanges, line2, all_available_routes, end);
            all_available_routes.clear();
            functions.getRoutesBetweenTwoLines(
                all_available_routes,
                ResultText,
                count,
                ex_station,
                start,
                line1,
                Line4,
                end);
            stations.add(ex_station);
          }
        }
        line1 = startline;
        line2 = endline;
      }
    }

    //print(data);
    return ResultText;
  }
}

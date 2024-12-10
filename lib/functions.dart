
class Functions{
  List<Object> getRoute1(List<String> line1, String exStation, String start, List<String> allAvailableRoutes) {
    int lastIndex = line1.length - 1;
    StringBuffer sb = StringBuffer();
    sb.write("The direction is ${line1[lastIndex]}\n");
    sb.write("The station that you change from is $exStation\n");
    String station = "The station that you change from is $exStation";

    allAvailableRoutes.addAll(line1.sublist(line1.indexOf(start), line1.indexOf(exStation) + 1));

    return [allAvailableRoutes, sb.toString(), station];
  }
  List<Object> get_route2(List<String> line2, String ex_station, String end, List<String> all_stations) {

    all_stations.addAll(line2.sublist(line2.indexOf(ex_station) + 1, line2.indexOf(end) + 1));
    int lastIndex = line2.length - 1;
    StringBuffer sb = new StringBuffer();
    sb.write("The  direction is " + line2[lastIndex]);
    return[ all_stations,sb];
  }
  int getFirstStation(List<String> line1, String start, List<String> exchanges, List<String> line2) {
    int firstIndexF = 0;

    firstIndexF = line1.sublist(line1.indexOf(start))
        .where((station) => exchanges.contains(station) && line2.contains(station))
        .map((station) => line1.indexOf(station))
        .firstWhere((index) => true, orElse: () => -1);

    return firstIndexF;
  }
  String calc_time(int count) {
    int time =(count * 2);
    StringBuffer sb = new StringBuffer();
    if (time >= 60) {
      time =  ((time / 60)).toInt();
      sb.write("The time taken to arrive = ");
      sb.write(time);
      sb.write(" hours\n");
    } else {
      sb.write("The time taken to arrive = ");
      sb.write(time);
      sb.write(" minutes\n");
    }
    return sb.toString();
  }
  int calc_ticket(int count) {
    int ticket = 0;
    if (count <= 9) {
      ticket = 8;
    } else if (count <= 16) {
      ticket = 10;
    } else if (count <= 23) {
      ticket = 15;
    } else {
      ticket = 20;
    }
    // print("Ticket= $ticket");
    return ticket;
  }
  String station_details1(int count, List<String> line1, String start, String end) {
    StringBuffer sb = new StringBuffer();
    sb.write("The direction is ");
    sb.write(line1[line1.length - 1]);
    sb.write("\n");
    sb.write("Number of stations = ");
    sb.write(count);
    sb.write("\n");
    sb.write(calc_time(count)); // Assuming calc_time returns a String
    sb.write("The stations are ");
    sb.write(line1.sublist(line1.indexOf(start), line1.indexOf(end) + 1));
    sb.write("\n");

    return sb.toString();
  }
  String station_details2(int count, List<String> all_available_routes) {
    StringBuffer sb = new StringBuffer();

    sb.write("Number of stations = ");
    sb.write(count);
    sb.write("\n");
    sb.write(calc_time(count)); // Assuming calc_time returns a String
    sb.write("Ticket =");
    sb.write(calc_ticket(count));
    sb.write("\n"); // Assuming calc_ticket returns a String
    sb.write("The stations are ");
    sb.write(all_available_routes);
    sb.write("\n");

    return sb.toString();
  }
  String getRoutesInSame(List<String> line1, List<String> resultText, int count, String start, String end) {
    if (line1.indexOf(end) > line1.indexOf(start)) {
      count = line1.indexOf(end) - line1.indexOf(start) + 1;
      String details1 = station_details1(count, line1, start, end);
      int ticket = calc_ticket(count);
      resultText.addAll([details1 + " Ticket = $ticket"]);
    } else if (line1.indexOf(end) < line1.indexOf(start)) {
      // line1 = List.from(line1.reversed);
      line1=line1.reversed.toList();
      count = line1.indexOf(end) - line1.indexOf(start) + 1;
      String details1 = station_details1(count, line1, start, end);
      int ticket =calc_ticket(count);
      resultText.addAll([details1 + " Ticket = $ticket"]);
    }
    return resultText.toString();

  }
  String getRoutesBetweenTwoLines(List<String> allAvailableRoutes, List<String> resultText, int count, String exStation, String start, List<String> line1, List<String> line2, String end) {
    String res1 = "";
    String res2 = "";
    if (start.toLowerCase() == exStation.toLowerCase()) {
      int lastIndex = line1.length - 1;
      allAvailableRoutes.add(start);

      if (line2.indexOf(exStation) < line2.indexOf(end)) {
        List<Object> result = get_route2(line2, exStation, end, allAvailableRoutes);
        allAvailableRoutes = result[0]as List<String>;
        count = allAvailableRoutes.length;
        String details = station_details2(count, allAvailableRoutes);
        resultText.add("The direction is ${line1[lastIndex]}\nthe station that you change from is $exStation\n${result[1]}\n$details");
      } else if (line2.indexOf(exStation) > line2.indexOf(end)) {
        // line2 = List.from(line2.reversed);
        line2=line2.reversed.toList();
        List<Object> result = get_route2(line2, exStation, end, allAvailableRoutes);
        allAvailableRoutes = result[0]as List<String>;
        res2 = "${result[1]}\n";
        // line2 = List.from(line2.reversed);
        line2=line2.reversed.toList();
        count = allAvailableRoutes.length;
        String details =station_details2(count, allAvailableRoutes);
        resultText.add("The direction is ${line1[lastIndex]}\nthe station that you change from is $exStation\n$res2\n$details");
      }
    } else if (exStation.toLowerCase() == end.toLowerCase()) {
      if (line1.indexOf(exStation) > line1.indexOf(start)) {
        allAvailableRoutes.clear();
        List<Object> result = getRoute1(line1, exStation, start, allAvailableRoutes);
        allAvailableRoutes = result[0]as List<String>;
        res1 = result[1].toString();
      } else if (line1.indexOf(exStation) < line1.indexOf(start)) {
        //line1 = List.from(line1.reversed);
        line1=line1.reversed.toList();
        List<Object> result = getRoute1(line1, exStation, start, allAvailableRoutes);
        allAvailableRoutes = result[0]as List<String>;
        res1 = result[1].toString();
        // line1 = List.from(line1.reversed);
        line1=line1.reversed.toList();
      }

      int lastIndex = line2.length - 1;
      count = allAvailableRoutes.length;
      String details = station_details2(count, allAvailableRoutes);
      resultText.add("The direction is $res1 The direction is ${line2[lastIndex]}\n$details");
    } else {
      if (line1.indexOf(exStation) > line1.indexOf(start)) {
        allAvailableRoutes.clear();
        List<Object> result = getRoute1(line1, exStation, start, allAvailableRoutes);
        allAvailableRoutes = result[0]as List<String>;
        res1 = result[1].toString();
      } else if (line1.indexOf(exStation) < line1.indexOf(start)) {
        //line1 = List.from(line1.reversed);
        line1=line1.reversed.toList();
        List<Object> result = getRoute1(line1, exStation, start, allAvailableRoutes);
        allAvailableRoutes = result[0]as List<String>;
        res1 = result[1].toString();
        // line1 = List.from(line1.reversed);
        line1=line1.reversed.toList();
      }

      if (line2.indexOf(exStation) < line2.indexOf(end)) {
        List<Object> result = get_route2(line2, exStation, end, allAvailableRoutes);
        allAvailableRoutes = result[0]as List<String>;
        res2 = "${result[1]}\n";
        count = allAvailableRoutes.length;
        String details = station_details2(count, allAvailableRoutes);
        resultText.add("$res1$res2$details");
      } else if (line2.indexOf(exStation) > line2.indexOf(end)) {
        //line2 = List.from(line2.reversed);
        line2=line2.reversed.toList();
        List<Object> result = get_route2(line2, exStation, end, allAvailableRoutes);
        allAvailableRoutes = result[0] as List<String>;
        res2 = "${result[1]}\n";
        //line2 = List.from(line2.reversed);
        line2=line2.reversed.toList();
        count = allAvailableRoutes.length;
        String details = station_details2(count, allAvailableRoutes);
        resultText.add("$res1$res2$details");
      }
    }
    return resultText.toString();
  }
  String getNearestStation(List<String> line1, String start, List<String> exchanges, List<String> line2, List<String> allStations, String end) {
    int firstIndexF = getFirstStation(line1, start, exchanges, line2);
    String exSt1 = "";
    if (firstIndexF != -1) exSt1 = line1[firstIndexF];

    //line1 = List.from(line1.reversed);
    line1=line1.reversed.toList();

    // To get the shortest path
    int firstIndexB = getFirstStation(line1, start, exchanges, line2);
    String exSt2 = "";
    if (firstIndexB != -1) exSt2 = line1[firstIndexB];

    //line1 = List.from(line1.reversed);
    line1=line1.reversed.toList();

    // If firstIndexF == -1
    if (exSt1 == "") exSt1 = line1[firstIndexB];

    // If firstIndexB == -1
    if (exSt2 == "") exSt2 = line1[firstIndexF];

    int min1 = 0;
    int min2 = 0;

    if (firstIndexF != -1 && firstIndexB != -1) {
      if (line1.indexOf(exSt1) < line1.indexOf(start)) {
        min1 = line1.indexOf(start) - line1.indexOf(exSt1);
      } else if (line1.indexOf(exSt1) > line1.indexOf(start)) {
        min1 = line1.indexOf(exSt1) - line1.indexOf(start);
      }

      if (line1.indexOf(exSt2) < line1.indexOf(start)) {
        min2 = line1.indexOf(start) - line1.indexOf(exSt2);
      } else if (line1.indexOf(exSt2) > line1.indexOf(start)) {
        min2 = line1.indexOf(exSt2) - line1.indexOf(start);
      }
    }

    String exStation = "";

    if (min1 < min2) {
      exStation = exSt1;
    } else {
      exStation = exSt2;
    }

    return exStation;
  }
}
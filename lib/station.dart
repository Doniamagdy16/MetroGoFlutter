class Station {
   final String name;
   final double latitude;
   final double longitude;
   final double distance;

   Station.byNameAndDistance(this.name, this.distance,{this.latitude = 0.0, this.longitude = 0.0}) ;

  Station.nameAndlatlong(this.name, this.latitude, this.longitude, {this.distance=0.0});
}
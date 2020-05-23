import 'package:location/location.dart';

class LocationUtil {

  //prompt to enable GPS. this method should be called
  //only if location permission is granted.
  static isGPAvailable() async {
    Location location = new Location();
    await location.getLocation();
  }
}

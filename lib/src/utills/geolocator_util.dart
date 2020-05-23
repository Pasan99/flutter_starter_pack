import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

class GeolocatorUtil {
  static final Location _location = new Location();
  //check whether the location data available
//  static Future<bool> isLocationDataAvailable() async {
//    try {
//      Position position = await Geolocator()
//          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
//          .timeout(new Duration(seconds: 5));
//
//      return position != null;
//    } catch (e) {
//      print('Error: ${e.toString()}');
//      return false;
//    }
//  }

  ///check whether the GPS is enabled or disabled
  static Future<bool> isGPSEnabled() async {
    try {
      return await _location.serviceEnabled();
    } catch (e) {
      print(e);
    }

    return false;
  }
}

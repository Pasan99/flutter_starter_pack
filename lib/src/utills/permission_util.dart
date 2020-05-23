import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  //check whether the location permission is granted while using the app
  static Future<bool> isLocationPermissonGranted() async {
    return Permission.locationWhenInUse.request().isGranted;
  }

  //check whether the location permission status is granted while app is using
  static Future<bool> isPermissionGranted() async {
    return Permission.locationWhenInUse.isGranted;
  }

  //check whether the location permission is permanently dinied
  static Future<bool> isPermanentlyDeniedLocation() async {
    return Permission.locationWhenInUse.status.isPermanentlyDenied;
  }

  //open app settings. this method will call
  // if the permission is permanently denied.
  static forwardToAppSettings() {
    openAppSettings();
  }
}

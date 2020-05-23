import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_deliver/src/ui/pages/outdated/register_page.dart';
import 'package:food_deliver/src/routes/router.gr.dart';
import 'package:food_deliver/src/utills/geolocator_util.dart';
import 'package:food_deliver/src/utills/location_util.dart';
import 'package:food_deliver/src/utills/permission_util.dart';
import 'package:food_deliver/src/values/colors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationMapPage extends StatefulWidget {
  static const REGISTRATION_TYPE_MAIN_ADDRESS = 0;
  static const REGISTRATION_TYPE_EDIT_MAIN_ADDRESS = 1;
  static const REGISTRATION_TYPE_SUB_ADDRESS = 2;
  static const REGISTRATION_TYPE_EDIT_SUB_ADDRESS = 3;

  final int registrationType;
  final String contactID;
  final Function onContactCreated;

  LocationMapPage(this.registrationType,
      {Key key, this.contactID, this.onContactCreated})
      : super(key: key);

  @override
  _LocationMapPageState createState() =>
      _LocationMapPageState(this.registrationType, this.contactID);
}

class _LocationMapPageState extends State<LocationMapPage> {
  final _initialLatLng = LatLng(7.261897, 80.531342); //location of Sri Lanka
  final int _registrationType;
  final String _contactID;
  bool isButtonVisible = false;

  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  int _markerIdCounter = 0;
  Completer<GoogleMapController> _mapController = Completer();

  StreamSubscription<Position> _positionStream;

  _LocationMapPageState(this._registrationType, this._contactID);

  int locationLoadTime = 0;
  int mapLoadTime = 0;
  int markerLoadTime = 0;

  @override
  void initState() {
    super.initState();

    //register for location updates and update the google map location
    //_createLocationListener();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        if (!await PermissionUtil.isPermissionGranted())
          _openLocationInformationDialog(
              context); //permission information pop up
        else if (!await GeolocatorUtil.isGPSEnabled())
          _openGPSInformationDialog(context); //gps information pop up
      },
    );
  }

  @override
  void dispose() {
    if (_positionStream != null) _positionStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading:
            _registrationType == LocationMapPage.REGISTRATION_TYPE_MAIN_ADDRESS
                ? SizedBox()
                : GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back),
                  ),
        title: Text(
          _registrationType == LocationMapPage.REGISTRATION_TYPE_MAIN_ADDRESS ||
                  _registrationType ==
                      LocationMapPage.REGISTRATION_TYPE_SUB_ADDRESS
              ? "Select Location"
              : 'confirm_your_location',
          //  'confirm_your_location',
          textAlign: TextAlign.center,
          //overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ).tr(),
        backgroundColor: AppColors.MAIN_COLOR,
      ),
      body: SafeArea(
          minimum: EdgeInsets.only(
            right: 0.0,
            left: 0.0,
          ),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints con) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: con.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Stack(
                      children: <Widget>[
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          verticalDirection: VerticalDirection.down,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                child: Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: GoogleMap(
                                markers: Set<Marker>.of(_markers.values),
                                buildingsEnabled: true,
                                indoorViewEnabled: true,
                                mapType: MapType.normal,
                                onMapCreated: (controller) async {
                                  mapLoadTime =
                                      DateTime.now().millisecondsSinceEpoch;
                                  await _onMapCreated();
                                  _mapController.complete(controller);
                                  isButtonVisible = true;
                                  mapLoadTime =
                                      DateTime.now().millisecondsSinceEpoch -
                                          mapLoadTime;
                                },
                                initialCameraPosition: CameraPosition(
                                  target: _initialLatLng,
                                  zoom: 12.0,
                                ),
                                myLocationEnabled: true,
                                onCameraMove: (CameraPosition position) {
                                  if (_markers.length > 0) {
                                    MarkerId markerId =
                                        MarkerId(_markerIdVal());
                                    Marker marker = _markers[markerId];
                                    Marker updatedMarker = marker.copyWith(
                                      positionParam: position.target,
                                    );

                                    setState(() {
                                      _markers[markerId] = updatedMarker;
                                    });
                                  }
                                },
                              ),
                            )),
                          ],
                        ),
                        Positioned(
                          bottom: 15,
                          left: 0,
                          right: 0,
                          child: Container(
                            margin: EdgeInsets.only(
                              left: 100.0,
                              right: 100.0,
                            ),
                            width: 150,
                            child: Visibility(
                                visible: isButtonVisible,
                                child: MaterialButton(
                                  minWidth: 150,
                                  color: AppColors.MAIN_COLOR,
                                  textColor: AppColors.TEXT_WHITE,
                                  disabledColor: AppColors.LIGHT_TEXT_COLOR,
                                  onPressed: () => _submitLocation(
                                      context, widget.onContactCreated),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      'i_am_here',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 18),
                                    ).tr(),
                                  ),
                                )),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          left: 0,
                          child: Container(
                            height: 50,
                            width: 80,
                            child: Text(
                                'Location load time: $locationLoadTime ms\n Map load time: $mapLoadTime ms\n Marker load time: $markerLoadTime ms'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }

  //generate marker when map is created for the first time.
  Future<void> _onMapCreated() async {
    try {
      if (_mapController == null ||
          !(await PermissionUtil.isPermissionGranted())) return;
      _mapController.future.then((controller) async {
        try {
          locationLoadTime = DateTime.now().millisecondsSinceEpoch;

          Position lastKnownPosition = await Geolocator()
              .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);

          _createMarker(lastKnownPosition, controller);

          Position currentLocation = await Geolocator()
              .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

          _createMarker(currentLocation, controller);
          
          locationLoadTime =
              DateTime.now().millisecondsSinceEpoch - locationLoadTime;
        } catch (e) {
          print(e);
        }
      }, onError: (e) {}).catchError((e) {});
    } catch (e) {
      print(e);
    }
  }

  ///create marker according to the given location
  ///this is used only once in onMapCreated() call back function
  _createMarker(Position cameraPosition, GoogleMapController controller) {
    if (cameraPosition != null) {
      controller.animateCamera(CameraUpdate.newLatLngZoom(
          LatLng(cameraPosition.latitude, cameraPosition.longitude), 20.0));
      locationLoadTime =
          DateTime.now().millisecondsSinceEpoch - locationLoadTime;
      markerLoadTime = DateTime.now().millisecondsSinceEpoch;
      MarkerId markerId = MarkerId(_markerIdVal());
      LatLng position =
          LatLng(cameraPosition.latitude, cameraPosition.longitude);
      locationLoadTime =
          DateTime.now().millisecondsSinceEpoch - locationLoadTime;
      Marker marker = Marker(
        markerId: markerId,
        position: position,
        draggable: false,
      );
      markerLoadTime = DateTime.now().millisecondsSinceEpoch - markerLoadTime;
      setState(() {
        _markers[markerId] = marker;
      });
    }
  }

  //add marker to the array list while moving the map.
  String _markerIdVal({bool increment = false}) {
    String val = 'marker_id_$_markerIdCounter';
    if (increment) _markerIdCounter++;
    return val;
  }

  _openLocationInformationDialog(BuildContext ctx) async {
    return await showDialog<void>(
      context: ctx,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          child: SimpleDialog(
            children: <Widget>[
              SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(25.0),
                      child: Text(
                        'Please_allow_access_to_your_device_location',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: AppColors.LIGHT_TEXT_COLOR,
                          fontSize: 15,
                        ),
                      ).tr(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 40.0,
                        right: 40.0,
                        bottom: 0.0,
                      ),
                      child: FlatButton(
                        color: AppColors.BACK_WHITE_COLOR,
                        textColor: AppColors.LIGHT_TEXT_COLOR,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey),
                          borderRadius: new BorderRadius.circular(20),
                        ),
                        child: Text(
                          'i_understand',
                        ).tr(),
                        onPressed: () async {
                          if (await PermissionUtil
                              .isPermanentlyDeniedLocation()) {
                            PermissionUtil.forwardToAppSettings();
                          } else {
                            Navigator.pop(context);
                            if (await PermissionUtil
                                .isLocationPermissonGranted()) {
                              _openGPSInformationDialog(ctx);
                            } else {
                              _openLocationInformationDialog(ctx);
                            }
                          }

                          //if gps enabled and permission granted load current location in map
//                          if (await PermissionUtil
//                                  .isLocationPermissonGranted() &&
//                              await GeolocatorUtil.isGPSEnabled()) {
//                            _onMapCreated();
//                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          onWillPop: () {
            return;
          },
        );
      },
    );
  }

  _openGPSInformationDialog(BuildContext ctx) async {
    return await showDialog<void>(
      context: ctx,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          child: SimpleDialog(
            children: <Widget>[
              SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            size: 60,
                          ),
                          Expanded(
                              child: Container(
                            child: Text(
                              'please_turn_on_GPS',
                              textAlign: TextAlign.left,
                              softWrap: true,
                              maxLines: 3,
                              style: TextStyle(
                                color: AppColors.LIGHT_TEXT_COLOR,
                                fontSize: 15,
                              ),
                            ).tr(),
                          )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 40.0,
                        right: 40.0,
                        bottom: 0.0,
                      ),
                      child: FlatButton(
                        color: AppColors.BACK_WHITE_COLOR,
                        textColor: AppColors.LIGHT_TEXT_COLOR,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey),
                          borderRadius: new BorderRadius.circular(20),
                        ),
                        child: Text(
                          'i_understand',
                        ).tr(),
                        onPressed: () async {
                          Navigator.pop(context);
                          LocationUtil.isGPAvailable();
                          //if location enabled, re-create the google map location
                          if (await GeolocatorUtil.isGPSEnabled()) {
                            _onMapCreated();
                          } else {
                            _openGPSInformationDialog(ctx);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          onWillPop: () {
            return;
          },
        );
      },
    );
  }

  ///register for location updates and update the google map location
  void _createLocationListener() {
    try {
      var locationOptions = LocationOptions(
          accuracy: LocationAccuracy.high,
          distanceFilter: 1,
          timeInterval: 10 * 1000);
      _positionStream = Geolocator()
          .getPositionStream(locationOptions)
          .listen((Position position) {
        try {
          if (_mapController == null) return;

          _mapController.future.then((controller) {
            if (position != null)
              controller.animateCamera(CameraUpdate.newLatLngZoom(
                  LatLng(position.latitude, position.longitude), 12.0));
          }, onError: (e) {}).catchError((e) {});
        } catch (e) {
          print(e);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  ///confirm the selected location and navigate to the next page
  void _submitLocation(BuildContext context, Function onContactCreated) async {
    LatLng selectedLocation;
    if (_markers.length > 0) {
      MarkerId markerId = MarkerId(_markerIdVal());
      selectedLocation = _markers[markerId].position;
    }

    if (selectedLocation == null) {
      Scaffold.of(context).removeCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: AppColors.WARNING_NOTIFY_COLOR_LIGHT,
        content: Text(
            "Invalid location detected. Please select a valid location and continue."),
      ));
      return;
    }

    //move to address registration page
    var value =
        await ExtendedNavigator.rootNavigator.pushNamed(Routes.registrationPage,
            arguments: RegistrationPageArguments(
                onContactCreated: (contactId) {
                  print("Contact Created");
                  onContactCreated(contactId);
                },
                selectedLocation: selectedLocation,
                registrationType: _registrationType,
                contactID: _contactID));
    if (_registrationType == LocationMapPage.REGISTRATION_TYPE_MAIN_ADDRESS) {
      ExtendedNavigator.rootNavigator.pop();
    }
    if (value == 1) ExtendedNavigator.rootNavigator.pop(1);
  }
}

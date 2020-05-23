import 'dart:async';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food_deliver/src/api/models/request/contacts_request_api.dart';
import 'package:food_deliver/src/routes/router.gr.dart';
import 'package:food_deliver/src/ui/dialogs/PopUpDialog.dart';
import 'package:food_deliver/src/utills/geolocator_util.dart';
import 'package:food_deliver/src/utills/location_util.dart';
import 'package:food_deliver/src/utills/permission_util.dart';
import 'package:food_deliver/src/utills/user_auth.dart';
import 'package:food_deliver/src/values/colors.dart';
import 'package:food_deliver/src/viewmodels/register_location_view_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import 'location_map_page.dart';

RegisterLocationViewModel locationViewModel;
// to get places detail (lat/lng)

final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();

class LocationRegisterPage extends StatefulWidget {
  final int registrationType;
  final Function onContactCreated;
  final Function onSave;

  LocationRegisterPage(
      {Key key,
      this.onContactCreated,
      @required this.registrationType,
      this.onSave,
      contactId}) {
    locationViewModel = RegisterLocationViewModel(
        contactId == null ? "" : contactId, registrationType);
  }

  @override
  _LocationRegisterPageState createState() => _LocationRegisterPageState();
}

class _LocationRegisterPageState extends State<LocationRegisterPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isShow = false;
  double _mapOpacity = 1.0;
  double _mapHeight;
  int _registrationType = 1;
  bool isLoaded = false;

  Mode _mode = Mode.overlay;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => locationViewModel,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          leading: _registrationType ==
                  LocationMapPage.REGISTRATION_TYPE_MAIN_ADDRESS
              ? SizedBox()
              : GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back),
                ),
          title: Text(
            _registrationType ==
                        LocationMapPage.REGISTRATION_TYPE_MAIN_ADDRESS ||
                    _registrationType ==
                        LocationMapPage.REGISTRATION_TYPE_SUB_ADDRESS
                ? "Select Location"
                : 'Select Location',
            //  'confirm_your_location',
            textAlign: TextAlign.center,
            //overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.TEXT_WHITE),
          ).tr(),
          toolbarOpacity: 0.5,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: Theme(
              data: Theme.of(context).copyWith(accentColor: Colors.white),
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 4),
                  child: GestureDetector(
                    onTap: () async {
                      if (!isShow) {
                        // show input autocomplete with selected mode
                        // then get the Prediction selected
                        Prediction p = await PlacesAutocomplete.show(
                            context: context,
                            apiKey: RegisterLocationViewModel.kGoogleApiKey,
                            onError: (a) {},
                            mode: _mode,
                            language: "en",
                            components: [Component(Component.country, "lk")],
                            logo: Container(
                              height: 100,
                            ),
                            hint: "Search",
                            overlayBorderRadius: BorderRadius.circular(16),
                            radius: 32);
                        await locationViewModel.displayPrediction(p);
                      }
                    },
                    child: Material(
                      color: AppColors.BACK_WHITE_COLOR,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.search),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  locationViewModel.bottomSheetModel.address ==
                                          null
                                      ? "Location Search"
                                      : locationViewModel
                                          .bottomSheetModel.address,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: AppColors.LIGHT_TEXT_COLOR_MIDDLE),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          iconTheme: IconThemeData(color: AppColors.BACK_WHITE_COLOR),
          backgroundColor: AppColors.MAIN_COLOR,
//          actions: <Widget>[
//            IconButton(
//              icon: Icon(Icons.search, color: AppColors.DARK_TEXT_COLOR,),
//              onPressed: () async {
//                // show input autocomplete with selected mode
//                // then get the Prediction selected
//                Prediction p = await PlacesAutocomplete.show(
//                  context: context,
//                  apiKey: RegisterLocationViewModel.kGoogleApiKey,
//                  onError: (a) {},
//                  mode: _mode,
//                  language: "en",
//                  components: [Component(Component.country, "lk")],
//                  logo: Container(
//                    height: 100,
//                  ),
//                  hint: "Search",
//                  overlayBorderRadius: BorderRadius.circular(16),
//                  radius: 32
//                );
//                await locationViewModel.displayPrediction(p);
//              },
//            ),
//          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 32),
          child: isLoaded
              ? FloatingActionButton.extended(
                  label: !isShow
                      ? Text("Confirm your location")
                      : Text(
                          "Change Location",
                          style: TextStyle(fontSize: 10),
                        ),
                  icon: !isShow
                      ? Icon(Icons.navigate_next)
                      : Icon(Icons.edit_location),
                  backgroundColor: !isShow
                      ? AppColors.MAIN_COLOR
                      : AppColors.DARK_TEXT_COLOR,
                  onPressed: () {
                    // confirm location
                    if (!isShow) {
                      // set bottom navigation
                      if (locationViewModel.bottomSheetModel.lat != null &&
                          locationViewModel.bottomSheetModel.lng != null) {
                        locationViewModel.isUpdating = true;
                        locationViewModel.getAddress(LatLng(
                            locationViewModel.bottomSheetModel.lat,
                            locationViewModel.bottomSheetModel.lng));
                      }
                      var sheetController = _scaffoldKey.currentState
                          .showBottomSheet((context) => BottomSheet(
                              model: locationViewModel.bottomSheetModel,
                              onContactCreated: widget.onContactCreated,
                              onSave: widget.onSave));
                      // bottom navigation close listener
                      sheetController.closed.then((value) {
                        isShow = false;
                        setState(() {
                          _mapOpacity = 1.0;
                          _mapHeight = MediaQuery.of(context).size.height;
                        });
                      });
                      isShow = true;
                      setState(() {
                        _mapOpacity = 0.3;
                        _mapHeight =
                            MediaQuery.of(context).size.height / 2 - 50;
                      });
                    }
                    // change location
                    else {
                      Navigator.pop(context);
                    }
                  },
                )
              : Container(),
        ),
        body: Consumer<RegisterLocationViewModel>(
            builder: (context, model, child) {
          return LocationMap(
            registrationType: widget.registrationType,
            contactID: locationViewModel.updateContactId,
            height: _mapHeight,
            opacity: _mapOpacity,
            onContactCreated: () {},
            onMapLoaded: () {
              setState(() {
                isLoaded = true;
              });
            },
          );
        }),
      ),
    );
  }
}

class BottomSheet extends StatefulWidget {
  final BottomSheetModel model;
  final Function onContactCreated;
  final Function onSave;

  const BottomSheet(
      {Key key, @required this.model, this.onContactCreated, this.onSave})
      : super(key: key);

  @override
  _BottomSheetState createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  TextEditingController fullName = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController houseNo = TextEditingController();
  TextEditingController landmark = TextEditingController();

  setTextFields() {
    Future.delayed(Duration(milliseconds: 100)).then((value) {
      phone.text = widget.model.contactNo != null ? widget.model.contactNo : "";
      fullName.text = widget.model.name != null ? widget.model.name : "";
      houseNo.text = widget.model.houseNo != null ? widget.model.houseNo : "";
      String l = "";
      if (widget.model.landmark != null) {
        widget.model.landmark.forEach((land) {
          l += land + ",";
        });
      }
      landmark.text = l;
      fullName.selection = TextSelection.fromPosition(
          TextPosition(offset: fullName.text.length));
      houseNo.selection =
          TextSelection.fromPosition(TextPosition(offset: houseNo.text.length));
      phone.selection =
          TextSelection.fromPosition(TextPosition(offset: phone.text.length));
      landmark.selection = TextSelection.fromPosition(
          TextPosition(offset: landmark.text.length));
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    phone.selection = TextSelection.fromPosition(
        TextPosition(offset: phone.text.length));
    setTextFields();
    return ChangeNotifierProvider.value(
      value: locationViewModel,
      child: Container(
        height: (MediaQuery.of(context).size.height / 2),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(16), boxShadow: [
          BoxShadow(blurRadius: 10, color: Colors.grey[300], spreadRadius: 5)
        ]),
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 5, left: 8, right: 8, bottom: 5),
            decoration: BoxDecoration(
              color: AppColors.BACK_WHITE_COLOR,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Consumer<RegisterLocationViewModel>(
                builder: (context, model, child) {
              return Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                      child: Text(
                        "Confirm your delivery address",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                        child: Text(
                          model.bottomSheetModel.address != null
                              ? model.bottomSheetModel.address
                              : "Something went wrong",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w300),
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      child: TextFormField(
                        controller: fullName,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Full Name'.tr(),
                        ),
//                            padding: EdgeInsets.symmetric(
//                                vertical: 12, horizontal: 16),
                        style: TextStyle(fontSize: 16),
                        onChanged: (value) {
                          widget.model.name = value.toString();
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'required'.tr();
                          }
                          return null;
                        },
                      ),
                    ),
                    Visibility(
                      visible: locationViewModel.registrationType ==
                              LocationMapPage
                                  .REGISTRATION_TYPE_EDIT_SUB_ADDRESS ||
                          locationViewModel.registrationType ==
                              LocationMapPage.REGISTRATION_TYPE_SUB_ADDRESS,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 20),
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          maxLength: 9,
                          controller: phone,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'contact_no'.tr(),
                          ),
                          style: TextStyle(fontSize: 16),
                          onChanged: (value) {
                            if (value.length > 1 && value[0] == "0") {
                              phone.value = TextEditingValue(
                                  text: int.parse(value.toString()).toString());
                              phone.selection = TextSelection.fromPosition(
                                  TextPosition(offset: phone.text.length));
                            }
                            widget.model.contactNo = value.toString();
                            //print(widget.model.contactNo);
                          },
                          validator: (value) {
                            if (value.length < 9) {
                              return 'required'.tr();
                            }
                            if (value.isEmpty) {
                              return 'required'.tr();
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 24),
                            child: Text(
                              "HouseNo_ApartmentNo",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 12),
                            ).tr()),
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                child: TextFormField(
                                  controller: houseNo,
//                                  padding: EdgeInsets.symmetric(
//                                      vertical: 12, horizontal: 16),
                                  style: TextStyle(fontSize: 16),
                                  onChanged: (value) {
                                    widget.model.houseNo = value.toString();
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "No.".tr(),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                                child: TextFormField(
                                  controller: landmark,
                                  style: TextStyle(fontSize: 16),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "landmark_opt".tr(),
                                  ),
                                  onChanged: (value) {
                                    widget.model.landmark =
                                        value.toString().split(",");
                                  },
                                ),
                              ),
                            ),
                          ],
                        )),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                            child: SaveBtn(
                                formKey: _formKey,
                                onContactCreated: widget.onContactCreated,
                                onSave: widget.onSave),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class SaveBtn extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Function onContactCreated;
  final Function onSave;

  SaveBtn({@required this.formKey, this.onContactCreated, this.onSave});

  @override
  _SaveBtnState createState() => _SaveBtnState();
}

class _SaveBtnState extends State<SaveBtn> {
  @override
  Widget build(BuildContext context) {
    return !locationViewModel.isUpdating
        ? CupertinoButton(
            color: AppColors.MAIN_COLOR,
            child: Text("save").tr(),
            onPressed: () {
              //validate the form and show error if invalid
              if (widget.formKey.currentState.validate()) {
                if (!locationViewModel.isUpdating) {
                  setState(() {
                    locationViewModel.isUpdating = true;
                  });
                  _startRegistrationProcess(context);
                }
              } else {
                Scaffold.of(context).removeCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text('please_enter_valid_Information').tr(),
                ));
              }
            })
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SpinKitDualRing(
                color: AppColors.MAIN_COLOR,
                size: 30,
              ),
            ),
          );
  }

  ///start user address registration process with given [model]
  Future<void> _startRegistrationProcess(BuildContext context) async {
    try {
      if (locationViewModel.registrationType ==
              LocationMapPage.REGISTRATION_TYPE_MAIN_ADDRESS ||
          locationViewModel.registrationType ==
              LocationMapPage.REGISTRATION_TYPE_EDIT_MAIN_ADDRESS)
        await _registerMainAddress(context);
      else
        await _registerSubAddress(context);
    } catch (e) {
      print(e);
      PopupDialogs.showSimplePopDialog(context, "Error", "error_occurred".tr());
      setState(() {
        locationViewModel.isUpdating = false;
      });
    }

    return Future.value();
  }

  ///if user selects to register the main address details execute this method
  Future<void> _registerMainAddress(BuildContext context) async {
    await locationViewModel.createUser(context);
    if (await locationViewModel.isLoggedIn()) {
      Navigator.pop(context);
      if (locationViewModel.registrationType ==
          LocationMapPage.REGISTRATION_TYPE_EDIT_MAIN_ADDRESS) {
        widget.onSave();
        ExtendedNavigator.rootNavigator.pop();
      } else {
        await UserAuth().renewUser();
        ExtendedNavigator.rootNavigator.pop();
        ExtendedNavigator.rootNavigator
            .pushNamed(Routes.navigationPage);
      }
    } else {
      PopupDialogs.showSimplePopDialog(context, "Error", "error_occurred".tr());
      setState(() {
        locationViewModel.isUpdating = false;
      });
    }

    return Future.value();
  }

  ///if user selects to register the sub contact address details execute this method
  Future<void> _registerSubAddress(BuildContext context) async {
    ContactsRequestAPI api;
    if (locationViewModel.registrationType ==
        LocationMapPage.REGISTRATION_TYPE_SUB_ADDRESS) {
      api = await locationViewModel.createNewContact(context);
    } else {
      api = await locationViewModel.updateExistingContact(context);
    }

    if (api != null) {
      print("Contact Creation 01");
      if (locationViewModel.registrationType ==
          LocationMapPage.REGISTRATION_TYPE_SUB_ADDRESS) {
        widget.onContactCreated(api.contactID);
      } else {
        widget.onSave();
      }
      ExtendedNavigator.rootNavigator.pop();
      ExtendedNavigator.rootNavigator.pop();
    } else {
      PopupDialogs.showSimplePopDialog(context, "Error", "error_occurred".tr());
      setState(() {
        locationViewModel.isUpdating = false;
      });
    }

    return Future.value();
  }
}

class LocationMap extends StatefulWidget {
  final double opacity;
  final Function onMapLoaded;
  final Function onContactCreated;
  final int registrationType;
  final String contactID;
  final double height;

  const LocationMap(
      {Key key,
      this.onContactCreated,
      this.opacity,
      this.height,
      this.onMapLoaded,
      this.registrationType,
      this.contactID})
      : super(key: key);

  @override
  _LocationMapState createState() =>
      _LocationMapState(registrationType, contactID);
}

class _LocationMapState extends State<LocationMap> {
  final _initialLatLng = LatLng(7.261897, 80.531342); //location of Sri Lanka
  final int _registrationType;
  final String _contactID;
  bool isButtonVisible = false;

  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  int _markerIdCounter = 0;
  Completer<GoogleMapController> _mapController = Completer();

  StreamSubscription<Position> _positionStream;

  //_LocationMapPageState(this._registrationType, this._contactID);

  int locationLoadTime = 0;
  int mapLoadTime = 0;
  int markerLoadTime = 0;

  _LocationMapState(this._registrationType, this._contactID);

  Mode _mode = Mode.overlay;

  @override
  void initState() {
    super.initState();

    //register for location updates and update the google map location
    //_createLocationListener();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        if (!await PermissionUtil.isPermissionGranted()) {
          if (!await PermissionUtil.isPermanentlyDeniedLocation()) {
            _openLocationInformationDialog(context); //permission information
          } // pop up
          else {
            _initialMove();
          }
        } else if (!await GeolocatorUtil.isGPSEnabled()) {
          _openGPSInformationDialog(context); //gps information pop up
        }
      },
    );
  }

  @override
  void dispose() {
    if (_positionStream != null) _positionStream.cancel();
    super.dispose();
  }

  GlobalKey mapKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (locationViewModel.bottomSheetModel.lat != null &&
        locationViewModel.isChanged) {
      _setToPosition(locationViewModel.bottomSheetModel.lat,
          locationViewModel.bottomSheetModel.lng);
      locationViewModel.isChanged = false;
      print("Changed");
    }
    return AbsorbPointer(
      absorbing: widget.opacity != null && widget.opacity == 0.3,
      child: Opacity(
        opacity: widget.opacity == null ? 1.0 : widget.opacity,
        child: SafeArea(
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
                                height: widget.height == null
                                    ? MediaQuery.of(context).size.height
                                    : widget.height,
                                width: MediaQuery.of(context).size.width,
                                child: GoogleMap(
                                  key: mapKey,
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
                                      widget.onMapLoaded();
                                      MarkerId markerId =
                                          MarkerId(_markerIdVal());
                                      Marker marker = _markers[markerId];
                                      Marker updatedMarker = marker.copyWith(
                                        positionParam: position.target,
                                      );

                                      locationViewModel.setAddress(
                                          position.target.latitude,
                                          position.target.longitude);

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
                                  visible: false,
                                  child: MaterialButton(
                                    minWidth: 150,
                                    color: AppColors.MAIN_COLOR,
                                    textColor: AppColors.TEXT_WHITE,
                                    disabledColor: AppColors.LIGHT_TEXT_COLOR,
                                    onPressed: () => _submitLocation(
                                        context, widget.onContactCreated),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(20),
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
//                          Positioned(
//                            top: 0,
//                            right: 0,
//                            left: 0,
//                            child: Container(
//                              height: 50,
//                              width: 80,
//                              child: Text(
//                                  'Location load time: $locationLoadTime ms\n Map load time: $mapLoadTime ms\n Marker load time: $markerLoadTime ms'),
//                            ),
//                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )),
      ),
    );
  }

  //generate marker when map is created for the first time.
  Future<void> _onMapCreated() async {
    try {
      if ((locationViewModel.registrationType ==
                  LocationMapPage.REGISTRATION_TYPE_EDIT_MAIN_ADDRESS ||
              locationViewModel.registrationType ==
                  LocationMapPage.REGISTRATION_TYPE_EDIT_SUB_ADDRESS) &&
          locationViewModel.isFirstTime) {
        locationViewModel.isFirstTime = false;
        return;
      }

      if (_mapController == null ||
          !(await PermissionUtil.isPermissionGranted())) return;
      _mapController.future.then((controller) async {
        try {
          locationLoadTime = DateTime.now().millisecondsSinceEpoch;

          Position lastKnownPosition = await Geolocator()
              .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);

          _createMarker(lastKnownPosition, controller, 20.0);

          Position currentLocation = await Geolocator()
              .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

          _createMarker(currentLocation, controller, 20.0);

          locationLoadTime =
              DateTime.now().millisecondsSinceEpoch - locationLoadTime;
        } catch (e) {
          print(e);
        }
      }, onError: (e) {}).catchError((e) {});

//      if (_mapController == null ||
//          !(await PermissionUtil.isPermissionGranted())) return;
//
//      _mapController.future.then((controller) async {
//        try {
////          locationLoadTime = DateTime.now().millisecondsSinceEpoch;
////          Position currentLocation = await Geolocator()
////              .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
////          locationLoadTime =
////              DateTime.now().millisecondsSinceEpoch - locationLoadTime;
////          if (currentLocation != null) {
////            controller.animateCamera(CameraUpdate.newLatLngZoom(
////                LatLng(currentLocation.latitude, currentLocation.longitude),
////                20.0));
////            locationLoadTime =
////                DateTime.now().millisecondsSinceEpoch - locationLoadTime;
////            markerLoadTime = DateTime.now().millisecondsSinceEpoch;
////            MarkerId markerId = MarkerId(_markerIdVal());
////            LatLng position =
////                LatLng(currentLocation.latitude, currentLocation.longitude);
////            locationLoadTime =
////                DateTime.now().millisecondsSinceEpoch - locationLoadTime;
////            Marker marker = Marker(
////              markerId: markerId,
////              position: position,
////              draggable: false,
////            );
////            markerLoadTime =
////                DateTime.now().millisecondsSinceEpoch - markerLoadTime;
////            setState(() {
////              _markers[markerId] = marker;
////            });
////          }
//        } catch (e) {
//          print(e);
//        }
//      }, onError: (e) {}).catchError((e) {});
    } catch (e) {
      print(e);
    }
  }

  _initialMove() async {
    try {
      if ((locationViewModel.registrationType ==
                  LocationMapPage.REGISTRATION_TYPE_EDIT_MAIN_ADDRESS ||
              locationViewModel.registrationType ==
                  LocationMapPage.REGISTRATION_TYPE_EDIT_SUB_ADDRESS) &&
          locationViewModel.isFirstTime) {
        locationViewModel.isFirstTime = false;
        return;
      }

      if (_mapController == null) return;
      if (!await PermissionUtil.isPermissionGranted() &&
          locationViewModel.bottomSheetModel.lat == 0) {
        _mapController.future.then((controller) async {
          try {
            locationLoadTime = DateTime.now().millisecondsSinceEpoch;

            Position lastKnownPosition = Position(
              latitude: 7.261897,
              longitude: 80.531342,
            );
            double zoom = 16.0;
            _createMarker(lastKnownPosition, controller, zoom);
          } catch (e) {
            print(e);
          }
        }, onError: (e) {}).catchError((e) {});
      }
    } catch (e) {
      print(e);
    }
  }

  ///create marker according to the given location
  ///this is used only once in onMapCreated() call back function
  _createMarker(
      Position cameraPosition, GoogleMapController controller, double zoom) {
    if (cameraPosition != null) {
      controller.animateCamera(CameraUpdate.newLatLngZoom(
          LatLng(cameraPosition.latitude, cameraPosition.longitude), zoom));
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

  //generate marker when map is created for the first time.
  Future<void> _setToPosition(double latitude, double longitude) async {
    try {
      if (_mapController == null) return;

      _mapController.future.then((controller) async {
        try {
          if (latitude != null && longitude != null) {
            controller.animateCamera(
                CameraUpdate.newLatLngZoom(LatLng(latitude, longitude), 20.0));
            MarkerId markerId = MarkerId(_markerIdVal());
            LatLng position = LatLng(latitude, longitude);
            Marker marker = Marker(
              markerId: markerId,
              position: position,
              draggable: false,
            );
            setState(() {
              _markers[markerId] = marker;
            });
          }
        } catch (e) {
          print(e);
        }
      }, onError: (e) {}).catchError((e) {});
    } catch (e) {
      print(e);
    }
  }

  //add marker to the array list while moving the map.
  String _markerIdVal({bool increment = false}) {
    String val = 'marker_id_$_markerIdCounter';
    if (increment) _markerIdCounter++;
    return val;
  }

  _openLocationInformationDialog(BuildContext ctx) async {
    if (await PermissionUtil.isPermanentlyDeniedLocation()) {

    } else {
      if (await PermissionUtil.isLocationPermissonGranted()) {
        _openGPSInformationDialog(ctx);
      } else {
        _initialMove();
      }
    }
//    return await showDialog<void>(
//      context: ctx,
//      barrierDismissible: false, // user must tap button!
//      builder: (BuildContext context) {
//        return WillPopScope(
//          child: SimpleDialog(
//            children: <Widget>[
//              SingleChildScrollView(
//                child: ListBody(
//                  children: <Widget>[
//                    Padding(
//                      padding: EdgeInsets.all(25.0),
//                      child: Text(
//                        'Please_allow_access_to_your_device_location',
//                        textAlign: TextAlign.left,
//                        style: TextStyle(
//                          color: AppColors.LIGHT_TEXT_COLOR,
//                          fontSize: 15,
//                        ),
//                      ).tr(),
//                    ),
//                    Padding(
//                      padding: EdgeInsets.only(
//                        left: 40.0,
//                        right: 40.0,
//                        bottom: 0.0,
//                      ),
//                      child: FlatButton(
//                        color: AppColors.BACK_WHITE_COLOR,
//                        textColor: AppColors.LIGHT_TEXT_COLOR,
//                        shape: RoundedRectangleBorder(
//                          side: BorderSide(color: Colors.grey),
//                          borderRadius: new BorderRadius.circular(20),
//                        ),
//                        child: Text(
//                          'i_understand',
//                        ).tr(),
//                        onPressed: () async {
//                          if (await PermissionUtil
//                              .isPermanentlyDeniedLocation()) {
////                            PermissionUtil.forwardToAppSettings();
//                          } else {
//                            Navigator.pop(context);
//                            if (await PermissionUtil
//                                .isLocationPermissonGranted()) {
//                              _openGPSInformationDialog(ctx);
//                            } else {
////                              _openLocationInformationDialog(ctx);
//                            _initialMove();
//                            }
//                          }
//
//                          //if gps enabled and permission granted load current location in map
////                          if (await PermissionUtil
////                                  .isLocationPermissonGranted() &&
////                              await GeolocatorUtil.isGPSEnabled()) {
////                            _onMapCreated();
////                          }
//                        },
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//            ],
//          ),
//          onWillPop: () {
//            return;
//          },
//        );
//      },
//    );
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

//Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
//  if (p != null) {
//    // get detail (lat/lng)
//    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
//    final lat = detail.result.geometry.location.lat;
//    final lng = detail.result.geometry.location.lng;
//
//    print("${p.description} - $lat/$lng");
//
//
////    scaffold.showSnackBar(
////      SnackBar(content: Text("${p.description} - $lat/$lng")),
////    );
//  }
//}

// custom scaffold that handle search
// basically your widget need to extends [GooglePlacesAutocompleteWidget]
// and your state [GooglePlacesAutocompleteState]
class CustomSearchScaffold extends PlacesAutocompleteWidget {
  CustomSearchScaffold()
      : super(
          apiKey: RegisterLocationViewModel.kGoogleApiKey,
          sessionToken: Uuid().generateV4(),
          language: "en",
          components: [Component(Component.country, "uk")],
        );

  @override
  _CustomSearchScaffoldState createState() => _CustomSearchScaffoldState();
}

class _CustomSearchScaffoldState extends PlacesAutocompleteState {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(title: AppBarPlacesAutoCompleteTextField());
    final body = PlacesAutocompleteResult(
      onTap: (p) {
//        displayPrediction(p, searchScaffoldKey.currentState);
      },
      logo: Row(
        children: [FlutterLogo()],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
    return Scaffold(key: searchScaffoldKey, appBar: appBar, body: body);
  }

  @override
  void onResponseError(PlacesAutocompleteResponse response) {
    super.onResponseError(response);
    searchScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  @override
  void onResponse(PlacesAutocompleteResponse response) {
    super.onResponse(response);
    if (response != null && response.predictions.isNotEmpty) {
      searchScaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Got answer")),
      );
    }
  }
}

class Uuid {
  final Random _random = Random();

  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}

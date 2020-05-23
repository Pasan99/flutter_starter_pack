import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_deliver/src/ui/pages/registration/location_map_page.dart';
import 'package:food_deliver/src/routes/router.gr.dart';
import 'package:food_deliver/src/ui/dialogs/PopUpDialog.dart';
import 'package:food_deliver/src/ui/widgets/otp_expire_timer.dart';
import 'package:food_deliver/src/utills/user_auth.dart';
import 'package:food_deliver/src/values/colors.dart';
import 'package:food_deliver/src/viewmodels/config_viewmodel.dart';
import 'package:food_deliver/src/viewmodels/otp_verification_view_model.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:food_deliver/src/ext/string_extension.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;

  OtpVerificationPage({@required this.phoneNumber, Key key}) : super(key: key);

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  TextEditingController _otpNo1Controller = new TextEditingController();
  TextEditingController _otpNo2Controller = new TextEditingController();
  TextEditingController _otpNo3Controller = new TextEditingController();
  TextEditingController _otpNo4Controller = new TextEditingController();

  FocusNode _otpNo1FocusNode = new FocusNode();
  FocusNode _otpNo2FocusNode = new FocusNode();
  FocusNode _otpNo3FocusNode = new FocusNode();
  FocusNode _otpNo4FocusNode = new FocusNode();
  FocusNode _hideKeyboard = new FocusNode();

  int _state = 0;

  KeyboardVisibilityNotification _keyboardVisibility =
      new KeyboardVisibilityNotification();
  int _keyboardVisibilitySubscriberId;
  bool _keyboardState;

  var bottomPadding = ValueNotifier(EdgeInsets.only(bottom: 10, right: 15));
  OtpVerificationViewModel otpModel;

  Timmer _otpExpireTimer;

  bool isSubmitDisabled = false;

//    creating a timer for updates:
  Timer clipboardTriggerTime;

  OtpVerificationViewModel _viewModel;

  @override
  void initState() {
    _viewModel =
        OtpVerificationViewModel(context, phoneNumber: widget.phoneNumber);
    _subscribeToClipboardListener();
    super.initState();

    _otpExpireTimer = Timmer(
      mobileNo: widget.phoneNumber,
      callback: disableButton,
    );

    //_keyboardState = _keyboardVisibility.isKeyboardVisible;

    KeyboardVisibilityNotification().addNewListener(
      onHide: () {
        bottomPadding.value = EdgeInsets.only(bottom: 10, right: 15);
      },
      onShow: () {
        bottomPadding.value = EdgeInsets.only(bottom: 0, right: 0);
      },
      onChange: (bool visible) {
        print(visible);
      },
    );
  }

  @override
  void dispose() {
    _keyboardVisibility.removeListener(_keyboardVisibilitySubscriberId);

    clipboardTriggerTime.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Provider(
        create: (context) => _viewModel,
        child: Scaffold(
          body: SafeArea(
            minimum: EdgeInsets.only(left: 0.0, right: 0.0),
            child: Container(
              color: AppColors.BACK_WHITE_COLOR,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints con) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: con.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            verticalDirection: VerticalDirection.down,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 18),
                              ),
                              Image.asset("assets/images/verification_illustration.png", height: 200,),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  '4 digit verification code has been sent to ' +
                                      widget.phoneNumber,
                                  textAlign: TextAlign.center,
                                  //overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ).tr(),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                              ),

                              Expanded(
                                child: Container(
                                  height: 25.0,
                                  child: new GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isSubmitDisabled = false;
                                      });
                                      _keyboardVisibility.removeListener(
                                          _keyboardVisibilitySubscriberId);
                                      ExtendedNavigator.of(context)
                                          .pushReplacementNamed(
                                              Routes.phoneNumberRegisterPage);

                                    },
                                    child: Text(
                                      'change_mobile_number',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: AppColors.WARNING_NOTIFY_COLOR),
                                    ).tr(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Consumer<OtpVerificationViewModel>(
                                    builder: (context, model, child) {
                                      return SizedBox(
                                        width: 25,
                                        child: TextField(
                                          inputFormatters: [
                                            WhitelistingTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(1),
                                          ],
                                          style: TextStyle(
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          onChanged: (text) async {
                                            if (text.length != 0)
                                              FocusScope.of(context)
                                                  .requestFocus(_otpNo2FocusNode);
                                          },
                                          controller: _otpNo1Controller,
                                          focusNode: _otpNo1FocusNode,
                                          autofocus: true,
                                          textInputAction: TextInputAction.next,
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          decoration: new InputDecoration(
                                            labelStyle: new TextStyle(
                                                color: AppColors.TEXT_SUCCESS),
                                            border: new UnderlineInputBorder(
                                              borderSide: new BorderSide(
                                                  color: AppColors.TEXT_SUCCESS),
                                            ),
                                            enabledBorder: new UnderlineInputBorder(
                                              borderSide: new BorderSide(
                                                  color: AppColors.TEXT_SUCCESS),
                                            ),
                                            focusedBorder: new UnderlineInputBorder(
                                              borderSide: new BorderSide(
                                                  color: AppColors.TEXT_SUCCESS),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20)),
                                  Consumer<OtpVerificationViewModel>(
                                    builder: (context, model, child) {
                                      return SizedBox(
                                        width: 25,
                                        child: TextField(
                                          inputFormatters: [
                                            WhitelistingTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(1),
                                          ],
                                          style: TextStyle(
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          onChanged: (text) async {
                                            if (text.length != 0) {
                                              FocusScope.of(context)
                                                  .requestFocus(_otpNo3FocusNode);
                                            } else
                                              FocusScope.of(context)
                                                  .requestFocus(_otpNo1FocusNode);
                                          },
                                          focusNode: _otpNo2FocusNode,
                                          controller: _otpNo2Controller,
                                          autofocus: true,
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          decoration: new InputDecoration(
                                            labelStyle: new TextStyle(
                                                color: AppColors.TEXT_SUCCESS),
                                            border: new UnderlineInputBorder(
                                              borderSide: new BorderSide(
                                                  color: AppColors.TEXT_SUCCESS),
                                            ),
                                            enabledBorder: new UnderlineInputBorder(
                                              borderSide: new BorderSide(
                                                  color: AppColors.TEXT_SUCCESS),
                                            ),
                                            focusedBorder: new UnderlineInputBorder(
                                              borderSide: new BorderSide(
                                                  color: AppColors.TEXT_SUCCESS),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20)),
                                  Consumer<OtpVerificationViewModel>(
                                    builder: (context, model, child) {
                                      return SizedBox(
                                        width: 25,
                                        child: TextField(
                                          inputFormatters: [
                                            WhitelistingTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(1),
                                          ],
                                          style: TextStyle(
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          onChanged: (text) async {
                                            if (text.length != 0) {
                                              FocusScope.of(context)
                                                  .requestFocus(_otpNo4FocusNode);
                                            } else
                                              FocusScope.of(context)
                                                  .requestFocus(_otpNo2FocusNode);
                                          },
                                          focusNode: _otpNo3FocusNode,
                                          controller: _otpNo3Controller,
                                          autofocus: true,
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          decoration: new InputDecoration(
                                            labelStyle: new TextStyle(
                                                color: AppColors.TEXT_SUCCESS),
                                            enabledBorder: new UnderlineInputBorder(
                                              borderSide: new BorderSide(
                                                  color: AppColors.TEXT_SUCCESS),
                                            ),
                                            focusedBorder: new UnderlineInputBorder(
                                              borderSide: new BorderSide(
                                                  color: AppColors.TEXT_SUCCESS),
                                            ),
                                            border: new UnderlineInputBorder(
                                              borderSide: new BorderSide(
                                                  color: AppColors.TEXT_SUCCESS),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20)),
                                  Consumer<OtpVerificationViewModel>(
                                      builder: (context, model, child) {
                                    return SizedBox(
                                      width: 25,
                                      child: TextField(
                                        inputFormatters: [
                                          WhitelistingTextInputFormatter.digitsOnly,
                                          LengthLimitingTextInputFormatter(1),
                                        ],
                                        style: TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        onChanged: (text) async {
                                          if (text.length != 0) {
                                            //_submit(context, model);
                                            FocusScope.of(context)
                                                .requestFocus(_hideKeyboard);
                                          } else
                                            FocusScope.of(context)
                                                .requestFocus(_otpNo3FocusNode);
                                        },
                                        focusNode: _otpNo4FocusNode,
                                        controller: _otpNo4Controller,
                                        autofocus: true,
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        decoration: new InputDecoration(
                                          labelStyle: new TextStyle(
                                              color: AppColors.TEXT_SUCCESS),
                                          enabledBorder: new UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: AppColors.TEXT_SUCCESS),
                                          ),
                                          focusedBorder: new UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: AppColors.TEXT_SUCCESS),
                                          ),
                                          border: new UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: AppColors.TEXT_SUCCESS),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
//                      GestureDetector(
//                        onTap: () {
//                          _otpNo1Controller.text = '';
//                          _otpNo2Controller.text = '';
//                          _otpNo3Controller.text = '';
//                          _otpNo4Controller.text = '';
//                          FocusScope.of(context).requestFocus(_otpNo1FocusNode);
//                        },
//                        child: Text(
//                          Strings.OTP_VERIFY_PAGE_CODE_EDIT_TEXT,
//                          textAlign: TextAlign.center,
//                          //  overflow: TextOverflow.ellipsis,
//                          style: TextStyle(
//                              fontWeight: FontWeight.normal, fontSize: 16),
//                        ),
//                      ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                              _otpExpireTimer,
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                              ),
                              Expanded(child: Container()),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          floatingActionButton: Consumer<OtpVerificationViewModel>(
            builder: (context, model, child) {
              return ValueListenableBuilder(
                valueListenable: bottomPadding,
                builder: (BuildContext context, EdgeInsetsGeometry val,
                    Widget child) {
                  return Container(
                    alignment: Alignment.bottomRight,
                    margin: val,
                    child: FloatingActionButton(
                      backgroundColor: AppColors.MAIN_COLOR,
                      elevation: 0,
                      onPressed: () async {
                          if (!isSubmitDisabled) _submit(context, model);
                      },
                      child: Icon(Icons.navigate_next)
                    ),
                  );
                },
              );
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        ),
      ),
    );
  }

  _clearAndRefocus(){
    _otpNo1Controller.text = "";
    _otpNo2Controller.text = "";
    _otpNo3Controller.text = "";
    _otpNo4Controller.text = "";
    FocusScope.of(context)
        .requestFocus(_otpNo1FocusNode);
  }

  _submit(BuildContext context, OtpVerificationViewModel model) async {
    try {
      PopupDialogs.showLoadingDialog(context, 'please_wait'.tr());
      if (await model.isLoggedIn()) {
        // if phone number exist
        if (await model.validateOtpCode(
            _otpNo1Controller.text +
                _otpNo2Controller.text +
                _otpNo3Controller.text +
                _otpNo4Controller.text,
            context)) {
          // if otp verified

          //await ConfigViewModel().getAndSaveConfig(context);
//          await CreateDistrictAndCityViewModel()
//              .retrieveAndSaveDisWithCities(context);

          _keyboardVisibility.removeListener(_keyboardVisibilitySubscriberId);
          Navigator.pop(context);
          if (model.cloudUser != null && model.cloudUser.cityId != null) {
            PopupDialogs.showLoadingDialog(context, 'login_user'.tr());
            await model.saveUserInLocalDb(model.cloudUser);
            await UserAuth().renewUser();
            Navigator.pop(context);
            PopupDialogs.isShowingLodingDialog = false;
            ExtendedNavigator.of(context).pop();
            ExtendedNavigator.rootNavigator.pushNamed(
                Routes.navigationPage);
          }
          else {
            PopupDialogs.isShowingLodingDialog = false;
            ExtendedNavigator.rootNavigator.pushReplacementNamed(
                Routes.locationRegisterPage,
                arguments: LocationRegisterPageArguments(
                    registrationType:
                    LocationMapPage.REGISTRATION_TYPE_MAIN_ADDRESS));
          }
//        Navigator.pushReplacement(
//            context,
//            MaterialPageRoute(
//                builder: (context) => LocationMapPage(
//                    LocationMapPage.REGISTRATION_TYPE_EDIT_MAIN_ADDRESS)));
        } else {
//        if (PopupDialogs.isShowingLodingDialog) {
//          PopupDialogs.isShowingLodingDialog = false;
//          Navigator.pop(context);
//        }
          PopupDialogs.showSimplePopDialogWithListener(
              context, 'incorrect_otp_heading'.tr(), 'incorrect_otp'.tr(), (){
            _clearAndRefocus();
          });
        }
      }
    } catch(e){
      Navigator.pop(context);
      PopupDialogs.isShowingLodingDialog = false;
      PopupDialogs.showSimpleNetworkRetry(context, "Network Error", "connection_issue_message".tr(), (){
        _submit(context, model);
        Navigator.pop(context);
        PopupDialogs.isSimplePopClosed = true;
      });
    }
  }

  detecPin(BuildContext context, OtpVerificationViewModel model) async {
    ClipboardData data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null && data.text.length == 4) {
      _otpNo1Controller.text = data.text.substring(0, 1);
      _otpNo2Controller.text = data.text.substring(1, 2);
      _otpNo3Controller.text = data.text.substring(2, 3);
      _otpNo4Controller.text = data.text.substring(3);
      _submit(context, model);
    }
  }

  _subscribeToClipboardListener() {
    clipboardTriggerTime = Timer.periodic(
//        you can specify any duration you want, roughly every 20 read from the system
      const Duration(seconds: 3),
      (timer) {
        Clipboard.getData('text/plain').then((clipboarContent) async {
          if (clipboarContent != null &&
              !clipboarContent.text.isInvalid() &&
              clipboarContent.text.length == 4) {
            await detecPin(context, _viewModel);
            Clipboard.setData(ClipboardData(text: ''));
          }
        });
      },
    );
  }

  void disableButton() {
    setState(() {
      isSubmitDisabled = !isSubmitDisabled;
    });
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_deliver/src/routes/router.gr.dart';
import 'package:food_deliver/src/ui/widgets/custom_country_picker.dart';
import 'package:food_deliver/src/ui/dialogs/PopUpDialog.dart';
import 'package:food_deliver/src/values/colors.dart';
import 'package:food_deliver/src/viewmodels/otp_verification_view_model.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneNumberRegisterPage extends StatefulWidget {
// final Strings phno ;
//
//  PhoneNumberRegisterPage({@required this.phno});

  PhoneNumberRegisterPage({Key key}) : super(key: key);

  @override
  _PhoneNumberRegisterPageState createState() =>
      _PhoneNumberRegisterPageState();
}

class _PhoneNumberRegisterPageState extends State<PhoneNumberRegisterPage> {
  final _countryPicker = CustomCountryPicker();

  bool _changeColor = false;

  TextEditingController _mob_num_controller = TextEditingController();
  TextEditingController tec = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int _state = 0;

  var bottomPadding = ValueNotifier(EdgeInsets.only(bottom: 10, right: 15));

  KeyboardVisibilityNotification _keyboardVisibility =
      new KeyboardVisibilityNotification();
  int _keyboardVisibilitySubscriberId;
  bool _keyboardState;

  @override
  void initState() {
    super.initState();

    _keyboardState = _keyboardVisibility.isKeyboardVisible;

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
    super.dispose();
  }

  int lastVal = 0;

  @override
  Widget build(BuildContext context) {
    _mob_num_controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _mob_num_controller.text.length));

    return Provider(
      create: (context) => OtpVerificationViewModel(context, phoneNumber: ""),
      child: Scaffold(
        body: Container(
          color: AppColors.BACK_WHITE_COLOR,
          child: Form(
            key: _formKey,
            child: SafeArea(
              minimum: EdgeInsets.only(left: 30.0, right: 30.0),
              child: new LayoutBuilder(
                builder: (BuildContext context, BoxConstraints con) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SingleChildScrollView(
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
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              Image.asset("assets/images/phone_illustration.png"),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 24, 0),
                                child: Text(
                                  'sign_up_with_your_mobile_number',
                                  textAlign: TextAlign.left,
                                  //overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300, fontSize: 28),
                                ).tr(),
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "LK +94",
                                      style: TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(2, 16, 25, 8),
                                      child: TextFormField(
                                        keyboardType: TextInputType.phone,
                                        maxLength: 9,
                                        controller: _mob_num_controller,
                                        onChanged: (value) {
                                          if (value.length > 1 && value[0] == "0") {
                                            _mob_num_controller.value = TextEditingValue(
                                                text: int.parse(value.toString()).toString());
                                            _mob_num_controller.selection = TextSelection.fromPosition(
                                                TextPosition(offset: _mob_num_controller.text.length));
                                          }
                                        },
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Cannot be Empty';
                                          } else if (value.length < 9) {
                                            return 'Please enter valid phone number';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            hintText: "776788982",
                                            hintStyle: TextStyle(
                                                color: AppColors
                                                    .LIGHTER_TEXT_COLOR)),
                                        style: TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        inputFormatters: [
                                          WhitelistingTextInputFormatter
                                              .digitsOnly
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 35),
                                child: GestureDetector(
                                  onTap: () {
                                    _launchURL();
                                  },
                                  child: Text(
                                    'policy_signup',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14),
                                    textAlign: TextAlign.left,
                                  ).tr(),
                                ),
                              ),
                              new Center(
                                child: new RichText(
                                  text: new TextSpan(
                                    children: [
                                      new TextSpan(
                                        text: 'Privacy & Policy',
                                        style: new TextStyle(color: Colors.blue),
                                        recognizer: new TapGestureRecognizer()
                                          ..onTap = () {
                                            _launchURL();
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(child: Container()),
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10)),

                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10)),
                            ],
                          ),
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
              builder:
                  (BuildContext context, EdgeInsetsGeometry val, Widget child) {
                return Container(
                  alignment: Alignment.bottomRight,
                  margin: val,
                  child: FloatingActionButton.extended(
                    label: Text("Next"),
                    backgroundColor: AppColors.MAIN_COLOR,
                    elevation: 0,
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        model.phoneNumber = "+94" + _mob_num_controller.text;
                        PopupDialogs.showLoadingDialog(
                            context, 'please_wait'.tr());
                        if (await model.createUser(context) != null) {
                          if (await model.saveInLocalDb()) {
                            PopupDialogs.isShowingLodingDialog = false;
                            ExtendedNavigator.of(context).pop();
                            ExtendedNavigator.of(context).pushReplacementNamed(
                                Routes.otpVerificationPage,
                                arguments: OtpVerificationPageArguments(
                                    phoneNumber:
                                        "+94" + _mob_num_controller.text));
//                            Navigator.pushReplacement(
//                                context,
//                                MaterialPageRoute(
//                                    builder: (context) => OtpVerificationPage(
//                                        phoneNumber:
//                                            '+94' + _mob_num_controller.text)));
                          }
                        } else {
//                        if (PopupDialogs.isShowingLodingDialog) {
//                          PopupDialogs.isShowingLodingDialog = false;
//                          Navigator.pop(context);
//                        }
                        print("Here");
                          PopupDialogs.showSimplePopDialog(context, 'Error',
                              'Something_wrong_Please_try_again'.tr());
                        }
                      }
                    },
                    icon: Icon(Icons.navigate_next),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        /*),*/
      ),
    );
  }

  _launchURL() async {
    const url = 'https://www.fairspace.lk';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

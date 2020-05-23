import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_deliver/src/values/strings.dart';
import 'package:food_deliver/src/viewmodels/otp_verification_view_model.dart';

class Timmer extends StatefulWidget {
  final String deviceID;
  final String countryCode;
  final String mobileNo;
  final String handShakeToken;
  final VoidCallback callback;

  const Timmer({
    this.deviceID,
    this.countryCode,
    this.mobileNo,
    this.handShakeToken,
    this.callback,
  });

  @override
  State<StatefulWidget> createState() {
    return _Timmer();
  }
}

class _Timmer extends State<Timmer> {
  final _start = ValueNotifier(60);
  Timer _timer;
  String _mobileNo;
  VoidCallback _callback;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (timer) => setState(
        () {
          if (_start.value < 1) {
            _callback();
            setState(() {});
            timer.cancel();
          } else {
            _start.value = _start.value - 1;
          }
        },
      ),
    );
  }

  @override
  void initState() {
    this._mobileNo = widget.mobileNo;
    this._callback = widget.callback;
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final assetsImage = new AssetImage('assets/images/1.png');
    var image = new Align(
      child: Image(
        image: assetsImage,
        width: 30,
        height: 30,
      ),
      alignment: Alignment.center,
    );

    var resendSms = GestureDetector(
        onTap: () async {
          if (_start.value == 0) {
            //resend otp
            if (await OtpVerificationViewModel(context, phoneNumber: _mobileNo)
                    .createUser(context) !=
                null)
              setState(() {
                print('start timer');
                _start.value = 60;
                startTimer();
                _callback();
              });
          }
        },
        child: ValueListenableBuilder<int>(
          valueListenable: _start,
          builder: (context, value, child) {
            return Text(
              _start.value == 0
                  ? 'Resend SMS'
                  : 'Resend SMS in ' + _start.value.toString() + ' seconds',
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: _start.value == 0 ? Colors.black : Colors.grey),
              textAlign: TextAlign.center,
            );
          },
        ));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        image,
        new Padding(padding: const EdgeInsets.symmetric(horizontal: 5)),
        resendSms
      ],
    );
  }
}

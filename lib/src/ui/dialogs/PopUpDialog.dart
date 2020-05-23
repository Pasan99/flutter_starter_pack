import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_deliver/src/anim/fade_in.dart';
import 'package:food_deliver/src/values/colors.dart';

class PopupDialogs {
  static bool isSimplePopClosed =
      true; //close or open state of the simple pop dialog
  static bool isShowingLodingDialog = false;
  static bool isNetworkError = false;

  static showSimplePopDialog(
      BuildContext context, String title, String message) {
    //show a new dialog only if the previous dialog is closed.
    if (isSimplePopClosed) {
      isNetworkError = true;
      isSimplePopClosed = false;
      // flutter defined function
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return FadeIn(
            0.5, WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                title: new Text(title != null ? title : ""),
                content: new Text(message != null ? message : ""),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  new FlatButton(
                    child: new Text("Close"),
                    onPressed: () {
                      isSimplePopClosed = true;
                      Navigator.of(context).pop();
                      if (PopupDialogs.isShowingLodingDialog) {
                        PopupDialogs.isShowingLodingDialog = false;
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
            ),
          );
        },
      );
    }
  }

  static showSimplePopDialogWithImage(
      {@required BuildContext context,
      @required String title,
      @required String message,
      @required String imageUrl}) {
    //show a new dialog only if the previous dialog is closed.
    if (isSimplePopClosed) {
      isNetworkError = true;
      isSimplePopClosed = false;
      // flutter defined function
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return FadeIn(0.5, WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: Column(
                children: <Widget>[
                  Container(
                    height: 16,
                  ),
                  Image.asset(
                    imageUrl,
                    height: 50,
                    width: 50,
                  ),
                  Container(
                    height: 16,
                  ),
                  Text(
                    title != null ? title : "",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              content: new Text(
                message != null ? message : "",
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new FlatButton(
                      child: new Text("Close"),
                      onPressed: () {
                        isSimplePopClosed = true;
                        Navigator.of(context).pop();
                        if (PopupDialogs.isShowingLodingDialog) {
                          PopupDialogs.isShowingLodingDialog = false;
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
              ],
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
          ));
        },
      );
    }
  }

  static showSimplePopDialogWithListener(
      BuildContext context, String title, String message, Function onClose) {
    //show a new dialog only if the previous dialog is closed.
    if (isSimplePopClosed) {
      isNetworkError = true;
      isSimplePopClosed = false;
      // flutter defined function
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: new Text(title != null ? title : ""),
              content: new Text(message != null ? message : ""),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Close"),
                  onPressed: () {
                    isSimplePopClosed = true;
                    Navigator.of(context).pop();
                    if (PopupDialogs.isShowingLodingDialog) {
                      PopupDialogs.isShowingLodingDialog = false;
                      Navigator.pop(context);
                    }
                    onClose();
                  },
                ),
              ],
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
          );
        },
      );
    }
  }

  static showSimpleNetworkRetry(
      BuildContext context, String title, String message, Function onRetry) {
    //show a new dialog only if the previous dialog is closed.
    if (isSimplePopClosed) {
      isNetworkError = true;
      isSimplePopClosed = false;
      // flutter defined function
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return FadeIn(
            0.5, WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                title: new Text(title != null ? title : ""),
                content: new Text(message != null ? message : ""),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  new FlatButton(
                    child: new Text("Try Again"),
                    onPressed: onRetry,
                  ),
                ],
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
            ),
          );
        },
      );
    }
  }

  static showSimpleErrorWithDoublePop(
      {BuildContext context,
      String title,
      String message,
      Function onClick,
      String btnName,
      Icon btnIcon}) {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        // return object of type Dialog
        return FadeIn(
          0.5,  WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: new Text(title != null ? title : "Error"),
              content:
                  new Text(message != null ? message : "Unknow Error Occured"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog

                new FlatButton.icon(
                  icon: btnIcon,
                  label: new Text(
                    btnName != null ? btnName : "-",
                  ),
                  onPressed: () => onClick(context),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                  child: new FlatButton(
                    child: new Text(
                      "Close",
                      style: TextStyle(color: Colors.grey),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      isShowingLodingDialog = false;
                    },
                  ),
                ),
              ],
              elevation: 10,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        );
      },
    );
  }

  static showSimpleErrorWithSinglePop(
      {BuildContext context,
      String title,
      String message,
      Function onClick,
      String btnName,
      Icon btnIcon}) {
    // flutter defined function
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return FadeIn(
          0.5, AlertDialog(
            title: new Text(title != null ? title : ""),
            content: new Text(message != null ? message : ""),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog

              new FlatButton.icon(
                icon: btnIcon,
                label: new Text(
                  btnName != null ? btnName : "",
                ),
                onPressed: () => onClick(context),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                child: new FlatButton(
                  child: new Text(
                    "Close",
                    style: TextStyle(color: Colors.grey),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        );
      },
    );
  }

  static showSimpleErrorWithoutCancel(
      {BuildContext context,
      String title,
      String message,
      Function onClick,
      String btnName,
      Icon btnIcon}) {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return FadeIn(
          0.5, AlertDialog(
            title: new Text(title != null ? title : ""),
            content: new Text(message != null ? message : ""),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton.icon(
                icon: btnIcon,
                label: new Text(
                  btnName,
                ),
                onPressed: () => onClick(context),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                child: new FlatButton.icon(
                  icon: btnIcon,
                  label: new Text(
                    btnName,
                  ),
                  onPressed: () => onClick(context),
                ),
              ),
            ],
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        );
      },
    );
  }

  static showLoadingDialog(BuildContext context, String message) {
    isShowingLodingDialog = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return WillPopScope(
            onWillPop: () async => false,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: new Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      new CircularProgressIndicator(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 0),
                        child: new Text(message != null ? message : ""),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  static showSimpleConfirmWithDoublePop(
      {BuildContext context,
      String title,
      String message,
      Function onClick,
      String btnName,
      Icon btnIcon}) {
    // flutter defined function
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return FadeIn(0.5, AlertDialog(
          title: new Text(title != null ? title : ""),
          content: new Text(message != null ? message : ""),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog

            new FlatButton.icon(
              icon: btnIcon,
              label: new Text(
                btnName != null ? btnName : "",
              ),
              onPressed: () => onClick(context),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
              child: new FlatButton(
                child: new Text(
                  "cancel",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ));
      },
    );
  }

  static showPosterPopUp(
      {@required BuildContext context,
        @required String image,
        @required String title,
        String body,}) {
    // flutter defined function
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return FadeIn(0.5, SimpleDialog(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: <Widget>[
                  Image.asset(image,
                  width: MediaQuery.of(context).size.width / 2 ,
                  ),
                  Container(height: 16,),
                  Text(
                    title != null ? title : "Title",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Container(height: 4,),
                  Text(
                    body != null ? body : "",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                  ),
                  Container(height: 12,),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: OutlineButton(
                      child: Text("Close"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ],
              ),
            )
          ],
          elevation: 10,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ));
      },
    );
  }

  static showPosterPopUpWithAction(
      {@required BuildContext context,
        @required String image,
        @required String title,
        @required String actionName,
        Function onClickAction,
        Color primaryBtnColor,
        String secondaryBtnName,
        String body,}) {
    // flutter defined function
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return FadeIn(0.5, SimpleDialog(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: <Widget>[
                  Image.asset(image,
                    width: MediaQuery.of(context).size.width / 2 ,
                  ),
                  Container(height: 16,),
                  Text(
                    title != null ? title : "Title",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Container(height: 4,),
                  Text(
                    body != null ? body : "",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                  ),
                  Container(height: 12,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: OutlineButton(
                          child: Text(secondaryBtnName != null ? secondaryBtnName : "Close"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: RaisedButton(
                          child: Text(actionName != null ? actionName : "Action", style: TextStyle(color: AppColors.TEXT_WHITE),),
                          color: primaryBtnColor != null ? primaryBtnColor : AppColors.WARNING_NOTIFY_COLOR,
                          onPressed: () {
                            onClickAction();
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
          elevation: 10,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ));
      },
    );
  }

  static showCounterPopUp(
      {@required BuildContext context,
      @required Function onSelected,
      @required int selectedIndex,
      String measure,
      List<num> steps}) {
    // flutter defined function
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return SimpleDialog(
          title: Text(
            "Select a desired quantity",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: SingleChildScrollView(
                child: Center(
                  child: Wrap(
                    children: steps
                        .map((e) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                              child: ChoiceChip(
                                avatar: Icon(Icons.select_all),
                                label: Text(
                                  e.toStringAsFixed(2) +
                                      " " +
                                      (measure != null ? measure : ""),
                                  style: TextStyle(
                                      color: AppColors.DARK_TEXT_COLOR,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                selectedColor: AppColors.LIGHT_MAIN_COLOR,
                                disabledColor: Colors.grey[200],
                                selected: steps.indexOf(e) == selectedIndex,
                                onSelected: (bool selected) {
                                  onSelected(steps.indexOf(e));
                                  Navigator.of(context).pop();
                                },
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            )
          ],
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        );
      },
    );
  }
}

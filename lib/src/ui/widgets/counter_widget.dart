import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:food_deliver/src/db/entity/product_entity.dart';
import 'package:food_deliver/src/ui/dialogs/PopUpDialog.dart';
import 'package:food_deliver/src/utills/cart_helper.dart';
import 'package:vibration/vibration.dart';

typedef void CounterChangeCallback(num value);

class Counter extends StatelessWidget {
  final CounterChangeCallback onChanged;

  Counter({
    Key key,
    @required num initialValue,
    @required this.minValue,
    @required this.maxValue,
    @required this.onChanged,
    @required this.decimalPlaces,
    this.productEntity,
    this.customSteps,
    this.symbol,
    this.color,
    this.textStyle,
    this.step = 1,
    this.buttonSize = 25,
    this.isScaled = false
  })  : assert(initialValue != null),
        assert(minValue != null),
        assert(maxValue != null),
        assert(maxValue > minValue),
        assert(initialValue >= minValue && initialValue <= maxValue),
        assert(step > 0),
        selectedValue = initialValue,
        super(key: key);

  ProductEntity productEntity;
  bool isScaled = false;

  ///min value user can pick
  final num minValue;

  ///max value user can pick
  final num maxValue;

  /// decimal places required by the counter
  final int decimalPlaces;

  ///Currently selected integer value
  num selectedValue;

  /// if min=0, max=5, step=3, then items will be 0 and 3.
  final num step;

  /// indicates the color of fab used for increment and decrement
  Color color;

  /// text syle
  TextStyle textStyle;

  /// unitOf measurements
  final String symbol;

  /// custom increment steps
  List<double> customSteps;
  int currentIndex = 0;

  double buttonSize;

  void _incrementCounter(BuildContext context) {
    if ( CartHelper().isMaximumAmountReached(productEntity.productAmount)){
      // show you have items from different stores
      PopupDialogs.showPosterPopUp(
          context: context,
          image:
          "assets/images/maximum_amount_illustration.png",
          title: "Maximum Transaction Amount Reached",
          body:
          "You reached maximum transaction limit of ${CartHelper().getMaximumTransactionLimit().toStringAsFixed(2)}");
      return;
    }
    if (customSteps != null && customSteps.length > 0) {
      currentIndex++;
      if (currentIndex < customSteps.length) {
        onChanged(customSteps[currentIndex]);
      }
      else{
        currentIndex--;
      }
    } else {
      print(
          "decrement by one : min val - $minValue, selected val : $selectedValue");
      if (selectedValue + step <= maxValue) {
        onChanged((selectedValue + step));
      }
    }
  }

  void _decrementCounter() {
    if (customSteps != null && customSteps.length > 0) {
      currentIndex--;
      if (currentIndex >= 0) {
        onChanged(customSteps[currentIndex]);
      }
      else{
        onChanged(0);
      }
    } else {
      print(
          "decrement by one : min val - $minValue, selected val : $selectedValue");
      if (selectedValue - step >= minValue) {
        onChanged((selectedValue - step));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isScaled){
      buttonSize = 35;
    }
    setFontSize();
    if (customSteps != null && customSteps.contains(selectedValue)) {
      currentIndex = customSteps.indexOf(selectedValue.toDouble());
    }
    final ThemeData themeData = Theme.of(context);
    color = color ?? themeData.accentColor;
    textStyle = textStyle ??
        new TextStyle(
          fontSize: 20.0,
        );

    return GestureDetector(
      onTap: (){},
      child: new Container(
        padding: new EdgeInsets.all(4.0),
        child: Material(
          borderRadius: BorderRadius.circular(24),
          color: Colors.grey[100],
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap : _decrementCounter,
                onLongPress: (){
                  try {Vibration.vibrate(duration: 10);} catch(i){print(i);}
                  if (customSteps != null && customSteps.length > 0) {
                    PopupDialogs.showCounterPopUp(
                      onSelected: (index) {
                        currentIndex = index;
                        onChanged(customSteps[currentIndex]);
                      },
                      context: context,
                      steps: customSteps,
                      measure: symbol,
                      selectedIndex: currentIndex,
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox.fromSize(
                    size: Size(buttonSize, buttonSize), // button width and height
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Material(
                        color: Colors.black54, // button color
                        elevation: 2,
                        child: InkWell(
                          splashColor: Colors.green, // splash color
                          //onTap: _decrementCounter, // button pressed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.remove,
                                color: Colors.white,
                              ), // text
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  if (customSteps != null && customSteps.length > 0) {
                    PopupDialogs.showCounterPopUp(
                      onSelected: (index) {
                        currentIndex = index;
                        onChanged(customSteps[currentIndex]);
                      },
                      context: context,
                      steps: customSteps,
                      measure: symbol,
                      selectedIndex: currentIndex,
                    );
                  }
                },
                child: new Container(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Row(
                    children: <Widget>[
                      new Text(
                          '${num.parse((selectedValue).toStringAsFixed(decimalPlaces))}',
                          style: textStyle),
                      new Text((symbol != null ? " $symbol" : ""),
                          style:
                              TextStyle(fontSize: 12, fontWeight: FontWeight.w300)),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _incrementCounter(context),
                onLongPress: (){
                  try {Vibration.vibrate(duration: 10);} catch(i){print(i);}
                  if (customSteps != null && customSteps.length > 0) {
                    PopupDialogs.showCounterPopUp(
                      onSelected: (index) {
                        currentIndex = index;
                        onChanged(customSteps[currentIndex]);
                      },
                      context: context,
                      steps: customSteps,
                      measure: symbol,
                      selectedIndex: currentIndex,
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox.fromSize(
                    size: Size(buttonSize, buttonSize), // button width and height
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Material(
                        color: Colors.black54, // button color
                        elevation: 2,
                        child: InkWell(
                          splashColor: Colors.green, // splash color
//                        onTap: _incrementCounter, // button pressed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ), // text
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void setFontSize() {
    if (selectedValue.toString().length > 3) {
      textStyle = TextStyle(
          fontWeight: textStyle != null ? textStyle.fontWeight : null,
          fontSize: 14,
          fontFamily: textStyle != null ? textStyle.fontFamily : null,
          color: textStyle != null ? textStyle.color : null);
    }
  }
}

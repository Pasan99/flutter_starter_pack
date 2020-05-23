
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_deliver/src/values/colors.dart';
import '../../../routes/router.gr.dart';
import 'package:auto_route/auto_route.dart';

class DeliveyInfomationPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: AppColors.DARK_TEXT_COLOR
        ),
        title: Text(
          'Delivery information',
          style: TextStyle(
              color: AppColors.DARK_TEXT_COLOR
          ),
        ),
        backgroundColor: AppColors.MAIN_COLOR,
      ),
      body: DeliveyInfomationPageBody(),
    );
  }
}

class DeliveyInfomationPageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          24, 0, 24, 0),
      child:Column(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      0, 24, 0, 0),
                  child: Text(
                    'Deliver to',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.DARK_TEXT_COLOR
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB
                          (0, 8, 0, 8),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Full Name',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB
                          (0, 8, 0, 8),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'NIC Number',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      0, 25, 0, 8),
                  child: Text(
                    'Delivery Address',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                  ),
                ),
                DropDownList(
                    ['Colombo', "Kandy", "Polonnaruwa"],
                    "Galle"
                ),
                DropDownList(
                    ['Colombo 5', "Horana", "Colombo 7"],
                    "Colombo 3"
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB
                          (0, 16, 0, 8),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Main road / village',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB
                          (0, 8, 0, 8),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Street No.',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB
                          (0, 8, 0, 8),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'House No. / Apartment No.',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB
                          (0, 8, 0, 8),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Landmark (optional)',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  0, 5, 0, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: ButtonTheme(
                      height: 50,
                      child: RaisedButton(
                        color: AppColors.MAIN_COLOR,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        onPressed: () {
                          ExtendedNavigator.of(context).pushNamed(Routes.checkoutPage);
                        },
                        child: Text('save',
                          style: TextStyle(
                              fontSize: 22,
                              fontStyle: FontStyle.normal
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),

    );
  }
}

// ignore: must_be_immutable
class DropDownList extends StatefulWidget {
  List<String> items;
  String title;

  DropDownList(List<String> items, String title){
    this.items = items;
    this.title = title;
  }
  @override
  _DropDownListState createState() => _DropDownListState(items, title);
}

class _DropDownListState extends State<DropDownList> {
  List<String> items;
  String title;
  String currentValue;

  _DropDownListState(List<String> items, String title){
    this.items = items;
    this.title = title;
    this.currentValue = items[1];
  }
  @override
  Widget build(BuildContext context) {

    return DropdownButtonFormField(
      hint: Text(title),
      value: currentValue,
      items: items.map((item) => DropdownMenuItem(
        key: Key(items.indexOf(item).toString()),
        value: item, child: Text(item),
      )).toList(),
      onChanged: (value) {
        setState(() {
          currentValue = value;
        });
      },
    );
  }
}

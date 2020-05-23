
import 'package:flutter/material.dart';
import 'package:food_deliver/src/values/colors.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  var dropdownValue = "One";
  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: true,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Material(
          color: AppColors.BACK_WHITE_COLOR,
          borderRadius: BorderRadius.circular(32),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            child: Row(
              children: <Widget>[
//                DropdownButton<String>(
//                  icon: Icon(Icons.move_to_inbox),
//                  iconSize: 24,
//                  hint: Container(),
//                  elevation: 16,
//                  style: TextStyle(color: Colors.deepPurple),
//                  underline: Container(
//                    height: 2,
//                    color: Colors.deepPurpleAccent,
//                  ),
//                  onChanged: (String newValue) {
//                    setState(() {
//                      dropdownValue = newValue;
//                    });
//                  },
//                  items: <String>['One', 'Two', 'Free', 'Four']
//                      .map<DropdownMenuItem<String>>((String value) {
//                    return DropdownMenuItem<String>(
//                        value: value,
//                        child:
////                    Container(
////                      child: Row(
////                        children: <Widget>[
////                          Icon(
////                            Icons.image
////                          ),
////                          Container(width: 8,),
////                          Text(value)
////                        ],
////                      ),
////                    ),
//                        Container()
//                    );
//                  }).toList(),
//                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Icon(Icons.search),
              ),
                Container(width: 8,),
                Container(width: 1, height: 30, color: AppColors.DIVIDER_COLOR,),
                Container(width: 8,),
                Expanded(
                    child: GestureDetector(
                        onTap: (){
                          print("On Search");
                        },
                        child: Text(
                          "What are you looking for?",
                          style: TextStyle(
                              color: AppColors.LIGHT_TEXT_COLOR
                          ),
                        )
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

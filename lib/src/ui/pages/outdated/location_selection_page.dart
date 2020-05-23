import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_deliver/src/db/entity/city_entity.dart';
import 'package:food_deliver/src/db/entity/districts_entity.dart';
import 'package:food_deliver/src/utills/language_helper.dart';
import 'package:food_deliver/src/viewmodels/create_district_and_city_viewmodel.dart';
import 'package:food_deliver/src/viewmodels/create_user_viewmodel.dart';

class LocationSelectPage extends StatefulWidget {
  final CreateUserViewModel model;
  final bool isDistrict;

  const LocationSelectPage({Key key, @required this.model, this.isDistrict})
      : super(key: key);

  @override
  _LocationSelectPageState createState() => _LocationSelectPageState();
}

class _LocationSelectPageState extends State<LocationSelectPage> {
  CreateUserViewModel _model;
  bool _isDistrict;

  List<DistrictEntity> districtList;
  List<CityEntity> cityList;

  List<String> items = List();

  var searchText = TextEditingController();
  List<String> searchList = List();

  List<String> searchItems(text) {
    if (text.toString() == "") {
      return items;
    }
    return items
        .where((item) =>
        item.toLowerCase().startsWith(text.toString().toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    _model = widget.model;
    _isDistrict = widget.isDistrict;

    getLocationList();
    super.initState();
//    WidgetsBinding.instance.addPostFrameCallback(
//      (_) async {
//        await getLocationList();
//        setState(() {});
//      },
//    );
  }

  getLocationList() async {
    if (_isDistrict) _model.districtId = -1;
    List<DistrictEntity> districtList;
    List<CityEntity> cityList;
    List<String> items = List();
    List<String> searchList = List();
    if (_model.districtId == -1) {
      districtList = await CreateDistrictAndCityViewModel().getDistrictList();
      await districtList.forEach((district) async {
        items.add(await LanguageHelper(names: district.districtName).getName());
        searchList
            .add(await LanguageHelper(names: district.districtName).getName());
      });
    } else {
      cityList = await CreateDistrictAndCityViewModel()
          .getCityListByDistrictId(_model.districtId);
      if (cityList != null)
        await cityList.forEach((city) async {
          items.add(await LanguageHelper(names: city.name).getName());
          searchList.add(await LanguageHelper(names: city.name).getName());
        });
    }

    setState(() {
      this.districtList = districtList;
      this.cityList = cityList;
      this.items = items;
      this.searchList = searchList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(padding:EdgeInsets.only(top: 50),),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 50,
                height: 50,
                child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 16.0),
                  child: Text(
                    'Where do you live?',
                    style: TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            Text('Select your grama sewaka Division'),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 0.0),
              child: TextField(
                controller: searchText,
                onChanged: (text) {
                  setState(() {
                    searchList = searchItems(searchText.text);
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Search',
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: searchList.length,
                  itemBuilder: (context, index) =>
                      Card(
                        child: ListTile(
                          onTap: () {
                            if (_model.districtId == -1) {
                              _model.district.value.text = searchList[index];
                              _model.city.value.text = "";
                              _model.districtId = districtList
                                  .elementAt(items.indexOf(searchList[index]))
                                  .ID;
                            } else {
                              _model.city.value.text = searchList[index];
                              _model.cityID = cityList
                                  .elementAt(items.indexOf(searchList[index]))
                                  .cityID;
                            }
                            Navigator.pop(context);
                          },
                          title: Text(searchList[index]),
                        ),
                      )),
            )
          ],
        ));
  }
}

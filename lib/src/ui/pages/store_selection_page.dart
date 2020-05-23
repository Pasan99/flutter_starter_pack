import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_deliver/src/routes/router.gr.dart';
import 'package:food_deliver/src/ui/dialogs/PopUpDialog.dart';
import 'package:food_deliver/src/ui/pages/registration/location_map_page.dart';
import 'package:food_deliver/src/ui/widgets/shimmers/shimmer_item_2.dart';
import 'package:food_deliver/src/ui/widgets/shimmers/shimmer_list_1.dart';
import 'package:food_deliver/src/ui/widgets/store_item.dart';
import 'package:food_deliver/src/utills/cart_helper.dart';
import 'package:food_deliver/src/utills/response_codes.dart';
import 'package:food_deliver/src/values/colors.dart';
import 'package:food_deliver/src/viewmodels/store_view_model.dart';
import 'package:loadmore/loadmore.dart';
import 'package:provider/provider.dart';

class StoreSelectionPage extends StatelessWidget {
  final Function onCartPressed;
  final Function onCartItemChanged;

  StoreSelectionPage(
      {Key key, @required this.onCartPressed, @required this.onCartItemChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stores Nearby you"),
        backgroundColor: AppColors.MAIN_COLOR,
      ),
      body: ChangeNotifierProvider(
        create: (context) => StoreViewModel(null),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Material(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 4, 8, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Consumer<StoreViewModel>(
                          builder: (context, model, child) {
                        if (model.addressList.length > 0) {
                          return DropDownList(
                            model.addressList,
                            model.addressList[model.selectedContactIndex]
                                .personName,
                            "Colombo",
                            model,
                            selectedIndex: model.selectedContactIndex,
                            onItemChanged: (personName) async {
                              await model.onCityChanged(personName);
                              if (model.isCartCleared) {
                                onCartItemChanged(0);
                              }
                            },
                            onLocationAdded: (contactId) async {
                              model.addressList = List();
                              model.newContact = contactId;
                              await model.loadDropDownList();
                              if (model.isCartCleared) {
                                onCartItemChanged(0);
                              }
                            },
                          );
                        }
                        return ShimmerItem2();
                      }),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: AppColors.DIVIDER_COLOR,
              ),
              Expanded(
                child:
                    Consumer<StoreViewModel>(builder: (context, model, child) {
                  if (model.stores != null && model.stores.length > 0) {
                    return LoadMore(
                        isFinish: model.stores.length >= model.stores[0].total,
                        onLoadMore: model.loadMore,
                        delegate: DefaultLoadMoreDelegate(),
                        textBuilder: (status) {
                          if (status == LoadMoreStatus.nomore) {
                            return "○○○○○○○○";
                          } else if (status == LoadMoreStatus.loading) {
                            return "Loading";
                          } else {
                            return "";
                          }
                        },
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            if (index < model.stores.length) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: GestureDetector(
                                  onTap: () {
                                      ExtendedNavigator.of(context).pushNamed(
                                          Routes.productSelectionPage,
                                          arguments:
                                              ProductSelectionPageArguments(
                                                onCartPressed: onCartPressed,
                                                  storeResponseApi:
                                                      model.stores[index]));

                                  },
                                  child: StoreItem(
                                    card: model.stores[index],
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                height: 200,
                              );
                            }
                          },
                          itemCount: model.stores.length,
                        )
                        );
                  } else if (model.currentStatus == Responses.NO_DATA) {
                    // no data view
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SafeArea(
                            child: SizedBox(
                              width: 60,
                              height: 60,
                              child: Image.asset(
                                "assets/images/shop.png",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
                            child: Text(
                              "No stores available in the this location",
                              style: TextStyle(
                                  fontWeight: FontWeight.w200, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Text(
                            "Please change your location and continue",
                            style: TextStyle(
                                fontWeight: FontWeight.w200, fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  } else if (model.currentStatus == Responses.TIMEOUT) {
                    // no data view
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 60),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SafeArea(
                              child: SizedBox(
                                width: 60,
                                height: 60,
                                child: Image.asset(
                                  "assets/images/no_internet.png",
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                              child: Text(
                                "connection_issue",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ).tr(),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                              child: Text(
                                "Something_wrong_Please_try_again",
                                style: TextStyle(
                                    fontWeight: FontWeight.w200, fontSize: 12),
                                textAlign: TextAlign.center,
                              ).tr(),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: OutlineButton(
                                child: Text("retry").tr(),
                                onPressed: () {
                                  model.retry();
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  } else if (model.currentStatus ==
                      Responses.NETWORK_DISCONNECTED) {
                    // no data view
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SafeArea(
                            child: SizedBox(
                              width: 60,
                              height: 60,
                              child: Image.asset(
                                "assets/images/no_internet.png",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                            child: Text(
                              "No Intenet Connection",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14),
                            ),
                          ),
                          Text(
                            "This app requires internet connection to continue",
                            style: TextStyle(
                                fontWeight: FontWeight.w200, fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  } else {
//                return Center(
//                  child: SpinKitRotatingPlain(
//                    color: AppColors.MAIN_COLOR,
//                    size: 60.0,
//                  ),
//                );
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ShimmerListType1(),
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class DropDownList extends StatefulWidget {
  List<StoreDropDownModel> items;
  String title;
  String subTitle;
  Function onItemChanged;
  int selectedIndex;
  StoreViewModel _storeViewModel;
  final Function onLocationAdded;

  DropDownList(List<StoreDropDownModel> items, String title, String subTitle,
      this._storeViewModel,
      {this.onItemChanged,
      @required this.selectedIndex,
      @required this.onLocationAdded}) {
    this.items = items;
    this.title = title;
    this.subTitle = subTitle;
  }

  @override
  _DropDownListState createState() => _DropDownListState(
      items, title, subTitle, _storeViewModel, selectedIndex, onLocationAdded);
}

class _DropDownListState extends State<DropDownList> {
  List<StoreDropDownModel> items;
  String title;
  String subtitle;
  StoreDropDownModel currentValue;
  StoreViewModel _storeViewModel;
  final Function onLocationAdded;

  _DropDownListState(
      List<StoreDropDownModel> items,
      String title,
      String subTitle,
      this._storeViewModel,
      selectedIndex,
      this.onLocationAdded) {
    if (this.items != null) {
      this.items.clear();
    }
    this.items = items;
    this.title = title;
    this.subtitle = subTitle;
    this.currentValue = items[selectedIndex];
  }

  @override
  Widget build(BuildContext context) {
    print(items);
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        height: 80,
        // dropdown below..
        child: Material(
          elevation: 1,
          color: AppColors.BACK_WHITE_COLOR,
          borderRadius: BorderRadius.circular(12),
          child: DropdownButton<StoreDropDownModel>(
            itemHeight: 60,
            hint: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 12, 12, 8),
                  child: Image.asset(
                    "assets/images/ic_location.png",
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 14, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width - 160,
                        child: Text(
                          title != null ? title : "",
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w300),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            icon: Image.asset(
              "assets/images/ic_arrow.png",
              height: 20,
            ),
            iconSize: 30,
            underline: SizedBox(),
            onChanged: (value) async {
              if (await CartHelper().getCartItemCount() > 0) {
                PopupDialogs.showPosterPopUpWithAction(
                    context: context,
                    actionName: "Yes",
                    secondaryBtnName: "No",
                    onClickAction: () async {
                      // on agree
                      if (value.personName ==
                          StoreViewModel.DELIVER_TO_SOMEONE) {
                        ExtendedNavigator.of(context)
                            .pushNamed(Routes.locationRegisterPage,
                            arguments: LocationRegisterPageArguments(
                                onSave: () {},
                                onContactCreated: (contactId) {
                                  widget.onLocationAdded(contactId);
                                  print("Call back recieved");
                                },
                                registrationType:
                                LocationMapPage.REGISTRATION_TYPE_SUB_ADDRESS))
                            .then((value) {
                          //reload the contact list, after user added a new contact
                          if (value == 1 && _storeViewModel != null) {
                            _storeViewModel.loadDropDownList();
                          }
                        });
                        return;
                      } else {
                        currentValue = value;
                        title = currentValue.personName;
                      }
                      return widget.onItemChanged(value);
                    },
                    image:
                    "assets/images/empty_cart_illustration.png",
                    title: "Do you want to Clear Cart ?",
                    body:
                    "Changing the location will remove all items from cart. Because stores are displayed based on your location. Do you want to continue ?");
              }
              else{
                if (value.personName ==
                    StoreViewModel.DELIVER_TO_SOMEONE) {
                  ExtendedNavigator.of(context)
                      .pushNamed(Routes.locationRegisterPage,
                      arguments: LocationRegisterPageArguments(
                          onSave: () {},
                          onContactCreated: (contactId) {
                            widget.onLocationAdded(contactId);
                            print("Call back recieved");
                          },
                          registrationType:
                          LocationMapPage.REGISTRATION_TYPE_SUB_ADDRESS))
                      .then((value) {
                    //reload the contact list, after user added a new contact
                    if (value == 1 && _storeViewModel != null) {
                      _storeViewModel.loadDropDownList();
                    }
                  });
                  return;
                } else {
                  currentValue = value;
                  title = currentValue.personName;
                }
                return widget.onItemChanged(value);
              }
            },
            items: items
                .map((item) => DropdownMenuItem(
                      key: Key(items.indexOf(item).toString()),
                      value: item,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Material(
                            borderRadius: BorderRadius.circular(8),
                            color: item == currentValue
                                ? AppColors.LIGHTER_TEXT_COLOR
                                : null,
                            child: Container(
                                width: MediaQuery.of(context).size.width - 80,
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          12, 8, 0, 8),
                                      child: Icon(
                                        Icons.location_on,
                                        color: item == currentValue
                                            ? AppColors.LIGHT_MAIN_COLOR
                                            : Colors.grey[400],
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          120,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 8),
                                        child: Text(
                                          item.personName != null
                                              ? item.personName
                                              : "",
                                          textAlign: TextAlign.left,
                                          /*overflow: TextOverflow.ellipsis,*/
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ));
  }
}

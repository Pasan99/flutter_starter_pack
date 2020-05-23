import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:food_deliver/src/db/entity/product_entity.dart';
import 'package:food_deliver/src/routes/router.gr.dart';
import 'package:food_deliver/src/ui/widgets/search_product_item.dart';
import 'package:food_deliver/src/ui/widgets/store_item.dart';
import 'package:food_deliver/src/utills/cart_helper.dart';
import 'package:food_deliver/src/values/colors.dart';
import 'package:food_deliver/src/viewmodels/search/global_search_viewmodel.dart';
import 'package:food_deliver/src/ext/list_extension.dart';
import 'package:provider/provider.dart';

enum GlobalSearchType { CATEGORY, PRODUCT }

class GlobalSearchPage extends StatefulWidget {
  final Function onCartPressed;

  const GlobalSearchPage({Key key, this.onCartPressed}) : super(key: key);

  @override
  _GlobalSearchPageState createState() => _GlobalSearchPageState();
}

class _GlobalSearchPageState extends State<GlobalSearchPage> {
  var dropdownValue = "One";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: AppColors.BACK_WHITE_COLOR,
      child: ChangeNotifierProvider(
        create: (context) => GlobalSearchViewModel(),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0),
                child: Material(
                  color: AppColors.BACK_WHITE_COLOR,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                            onTap: () {
                              ExtendedNavigator.of(context).pop();
                            },
                            child: Icon(Icons.arrow_back_ios)),
                        Container(
                          width: 16,
                        ),
                        Expanded(child: Consumer<GlobalSearchViewModel>(
                            builder: (context, model, child) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: TextField(
                              autofocus: true,
                              textInputAction: TextInputAction.search,
                              cursorColor: AppColors.MAIN_COLOR,
                              style: TextStyle(
                                  decorationColor: AppColors.MAIN_COLOR),
                              controller: model.searchEditor,
                              onChanged: (value) {
                                if (value.length > 0) {
                                  model.onTextChange();
                                } else {
                                  model.clearSearchList();
                                }
                              },
                              decoration: InputDecoration(
                                  hintText: "Search Term",
                                  focusColor: AppColors.MAIN_COLOR,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: AppColors.MAIN_COLOR),
                                  )),
                            ),
                          );
                        }))
                      ],
                    ),
                  ),
                ),
              ),
              //////////////////////////////////////////////////////////////////////
              Consumer<GlobalSearchViewModel>(builder: (context, model, child) {
                return SearchTypeSelector(
                  isSelected: true,
                  selectedItemIndex:
                      model.selectedIndex == null ? 0 : model.selectedIndex,
                  onSelectionChanged: (index) {
                    model.onChangeSearchSelector(index);
                  },
                );
              }),
              //////////////////////////////////////////////////////////////////////
              Expanded(child: Consumer<GlobalSearchViewModel>(
                  builder: (context, model, child) {
                if (model.searchList.isInvalid() &&
                    model.storeSearchList.isInvalid()) {
                  return Center(
                    child: Image.asset(
                      "assets/images/search_illustration.png",
                      width: MediaQuery.of(context).size.width,
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Card(
                    child: ListView(
                      children: model.selectedIndex == 1
                          ? (model.searchList != null
                              ? model.searchList.map((product) {
                                  return Column(
                                    children: <Widget>[
                                      SearchProductItem(
                                        onCartPressed: widget.onCartPressed,
                                        productEntity: product,
                                        onCartItemChanged: (value) async {
                                          bool isSuccess = false;
                                          // update item in cart using cart helper
                                          if (isAddingOperation(product)) {
                                            // add to cart
                                            CartResponses response =
                                                await model.addToCart(product);
                                            if (response ==
                                                CartResponses.Added) {
                                              isSuccess = true;
                                            }
                                          } else {
                                            // update cart
                                            CartResponses response =
                                                await model.updateItem(product);
                                            if (response ==
                                                CartResponses.Updated) {
                                              isSuccess = true;
                                            }
                                          }

                                          // if success update UI
                                          if (isSuccess) {
                                            setState(() {
                                              product.inCartCount = value;
                                              product.isAddedToCart = true;
                                            });
                                          }
                                        },
                                        onRemoveFromCart: () async {
                                          bool isSuccess = false;
                                          // remove item from cart using cart helper
                                          CartResponses response =
                                              await model.removeItem(product);
                                          if (response ==
                                              CartResponses.Removed) {
                                            isSuccess = true;
                                          }
                                          setState(() {
                                            // if success update the UI
                                            if (isSuccess) {
                                              product.isAddedToCart = false;
                                            }
                                          });
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 12),
                                        child: Divider(
                                          height: 1,
                                          color: Colors.grey[200],
                                        ),
                                      )
                                    ],
                                  );
                                }).toList()
                              : [
                                  Center(
                                    child: Image.asset(
                                      "assets/images/search_illustration.png",
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                  )
                                ])
                          :
                          // stores list
                          model.storeSearchList != null
                              ? (model.storeSearchList.map((store) {
                                  return GestureDetector(
                                    onTap: () {
                                      ExtendedNavigator.of(context).pushNamed(
                                          Routes.productSelectionPage,
                                          arguments:
                                              ProductSelectionPageArguments(
                                                  onCartPressed: () {
                                                    print("On Cart Pressed");
                                                  },
                                                  storeResponseApi: store));
                                    },
                                    child: StoreItem(
                                      card: store,
                                    ),
                                  );
                                }).toList())
                              : [
                                  Center(
                                    child: Image.asset(
                                      "assets/images/search_illustration.png",
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                  )
                                ],
                    ),
                  ),
                );
              }))
            ],
          ),
        ),
      ),
    ));
  }

  bool isAddingOperation(ProductEntity product) {
    if ((product.inCartCount == 1 ||
            (product.qntIncrements != null &&
                product.qntIncrements.isNotEmpty &&
                product.inCartCount == product.qntIncrements[0])) &&
        !(CartHelper().isInCart(product))) {
      return true;
    }
    return false;
  }
}

class SearchTypeSelector extends StatefulWidget {
  bool isSelected = false;
  int selectedItemIndex = 0;
  final Function onSelectionChanged;

  SearchTypeSelector(
      {this.isSelected, this.selectedItemIndex, this.onSelectionChanged});

  @override
  _SearchTypeSelectorState createState() => _SearchTypeSelectorState();
}

class _SearchTypeSelectorState extends State<SearchTypeSelector> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (widget.selectedItemIndex == 0 && widget.isSelected) {
                    widget.isSelected = false;
                  } else {
                    widget.isSelected = true;
                    widget.selectedItemIndex = 0;
                    widget.onSelectionChanged(widget.selectedItemIndex);
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 4, 8),
                child: Material(
                  color: widget.selectedItemIndex == 0 && widget.isSelected
                      ? AppColors.MAIN_COLOR
                      : AppColors.BACK_WHITE_COLOR,
                  borderRadius: BorderRadius.circular(32),
                  elevation: 2,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 12),
                      child: Text(
                        "Search Stores",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (widget.selectedItemIndex == 1 && widget.isSelected) {
                    widget.isSelected = false;
                  } else {
                    widget.isSelected = true;
                    widget.selectedItemIndex = 1;
                    widget.onSelectionChanged(widget.selectedItemIndex);
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
                child: Material(
                  color: widget.selectedItemIndex == 1 && widget.isSelected
                      ? AppColors.MAIN_COLOR
                      : AppColors.BACK_WHITE_COLOR,
                  borderRadius: BorderRadius.circular(32),
                  elevation: 2,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 12),
                      child: Text(
                        "Search Products",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

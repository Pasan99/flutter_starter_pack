import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:food_deliver/src/db/entity/product_entity.dart';
import 'package:food_deliver/src/ui/widgets/product_item.dart';
import 'package:food_deliver/src/utills/cart_helper.dart';
import 'package:food_deliver/src/values/colors.dart';
import 'package:food_deliver/src/viewmodels/search/product_search_viewmodel.dart';
import 'package:provider/provider.dart';

enum ProductSearchType { InStoreSearch, InStoreCategorySearch, CategorySearch }

class ProductSearchPage extends StatefulWidget {
  final ProductSearchType productSearchType;
  final Function onCartPressed;
  final Function onCartItemChanged;
  final Function onRemoveFromCart;
  final String merchantId;
  final String categoryId;

  const ProductSearchPage(
      {Key key,
      this.productSearchType,
      this.onCartPressed,
      this.onCartItemChanged,
      this.onRemoveFromCart,
      this.merchantId,
      this.categoryId})
      : super(key: key);

  @override
  _ProductSearchPageState createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  var dropdownValue = "One";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ChangeNotifierProvider(
      create: (context) => ProductSearchViewModel(
          context: context,
          merchantId: widget.merchantId,
          categoryId: widget.categoryId ,
          searchType: widget.productSearchType),
      child: SafeArea(
        child: Container(
          color: AppColors.BACK_WHITE_COLOR,
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
                        Expanded(child: Consumer<ProductSearchViewModel>(
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
                                  model.getSearchList(value.toString().trim());
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
              Expanded(child: Consumer<ProductSearchViewModel>(
                  builder: (context, model, child) {
                if (model.searchList == null || model.searchList.length == 0) {
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
                      children: model.searchList.map((product) {
                        return ProductItem(
                          onCartPressed: widget.onCartPressed,
                          productEntity: product,
                          onCartItemChanged: (value) async {
                            bool isSuccess = false;
                            // update item in cart using cart helper
                            if (isAddingOperation(product)) {
                              // add to cart
                              CartResponses response =
                                  await model.addToCart(product);
                              if (response == CartResponses.Added) {
                                isSuccess = true;
                              }
                            } else {
                              // update cart
                              CartResponses response =
                                  await model.updateItem(product);
                              if (response == CartResponses.Updated) {
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
                            if (response == CartResponses.Removed) {
                              isSuccess = true;
                            }
                            setState(() {
                              // if success update the UI
                              if (isSuccess) {
                                product.isAddedToCart = false;
                              }
                            });
                          },
                        );
                      }).toList(),
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
            (product.qntIncrements != null && product.qntIncrements.isNotEmpty &&
                product.inCartCount == product.qntIncrements[0])) &&
        !(CartHelper().isInCart(product))) {
      return true;
    }
    return false;
  }
}

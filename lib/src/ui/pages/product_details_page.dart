import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_deliver/src/db/entity/product_entity.dart';
import 'package:food_deliver/src/ui/widgets/add_to_cart_btn.dart';
import 'package:food_deliver/src/ui/widgets/carousel_products.dart';
import 'package:food_deliver/src/utills/cart_helper.dart';
import 'package:food_deliver/src/values/colors.dart';
import 'package:food_deliver/src/viewmodels/product_details_page_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailsPage extends StatefulWidget {
  final ProductEntity productEntity;
  final Function onCartPressed;
  final Function onCartItemCountChanged;

  const ProductDetailsPage(
      {Key key,
      @required this.productEntity,
      this.onCartPressed,
      @required this.onCartItemCountChanged})
      : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => ProductDetailsViewModel(),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ////////////////  Product Image ////////////////////////////////////////
              Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: widget.productEntity.image != null
                        ? widget.productEntity.image
                        : "",
                    placeholder: (context, url) => SizedBox(
                      height: 250.0,
                      child: Shimmer.fromColors(
                        baseColor: Colors.black12,
                        highlightColor: Colors.grey,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 150, 0, 0),
                          child: Text(
                            'FairSpace',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                  //////////////// Back Btn ///////////////////////////////////
                  Positioned(
                    top: 36,
                    left: 16,
                    child: GestureDetector(
                      onTap: () {
                        ExtendedNavigator.of(context).pop();
                      },
                      child: ClipOval(
                        child: Container(
                          color: Colors.black54,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: AppColors.TEXT_WHITE,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  //////////////// Share Btn ///////////////////////////////////
                  Positioned(
                    top: 36,
                    right: 16,
                    child: ClipOval(
                      child: Container(
                        color: Colors.black54,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.share,
                            color: AppColors.TEXT_WHITE,
                          ),
                        ),
                      ),
                    ),
                  ),
                  //////////////// Cart Btn ///////////////////////////////////
                  Positioned(
                    top: 36,
                    right: 66,
                    child: GestureDetector(
                      onTap: () {
                        ExtendedNavigator.of(context)
                            .popUntil((route) => route.isFirst);
                        widget.onCartPressed();
                      },
                      child: ClipOval(
                        child: Container(
                          color: Colors.black54,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.shopping_cart,
                              color: AppColors.TEXT_WHITE,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              ////////////////////  Product Details //////////////////////////////////////
              Padding(
                padding: const EdgeInsets.only(top: 16),
              ),
              ///////////////  Name ///////////////////////
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        (widget.productEntity.brand != null
                                ? "${widget.productEntity.brand} - "
                                : "") +
                            (widget.productEntity.productName != null
                                ? widget.productEntity.productName
                                : "-"),
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 24),
                        textAlign: TextAlign.start,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
              ),
              ///////////////  Price ///////////////////////
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        (widget.productEntity.productAmount != null
                                ? "LKR " +
                                    widget.productEntity.productAmount
                                        .toStringAsFixed(2)
                                : "-") +
                            (widget.productEntity.unitOfMeasure != null
                                ? (" per ${widget.productEntity.unitOfMeasure}")
                                : ""),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                        textAlign: TextAlign.start,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
              ),
              ///////////////  Description ///////////////////////
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        widget.productEntity.description != null
                            ? widget.productEntity.description
                            : "-",
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 12),
                        textAlign: TextAlign.start,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: widget.productEntity.description != null
                    ? const EdgeInsets.only(top: 16)
                    : const EdgeInsets.only(top: 0),
              ),
              ///////////////  Add To Cart Button  ///////////////////////
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Consumer<ProductDetailsViewModel>(
                        builder: (context, model, child) {
                      return widget.productEntity.stock == null ||
                              widget.productEntity.stock >= 1
                          ? AddToCartButton(
                              isScaled: true,
                              symbol: widget.productEntity.unitOfMeasure != null
                                  ? widget.productEntity.unitOfMeasure.symbol
                                  : "",
                              customSteps:
                                  widget.productEntity.qntIncrements != null
                                      ? widget.productEntity.qntIncrements
                                          .map((e) => e.toDouble())
                                          .toList()
                                      : null,
                              onRemoveFromCart: () async {
                                bool isSuccess = false;
                                // remove item from cart using cart helper
                                CartResponses response = await model
                                    .removeItem(widget.productEntity);
                                if (response == CartResponses.Removed) {
                                  isSuccess = true;
                                }
                                setState(() {
                                  // if success update the UI
                                  if (isSuccess) {
                                    widget.productEntity.isAddedToCart = false;

                                    if (widget.onCartItemCountChanged != null) {
                                      widget.onCartItemCountChanged();
                                    }
                                  }
                                });
                              },
                              onChanged: (value) async {
                                bool isSuccess = false;
                                if (isAddingOperation(widget.productEntity)) {
                                  // add to cart
                                  CartResponses response = await model
                                      .addToCart(widget.productEntity);
                                  if (response == CartResponses.Added) {
                                    isSuccess = true;
                                  }
                                } else {
                                  // update item in cart using cart helper
                                  widget.productEntity.inCartCount = value;
                                  CartResponses response = await model
                                      .updateItem(widget.productEntity);
                                  if (response == CartResponses.Updated) {
                                    isSuccess = true;
                                  }
                                }

                                // if success update UI
                                if (isSuccess) {
                                  setState(() {
                                    widget.productEntity.isAddedToCart = true;
                                    widget.productEntity.inCartCount = value;
                                    if (widget.onCartItemCountChanged != null) {
                                      widget.onCartItemCountChanged();
                                    }
                                  });
                                }
                                // update item in cart using cart helper
                              },
                              item: widget.productEntity,
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.store,
                                    color: AppColors.LIGHT_TEXT_COLOR,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Text(
                                      "Out of Stock",
                                      style: TextStyle(
                                          color: AppColors.LIGHT_TEXT_COLOR),
                                    ),
                                  ),
                                ],
                              ),
                            );
                    })
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Divider(
                  height: 1,
                  color: AppColors.DIVIDER_COLOR,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
              ),
              /////////////////////////   Suggestions Heading   ////////////////////////////////////////////
              Container(
                height: 8,
              ),
              Consumer<ProductDetailsViewModel>(
                  builder: (context, model, child) {
                return model.suggestedProducts != null &&
                        model.suggestedProducts.length > 0
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "You may also be interested in",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: AppColors.DARK_TEXT_COLOR,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container();
              }),
              //////////////////////////  Top Suggestions Carousel  //////////////////////////////////////////
              Consumer<ProductDetailsViewModel>(
                  builder: (context, model, child) {
                if (model.suggestedProducts != null &&
                    model.suggestedProducts.length > 0) {
                  return ProductsCarousel(
                    products: model.suggestedProducts,
                    onCartItemChanged: (ProductEntity product) async {
                      bool isSuccess = false;
                      // update item in cart using cart helper
                      if (isAddingOperation(product)) {
                        // add to cart
                        CartResponses response = await model.addToCart(product);
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
                      setState(() {
                        // if success update the UI
                        if (isSuccess) {
                          model
                              .suggestedProducts[
                                  model.suggestedProducts.indexOf(product)]
                              .isAddedToCart = true;
                          model
                              .suggestedProducts[
                                  model.suggestedProducts.indexOf(product)]
                              .inCartCount = product.inCartCount;
                        }
                      });
                    },
                    onCartItemRemoved: (ProductEntity product) async {
                      bool isSuccess = false;
                      // remove item from cart using cart helper
                      CartResponses response = await model.removeItem(product);
                      if (response == CartResponses.Removed) {
                        isSuccess = true;
                      }
                      setState(() {
                        // if success update the UI
                        if (isSuccess) {
                          model
                              .suggestedProducts[
                                  model.suggestedProducts.indexOf(product)]
                              .isAddedToCart = false;
                        }
                      });
                    },
                  );
                } else {
                  return Container(
                    height: 16,
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
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

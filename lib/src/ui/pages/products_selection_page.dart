import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food_deliver/src/api/models/response/store_response_api.dart';
import 'package:food_deliver/src/db/entity/product_entity.dart';
import 'package:food_deliver/src/routes/router.gr.dart';
import 'package:food_deliver/src/ui/pages/search/product_search_page.dart';
import 'package:food_deliver/src/ui/widgets/carousel_products.dart';
import 'package:food_deliver/src/ui/widgets/product_item.dart';
import 'package:food_deliver/src/ui/widgets/round_category_item.dart';
import 'package:food_deliver/src/ui/widgets/search_bar_widget.dart';
import 'package:food_deliver/src/ui/widgets/shimmers/shimmer_list_1.dart';
import 'package:food_deliver/src/utills/cart_helper.dart';
import 'package:food_deliver/src/utills/response_codes.dart';
import 'package:food_deliver/src/values/colors.dart';
import 'package:food_deliver/src/viewmodels/product_selection_page_viewmodel.dart';
import 'package:loadmore/loadmore.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ProductSelectionPage extends StatefulWidget {
  final StoreResponseApi storeResponseApi;
  final Function onCartPressed;

  const ProductSelectionPage(
      {Key key, @required this.storeResponseApi, this.onCartPressed})
      : super(key: key);

  @override
  _ProductSelectionPageState createState() => _ProductSelectionPageState();
}

class _ProductSelectionPageState extends State<ProductSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          ProductSelectionPageViewModel(context, widget.storeResponseApi),
      child: Scaffold(
          body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            Consumer<ProductSelectionPageViewModel>(
                builder: (context, model, child) {
              return SliverAppBar(
                expandedHeight: 250.0,
                floating: false,
                pinned: true,
                actions: <Widget>[
                  ///////////////////  Icons ///////////////////////////////////////
                  model.cartItemsCount != 0
                      ? GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 16, 0),
                            child: new Stack(
                              children: <Widget>[
                                Icon(Icons.shopping_cart),
                                new Positioned(
                                  right: 0,
                                  child: new Container(
                                    padding: EdgeInsets.all(1),
                                    decoration: new BoxDecoration(
                                      color: AppColors.WARNING_NOTIFY_COLOR,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 12,
                                      minHeight: 12,
                                    ),
                                    child: new Text(
                                      model.cartItemsCount.toString(),
                                      style: new TextStyle(
                                        color: AppColors.TEXT_WHITE,
                                        fontSize: 8,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            ExtendedNavigator.of(context)
                                .popUntil((route) => route.isFirst);
                            widget.onCartPressed();
                          },
                        )
                      : GestureDetector(
                          onTap: () {
                            ExtendedNavigator.of(context)
                                .popUntil((route) => route.isFirst);
                            widget.onCartPressed();
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                            child: Icon(Icons.shopping_cart),
                          ),
                        )
                ],
                ///////////////////////// Heading ////////////////////////////////
                iconTheme: IconThemeData(color: AppColors.TEXT_WHITE),
                backgroundColor: AppColors.MAIN_COLOR,
                flexibleSpace: FlexibleSpaceBar(
                    title: Material(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.BACK_WHITE_COLOR,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 3),
                        child: Text(
                            widget.storeResponseApi.storeName != null
                                ? widget.storeResponseApi.storeName
                                : 'select_a_package'.tr(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: AppColors.DARK_TEXT_COLOR,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            )),
                      ),
                    ),
                    ////////////////////// Image ///////////////////////////////////
                    background: CachedNetworkImage(
                      imageUrl: widget.storeResponseApi.storeImageURL != null
                          ? widget.storeResponseApi.storeImageURL
                          : "",
                      errorWidget: (context, url, error) => Image.asset(
                          "assets/images/shopping_add_to_cart_illustration.png",
                          height: 150.0
                      ),
                      placeholder: (context, url) => SizedBox(
                        height: 150.0,
                        child: Shimmer.fromColors(
                          baseColor: Colors.black12,
                          highlightColor: Colors.grey,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                            child: Text(
                              widget.storeResponseApi.storeName != null
                                  ? widget.storeResponseApi.storeName
                                  : 'FairSpace',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      height: 150,
                      width: 500,
                      fit: BoxFit.cover,
                    )),
              );
            }),
          ];
        },
        ///////////////////   BODY  //////////////////////////////////////////////////
        body: SingleChildScrollView(
          child: Consumer<ProductSelectionPageViewModel>(
              builder: (context, model, child) {
            return Column(
              children: <Widget>[
                /////////////////////////  Search Bar  ///////////////////////////////////////////
                GestureDetector(
                    onTap: () {
                      ExtendedNavigator.of(context).pushNamed(
                          Routes.productSearchPage,
                          arguments: ProductSearchPageArguments(
                              onCartPressed: widget.onCartPressed,
                              merchantId: widget.storeResponseApi.Id,
                              productSearchType:
                                  ProductSearchType.InStoreSearch));
                    },
                    child: SearchBar()),
                ////////////////////////  Categories Heading  ////////////////////////////////////////////
                model.categories != null && model.categories.length > 0
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Categories",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: AppColors.DARK_TEXT_COLOR,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: (){
                                  ExtendedNavigator.of(context).pushNamed(Routes.storeViewAllCategoriesPage, arguments: StoreViewAllCategoriesPageArguments(
                                    onCartPressed: widget.onCartPressed,
                                    storeResponseApi: widget.storeResponseApi,
                                  ));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "View All",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: AppColors.LIGHT_TEXT_COLOR,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(),
                ///////////////////////////  Categories ListView  /////////////////////////////////////////
                Container(
                  child: Consumer<ProductSelectionPageViewModel>(
                      builder: (context, model, child) {
//                    if (model.categories == null ||
//                        model.categories.length == 0) {
//                      return Container();
//                    }
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 700),
//                      color: model.categories == null || model.categories.length == 0 ? Colors.grey : Colors.transparent,
                      height: model.categories == null ||
                              model.categories.length == 0
                          ? 0
                          : 140,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: model.categories != null ? model.categories.map((category) {
                          return Padding(
                            padding: model.categories.indexOf(category) == 0
                                ? const EdgeInsets.only(left: 16)
                                : const EdgeInsets.all(0),
                            child: RoundCategoryItem(
                              categoriesModel: category,
                              onClick: () {
                                ExtendedNavigator.of(context).pushNamed(
                                    Routes.storeCategoryBasedProductsPage,
                                    arguments:
                                        StoreCategoryBasedProductsPageArguments(
                                      storeResponseApi: widget.storeResponseApi,
                                      categoriesModel: category,
                                    ));
                              },
                            ),
                          );
                        }).toList() : [Container()],
                      ),
                    );
                  }),
                ),
                /////////////////////////   Top Sellers Heading   ////////////////////////////////////////////
                Container(
                  height: 8,
                ),
                Consumer<ProductSelectionPageViewModel>(
                    builder: (context, model, child) {
                  return model.topProducts != null &&
                          model.topProducts.length > 0
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Top Sellers",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: AppColors.DARK_TEXT_COLOR,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "View All",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: AppColors.LIGHT_TEXT_COLOR,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : Container();
                }),
                //////////////////////////  Top Sellers Carousel  //////////////////////////////////////////
                Consumer<ProductSelectionPageViewModel>(
                    builder: (context, model, child) {
                  if (model.topProducts != null &&
                      model.topProducts.length > 0) {
                    return ProductsCarousel(
                      products: model.topProducts,
                      onCartPressed: widget.onCartPressed,
                      onCartItemChanged: (ProductEntity product) async {
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
                        setState(() {
                          // if success update the UI
                          if (isSuccess) {
                            model
                                .topProducts[model.topProducts.indexOf(product)]
                                .isAddedToCart = true;
                            model
                                .topProducts[model.topProducts.indexOf(product)]
                                .inCartCount = product.inCartCount;
                            model.getAllProducts(context);
                          }
                        });
                      },
                      onCartItemRemoved: (ProductEntity product) async {
                        bool isSuccess = false;
                        // remove item from cart using cart helper
                        CartResponses response =
                            await model.removeItem(product);
                        if (response == CartResponses.Removed) {
                          isSuccess = true;
                        }

                        // if success update the UI
                        if (isSuccess) {
                          setState(() {
                            model
                                .topProducts[model.topProducts.indexOf(product)]
                                .isAddedToCart = false;
                          });
                        }
                      },
                    );
                  } else {
                    return Container(
                      height: 16,
                    );
                  }
                }),
                /////////////////////////  All Products Heading  ////////////////////////////////////////////
                Container(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "All Products",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: AppColors.DARK_TEXT_COLOR,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ////////////////////////  All Products List View /////////////////////////////////////////////
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Consumer<ProductSelectionPageViewModel>(
                        builder: (context, model, child) {
                      if (model.products != null && model.products.length > 0) {
                        return LoadMore(
                          isFinish: model.products != null
                              ? model.products.length >= model.allProductsCount
                              : true,
                          onLoadMore: model.loadProducts,
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
                            shrinkWrap: true,
                            itemCount: model.products.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              if (index < model.products.length) {
                                ProductEntity product = model.products[index];
                                return Container(
                                  child: ProductItem(
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
                                          model.getTopProducts(context);
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
                                  ),
                                );
                              }
                              return Container(
                                height: 150,
                              );
                            },
                          ),
                        );
                      } else if (model.currentResponseGetProducts == Responses.NO_DATA) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 40, bottom: 60),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SafeArea(
                                  child: SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: Image.asset(
                                      "assets/images/no_order.png",
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 16, 0, 0),
                                  child: Text(
                                    "No Products",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                  ),
                                ),
                                Text(
                                  "This store doesn't offer any productsr",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w200,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      else if (model.currentResponseGetProducts == Responses.NETWORK_DISCONNECTED){
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
                      }
                      else {
                        return ShimmerListType1();
                      }
                    }),
                  ),
                )
              ],
            );
          }),
        ),
      )),
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

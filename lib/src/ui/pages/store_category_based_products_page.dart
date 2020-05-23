import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_deliver/src/api/models/response/categoryResposeApi.dart';
import 'package:food_deliver/src/api/models/response/store_response_api.dart';
import 'package:food_deliver/src/db/entity/product_entity.dart';
import 'package:food_deliver/src/routes/router.gr.dart';
import 'package:food_deliver/src/ui/pages/search/product_search_page.dart';
import 'package:food_deliver/src/ui/widgets/product_item.dart';
import 'package:food_deliver/src/ui/widgets/search_bar_widget.dart';
import 'package:food_deliver/src/utills/cart_helper.dart';
import 'package:food_deliver/src/values/colors.dart';
import 'package:food_deliver/src/viewmodels/store_category_based_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class StoreCategoryBasedProductsPage extends StatefulWidget {
  final CategoryResponseApi categoriesModel;
  final StoreResponseApi storeResponseApi;
  final Function onCartPressed;

  const StoreCategoryBasedProductsPage(
      {Key key,
      @required this.categoriesModel,
      this.onCartPressed,
      @required this.storeResponseApi})
      : super(key: key);

  @override
  _StoreCategoryBasedProductsPageState createState() =>
      _StoreCategoryBasedProductsPageState();
}

class _StoreCategoryBasedProductsPageState
    extends State<StoreCategoryBasedProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 250.0,
              floating: false,
              pinned: true,
              iconTheme: IconThemeData(color: AppColors.DARK_TEXT_COLOR),
              backgroundColor: AppColors.BACK_WHITE_COLOR,
              flexibleSpace: FlexibleSpaceBar(
                  title: Material(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.BACK_WHITE_COLOR,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                          (widget.categoriesModel != null &&
                                  widget.categoriesModel.name != null
                              ? widget.categoriesModel.name
                              : "No Name"),
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
                    imageUrl: widget.categoriesModel.imageUrl != null
                        ? widget.categoriesModel.imageUrl
                        : "",
                    errorWidget: (context, url, error) => Image.asset(
                      "assets/images/page_not_found_illustration.png",
                      width: MediaQuery.of(context).size.width - 160,
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
                            (widget.categoriesModel != null &&
                                    widget.categoriesModel.name != null
                                ? widget.categoriesModel.name
                                : "No Name"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24.0,
                              color: AppColors.DARK_TEXT_COLOR,
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
            )
          ];
        },
        body: ChangeNotifierProvider(
          create: (context) => StoreCategoryBasedViewModel(
              context, widget.storeResponseApi, widget.categoriesModel),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      ExtendedNavigator.of(context).pushNamed(
                          Routes.productSearchPage,
                          arguments: ProductSearchPageArguments(
                              onCartPressed: widget.onCartPressed,
                              categoryId: widget.categoriesModel.Id,
                              productSearchType:
                                  ProductSearchType.CategorySearch));
                    },
                    child: SearchBar()),
                /////////////////////////////////////////////////////////////////////
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Consumer<StoreCategoryBasedViewModel>(
                        builder: (context, model, child) {
                      if (model.products != null && model.products.length > 0) {
                        return ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: model.products.map((product) {
                            return Container(
                              height: 180,
                              child: ProductItem(
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
                                  }

                                  // if success update UI
                                  setState(() {
                                    if (isSuccess) {
                                      product.inCartCount = value;
                                      product.isAddedToCart = true;
                                    }
                                  });
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
                          }).toList(),
                        );
                      } else {
                        return Container(
                          height: 16,
                        );
                      }
                    }),
                  ),
                )
              ],
            ),
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

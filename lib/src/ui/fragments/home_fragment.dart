import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:food_deliver/src/api/models/response/store_response_api.dart';
import 'package:food_deliver/src/routes/router.gr.dart';
import 'package:food_deliver/src/ui/widgets/carousel_widget.dart';
import 'package:food_deliver/src/ui/widgets/category_items_widget.dart';
import 'package:food_deliver/src/ui/widgets/search_bar_widget.dart';
import 'package:food_deliver/src/ui/widgets/shimmers/shimmer_item_3.dart';
import 'package:food_deliver/src/ui/widgets/shimmers/shimmer_list_2.dart';
import 'package:food_deliver/src/ui/widgets/stores_carousel_widget.dart';
import 'package:food_deliver/src/values/colors.dart';
import 'package:food_deliver/src/viewmodels/home_fragment_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeFragment extends StatelessWidget {
  final Function onCartPressed;

  const HomeFragment({Key key, this.onCartPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: AppColors.TEXT_WHITE,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: ChangeNotifierProvider(
            create: (context) => HomeFragmentViewModel(context),
            child: Column(
              children: <Widget>[
                /////////////////////////////////////////////////////////////////////////////////////////
                Consumer<HomeFragmentViewModel>(
                    builder: (context, model, child) {
                      if (model.carouselImages != null &&
                          model.carouselImages.length > 0) {
                        return CustomCarousel(
                          carousels: model.carouselImages,
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 40, 0, 22),
                          child: ShimmerItem3(),
                        );
                      }
                    }),
                ////////////////////////////////////////////////////////////////////////////////////////
                GestureDetector(
                    onTap: () {
                      ExtendedNavigator.of(context)
                          .pushNamed(Routes.globalSearchPage);
                    },
                    child: SearchBar()),
                ////////////////////////////////////////////////////////////////////////////////////////
                Padding(
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
                          onTap: () {
                            ExtendedNavigator.of(context).pushNamed(
                                Routes.viewAllCategoriesPage,
                                arguments: ViewAllCategoriesPageArguments(
                                  onCartPressed: onCartPressed
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
                ),
                /////////////////////////////////// END OF CATEGORY HEADING  ////////////////////////////////////////////////////
                Wrap(
                  children: <Widget>[
                    Container(
                      child: Consumer<HomeFragmentViewModel>(
                          builder: (context, model, child) {
                            if (model.categories != null && model.categories.length > 0) {
                              return CategoryItems(
                                onCartPressed: onCartPressed,
                                categories: model.categories,
                              );
                            }
                            else{
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: ShimmerListType2(),
                              );
                            }
                          }),
                    ),
                  ],
                ),
                /////////////////////////////////// END OF CATEGORIES  ////////////////////////////////////////////////////
                Consumer<HomeFragmentViewModel>(
                  builder: (context, model, child) {
                    return model.stores != null && model.stores.length > 0 ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Stores Near You",
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
                              child: GestureDetector(
                                onTap: () {
                                  ExtendedNavigator.of(context)
                                      .pushNamed(Routes.storeSelectionPage,
                                      arguments: StoreSelectionPageArguments(
                                        onCartPressed: onCartPressed,
                                        onCartItemChanged: (val) {},
                                      ));
                                },
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
                    ) : Container();
                  }
                ),
                ///////////////////////////////////////////////////////////////////////////////////////////////////
                Consumer<HomeFragmentViewModel>(
                    builder: (context, model, child) {
                      if (model.stores != null &&
                          model.stores.length > 0) {
                        return StoresCarousel(
                          onClick: (StoreResponseApi store){
                              ExtendedNavigator.of(context).pushNamed(
                                  Routes.productSelectionPage,
                                  arguments:
                                  ProductSelectionPageArguments(
                                      storeResponseApi:
                                      store,
                                      onCartPressed: onCartPressed));
                          },
                          stores: model.stores,
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
      ),
    );
  }
}

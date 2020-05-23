import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:food_deliver/src/api/models/response/categoryResposeApi.dart';
import 'package:food_deliver/src/api/models/response/store_response_api.dart';
import 'package:food_deliver/src/routes/router.gr.dart';
import 'package:food_deliver/src/ui/widgets/category_items_widget.dart';
import 'package:food_deliver/src/values/colors.dart';
import 'package:food_deliver/src/viewmodels/store_view_all_categories_viewmodel.dart';
import 'package:provider/provider.dart';

class StoreViewAllCategoriesPage extends StatefulWidget {
  final Function onCartPressed;
  final StoreResponseApi storeResponseApi;

  const StoreViewAllCategoriesPage({Key key, this.onCartPressed, this.storeResponseApi}) : super(key: key);

  @override
  _StoreViewAllCategoriesPageState createState() => _StoreViewAllCategoriesPageState();
}

class _StoreViewAllCategoriesPageState extends State<StoreViewAllCategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StoreViewAllCategoriesViewModel(context: context, storeResponseApi: widget.storeResponseApi),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.MAIN_COLOR,
          title: Text("Categories"),
        ),
        body: SingleChildScrollView(
          child: Wrap(
            children: <Widget>[
              Container(
                child: Consumer<StoreViewAllCategoriesViewModel>(
                    builder: (context, model, child) {
                      if (model.categories != null && model.categories.length > 0) {
                        return CategoryItems(
                          onPressed: (CategoryResponseApi category){
                            ExtendedNavigator.of(context).pushNamed(
                                Routes.storeCategoryBasedProductsPage,
                                arguments:
                                StoreCategoryBasedProductsPageArguments(
                                  storeResponseApi: widget.storeResponseApi,
                                  categoriesModel: category,
                                ));
                          },
                          onCartPressed: widget.onCartPressed,
                          categories: model.categories,
                        );
                      }
                      return Container();
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

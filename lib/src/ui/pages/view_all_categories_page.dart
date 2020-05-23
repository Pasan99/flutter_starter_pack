import 'package:flutter/material.dart';
import 'package:food_deliver/src/ui/widgets/category_items_widget.dart';
import 'package:food_deliver/src/values/colors.dart';
import 'package:food_deliver/src/viewmodels/view_all_categories_viewmodel.dart';
import 'package:provider/provider.dart';

class ViewAllCategoriesPage extends StatefulWidget {
  final Function onCartPressed;

  const ViewAllCategoriesPage({Key key, this.onCartPressed}) : super(key: key);

  @override
  _ViewAllCategoriesPageState createState() => _ViewAllCategoriesPageState();
}

class _ViewAllCategoriesPageState extends State<ViewAllCategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ViewAllCategoriesViewModel(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.MAIN_COLOR,
          title: Text("Categories"),
        ),
        body: SingleChildScrollView(
          child: Wrap(
            children: <Widget>[
              Container(
                child: Consumer<ViewAllCategoriesViewModel>(
                    builder: (context, model, child) {
                      if (model.categories != null && model.categories.length > 0) {
                        return CategoryItems(
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

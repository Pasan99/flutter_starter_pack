import 'package:flutter/material.dart';
import 'package:food_deliver/src/db/entity/package_entity.dart';
import 'package:food_deliver/src/values/colors.dart';

class PackageItemWidget extends StatefulWidget {
  PackageEntity item;
  final Function onClick;
  final Function onItemCountChanged;
  final Function onGoToCart;

  PackageItemWidget({this.item, this.onClick, this.onItemCountChanged, this.onGoToCart}){
    if (item.inventoryCount == null){
      item.inventoryCount = 100;
    }
  }

  @override
  _PackageItemState createState() => _PackageItemState();
}

class _PackageItemState extends State<PackageItemWidget> {

  _PackageItemState();

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.fromLTRB(
          8, 8, 8, 8
      ),
      child: Container(
        child: Material(
          color: AppColors.BACK_WHITE_COLOR,
          elevation: 14.0,
          borderRadius: BorderRadius.circular(8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                          24, 16, 24, 16),
                      child: Text(
                        widget.item.packageName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                          16, 16, 24, 16),
                      child: Text(
                        'LKR  ' + widget.item.packageAmount.toStringAsFixed(2),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Divider(
                height: 2.0,
                color: AppColors.DIVIDER_COLOR,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(28, 8, 16, 12),
                      child: Text(
                        widget.item.items.length.toString() + " Items",
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8,24, 12),
                    child: OutlineButton(
                      onPressed: widget.onClick,
                      color: Colors.black87,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      child: Text("See all items", style: TextStyle(color: AppColors.DARK_TEXT_COLOR, fontSize: 12), ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Divider(
                  height: 2.0,
                  color: AppColors.DIVIDER_COLOR,
                ),
              ),
              GestureDetector(
                onTap: widget.onClick,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      32, 8, 32, 0),
                  child: SizedBox(
                    height: 160,
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      children: widget.item.items.map( (packageItem) {
                        return Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                child: Text(packageItem.productName != null ? "●  "  + packageItem.productName : ""),
                                padding: EdgeInsets.fromLTRB(
                                    0, 5, 0, 0),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                child: Text(packageItem.qty != null ? packageItem.qty.toString() : "",
                                  textAlign: TextAlign.end,),
                                padding: EdgeInsets.fromLTRB(
                                    0, 5, 0, 0),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Divider(
                  height: 2.0,
                  color: AppColors.DIVIDER_COLOR,
                ),
              ),

////////////////////////////////  Add to cart button use Product Entity /////////////////////////////


//              Padding(
//                padding: const EdgeInsets.fromLTRB(
//                    24,16, 24, 16),
//                child: widget.item.inventoryCount > 0 ? AddToCartButton(
//                    item: widget.item,
//                  onChanged: (val) {
//                      widget.onItemCountChanged(val);
//                  },
//                  onRemoveFromCart: widget.onGoToCart,
//                ) :
//                Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      Icon(Icons.store, color: AppColors.WARNING_NOTIFY_COLOR,),
//                      Padding(
//                        padding: const EdgeInsets.symmetric(horizontal: 12),
//                        child: Text("Out of Stock", style: TextStyle(color: AppColors.WARNING_NOTIFY_COLOR),),
//                      ),
//                    ],
//                  ),
//                )
//              ),
            ],
          ),
        ),
      ),
    );
  }
}

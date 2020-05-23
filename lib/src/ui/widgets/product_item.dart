import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_deliver/src/db/entity/product_entity.dart';
import 'package:food_deliver/src/routes/router.gr.dart';
import 'package:food_deliver/src/ui/widgets/add_to_cart_btn.dart';
import 'package:food_deliver/src/values/colors.dart';
import 'package:shimmer/shimmer.dart';

class ProductItem extends StatefulWidget {
  final ProductEntity productEntity;
  final Function onCartItemChanged;
  final Function onCartItemChangedFromDetails;
  final Function onRemoveFromCart;
  final Function onCartPressed;

  ProductItem(
      {Key key,
      @required this.productEntity,
      this.onCartItemChanged,
      this.onRemoveFromCart,
      this.onCartPressed,
      this.onCartItemChangedFromDetails})
      : super(key: key);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  num getItemPrice() {
    num price = 0.0;
    if (widget.productEntity.productAmount != null) {
      // custom increments
      if (widget.productEntity.qntIncrements != null &&
          widget.productEntity.qntIncrements.length > 0) {
        price = widget.productEntity.productAmount *
            widget.productEntity.qntIncrements[0];
      }
      // simple increments
      else {
        price = widget.productEntity.productAmount;
      }
    }
    return price;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.productEntity == null) {
      return Container();
    }
    return GestureDetector(
      onTap: () {
        ExtendedNavigator.of(context).pushNamed(Routes.productDetailsPage,
            arguments: ProductDetailsPageArguments(
                onCartItemCountChanged: widget.onCartItemChangedFromDetails,
                productEntity: widget.productEntity,
                onCartPressed: widget.onCartPressed));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 1),
        child: Container(
          color: AppColors.BACK_WHITE_COLOR,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: CustomListItem(
              price: getItemPrice(),
              thumbnail: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: widget.productEntity.image != null
                        ? widget.productEntity.image
                        : "",
                    errorWidget: (context, url, error) => Image.asset(
                      "assets/images/factory_illustration.png",
                      height: 150.0,
                    ),
                    placeholder: (context, url) => SizedBox(
                      height: 140,
                      width: 120,
                      child: Shimmer.fromColors(
                        baseColor: Colors.black12,
                        highlightColor: Colors.grey,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                          child: Text(
                            'C',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    height: 140,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              unit: widget.productEntity.unitOfMeasure != null
                  ? widget.productEntity.unitOfMeasure
                  : "",
              title: (widget.productEntity.brand != null
                      ? "${widget.productEntity.brand} - "
                      : "") +
                  (widget.productEntity.productName != null
                      ? widget.productEntity.productName
                      : "-"),
              productEntity: widget.productEntity,
              onChange: (value) {
                widget.productEntity.inCartCount = value;
                widget.onCartItemChanged(value);
              },
              onRemoveFromCart: () {
                widget.onRemoveFromCart();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class CustomListItem extends StatelessWidget {
  const CustomListItem(
      {this.thumbnail,
      this.title,
      this.user,
      this.price,
      this.onChange,
      this.onRemoveFromCart,
      this.productEntity,
      this.unit});

  final Widget thumbnail;
  final String title;
  final String user;
  final String unit;
  final num price;
  final onChange;
  final onRemoveFromCart;
  final ProductEntity productEntity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: thumbnail,
          ),
          Expanded(
            flex: 3,
            child: _VideoDescription(
              price: price,
              title: title,
              user: user,
              unit: unit,
              onRemoveFromCart: onRemoveFromCart,
              onChange: onChange,
              productEntity: productEntity,
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoDescription extends StatefulWidget {
  _VideoDescription({
    Key key,
    this.title,
    this.user,
    this.price,
    this.onChange,
    this.onRemoveFromCart,
    this.productEntity,
    this.unit,
  }) : super(key: key);

  final String title;
  final String user;
  final num price;
  final onChange;
  final onRemoveFromCart;
  final String unit;
  final ProductEntity productEntity;

  @override
  __VideoDescriptionState createState() => __VideoDescriptionState();
}

class __VideoDescriptionState extends State<_VideoDescription> {
  @override
  Widget build(BuildContext context) {
    print(widget.productEntity.qntIncrements);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0.0, 0.0, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.title,
            maxLines: 3,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            "LKR " + widget.price.toStringAsFixed(2) + " per ${widget.unit}",
            maxLines: 1,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
          widget.productEntity.stock == null || widget.productEntity.stock >= 1
              ? AddToCartButton(
                  symbol: widget.productEntity.unitOfMeasure != null
                      ? widget.productEntity.unitOfMeasure.symbol
                      : "",
                  customSteps: widget.productEntity.qntIncrements != null
                      ? widget.productEntity.qntIncrements
                          .map((e) => e.toDouble())
                          .toList()
                      : null,
                  item: widget.productEntity,
                  onChanged: widget.onChange,
                  onRemoveFromCart: widget.onRemoveFromCart)
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
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "Out of Stock",
                          style: TextStyle(color: AppColors.LIGHT_TEXT_COLOR),
                        ),
                      ),
                    ],
                  ),
                )
        ],
      ),
    );
  }
}

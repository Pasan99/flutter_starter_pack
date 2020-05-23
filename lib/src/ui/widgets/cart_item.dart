
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_deliver/src/db/entity/cart_item_entity.dart';
import 'package:food_deliver/src/db/entity/product_entity.dart';
import 'package:food_deliver/src/routes/router.gr.dart';
import 'package:food_deliver/src/ui/widgets/add_to_cart_btn.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class CartItem extends StatefulWidget {
  CartItemEntity item;
  final Function onQuantityChanged;
  final Function onRemove;
  final Function onCartPressed;
  final Function onCartItemChangedFromDetails;

  CartItem({this.item, this.onQuantityChanged, this.onRemove, this.onCartPressed, this.onCartItemChangedFromDetails});

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {

  num getItemPrice(){
    num price = 0.0;
    if (widget.item.product.productAmount != null){
      // custom increments
      if (widget.item.product.qntIncrements != null && widget.item.product.qntIncrements.length > 0){
        if (widget.item.product.inCartCount > widget.item.product.qntIncrements[0]){
          price = widget.item.product.productAmount *
              widget.item.product.inCartCount;
        }
        else {
          price = widget.item.product.productAmount *
              widget.item.product.qntIncrements[0];
        }
      }
      // simple increments
      else{
        if (widget.item.product.inCartCount > 1) {
          price = widget.item.product.productAmount * widget.item.product.inCartCount ;
        }
        else{
          price = widget.item.product.productAmount;
        }
      }
    }
    return price;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.item.product == null) {
      return Container();
    }
    return GestureDetector(
      onTap: (){
        ExtendedNavigator.of(context).pushNamed(Routes.productDetailsPage, arguments: ProductDetailsPageArguments(
            onCartItemCountChanged: widget.onCartItemChangedFromDetails,
            productEntity: widget.item.product,
            onCartPressed: widget.onCartPressed
        ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: CustomListItem(
          price: getItemPrice(),
          thumbnail: Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                imageUrl: widget.item.product.image != null ? widget.item.product.image : "",
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
          title: widget.item.product.productName != null
              ? widget.item.product.productName
              : "-",
          productEntity: widget.item.product,
          onChange: (value){
            widget.onQuantityChanged(value);
          },
          onRemoveFromCart: widget.onRemove,
          customSteps: widget.item.product.qntIncrements,
          symbol: widget.item.product.unitOfMeasure != null ? widget.item.product.unitOfMeasure.symbol : "",
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
        this.symbol,
        this.customSteps});

  final Widget thumbnail;
  final String title;
  final String user;
  final num price;
  final onChange;
  final String symbol;
  final List<num> customSteps;
  final Function onRemoveFromCart;
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
              onRemoveFromCart: onRemoveFromCart,
              onChange: onChange,
              productEntity: productEntity,
              symbol: symbol,
              customSteps: customSteps,
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
    this.symbol,
    this.customSteps,
  }) : super(key: key);

  final String title;
  final String user;
  final num price;
  final onChange;
  final String symbol;
  final List<num> customSteps;
  final Function onRemoveFromCart;
  final ProductEntity productEntity;

  @override
  __VideoDescriptionState createState() => __VideoDescriptionState();
}

class __VideoDescriptionState extends State<_VideoDescription> {
  @override
  Widget build(BuildContext context) {
    print("count : " + widget.productEntity.isAddedToCart.toString());
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
            "LKR " + widget.price.toStringAsFixed(2),
            maxLines: 1,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
          AddToCartButton(
              item: widget.productEntity,
              symbol: widget.symbol,
              customSteps: widget.productEntity.qntIncrements != null ? widget.productEntity.qntIncrements.map((e) => e.toDouble()).toList() : null,
              onChanged: widget.onChange,
              onRemoveFromCart: widget.onRemoveFromCart)
        ],
      ),
    );
  }
}


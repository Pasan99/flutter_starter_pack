import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_deliver/src/api/models/response/store_response_api.dart';
import 'package:food_deliver/src/values/colors.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class StoreItem extends StatelessWidget {
  StoreResponseApi card;
  int progress = 0;

  StoreItem({this.card});

  @override
  Widget build(BuildContext context) {
    if (card != null) {
      return Container(
        color: AppColors.BACK_WHITE_COLOR,
        child: StoreItemView(
          name: card.storeName != null ? card.storeName : "",
          city: card.cityName != null ? card.cityName : "",
          image: card.storeImageURL,
          address: "${card.street != null ? card.street + "," : ""} "
              "${card.mainRoad != null ? card.mainRoad + "," : ""} "
              "${card.cityName != null ? card.cityName : ""}",
        ),
      );
    } else {
      return Container(
        key: Key("Empty"),
      );
    }
  }
}

class StoreItemView extends StatelessWidget {
  const StoreItemView({this.image, this.name, this.city, this.address});

  final String image;
  final String name;
  final String city;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  imageUrl: image != null ? image : "",
                  errorWidget: (context, url, error) => Image.asset(
                    "assets/images/page_not_found_illustration.png",
                    width: 120,
                    height: 140.0,
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
          ),
          Expanded(
            flex: 3,
            child: _StoreDetails(
              name: name,
              address: address,
              city: city,
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreDetails extends StatefulWidget {
  _StoreDetails({Key key, this.name, this.city, this.address})
      : super(key: key);

  final String name;
  final String city;
  final String address;

  @override
  __StoreDetailsState createState() => __StoreDetailsState();
}

class __StoreDetailsState extends State<_StoreDetails> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0.0, 0.0, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.name,
            maxLines: 2,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            widget.city == "Unknown" ? "" : widget.city,
            maxLines: 1,
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 14.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Divider(height: 1,color: AppColors.DIVIDER_COLOR,),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
          Row(children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 24),
              child: Icon(
                CupertinoIcons.location_solid,
                color: AppColors.LIGHT_MAIN_COLOR,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 24, 24),
                child: Text(
                  widget.address,
                  maxLines: 2,
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

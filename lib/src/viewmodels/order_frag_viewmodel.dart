import 'package:flutter/material.dart';
import 'package:food_deliver/src/api/api_constants.dart';
import 'package:food_deliver/src/api/api_requests.dart';
import 'package:food_deliver/src/api/models/response/order_response_api.dart';
import 'package:food_deliver/src/db/entity/user_entity.dart';
import 'package:food_deliver/src/utills/language_helper.dart';
import 'package:food_deliver/src/utills/response_codes.dart';
import 'package:food_deliver/src/utills/user_auth.dart';
import 'package:food_deliver/src/ext/list_extension.dart';

class OrderFragViewModel extends ChangeNotifier {
  List<Order> orderList = List();
  int _currentPageID = 1;
  int pageSize = 10;
  String language;
  int totalOrderCount;
  Responses currentResponse;

  int pages = 0;
  int total = 0;

  final BuildContext context;

  OrderFragViewModel(this.context) {
    getResponse(context);
  }

  getResponse(BuildContext context) async {
    try {
      UserEntity user = await UserAuth().getCurrentUser();
      language = user.language.toLowerCase();
      OrderResponsePaginationApi tempResponse =
          await getOrderPaginationData(context, _currentPageID, pageSize);
      totalOrderCount = tempResponse.total;

      if (tempResponse == null ||
          tempResponse.itemList.isInvalid() ||
          tempResponse.itemList[0].total == 0 ||
          tempResponse.itemList[0].data.isInvalid()) {
        currentResponse = Responses.NO_DATA;
        notifyListeners();
        return;
      }

      this.orderList.clear();
      this.orderList.addAll(tempResponse.itemList[0].data);
      pages = tempResponse.itemList[0].page;
      total = tempResponse.itemList[0].total;
      orderList.forEach((order) async {
        order.convertedName =
            await LanguageHelper(names: order.storeName).getName();
        if (order.items != null) {
          order.items.forEach((item) async {
            if (item != null) {
              item.convertedPackageName =
              await LanguageHelper(names: item.packageName).getName();
              if (item.packageItems != null) {
                item.packageItems.forEach((packItem) async {
                  packItem.product =
                  await LanguageHelper(names: packItem.productName).getName();
                });
              }
            }
          });

          // fees
          if (order.fees != null) {
            order.fees.forEach((fee) async {
              order.feeTotal += fee.amount;
              if (fee.names != null) {
                fee.name = await LanguageHelper(names: fee.names).getName();
              }
              else {
                fee.name = "-";
              }
            });
          }
        }
      });

      // sort orders
      orderList.sort((a, b) {
        return b.orderId.compareTo(a.orderId);
      });

      currentResponse = Responses.DATA_RETRIEVED;
      notifyListeners();
    } catch (e) {
      print(e);
      currentResponse = Responses.TIMEOUT;
      notifyListeners();
    }

    currentResponse = Responses.TIMEOUT;
    notifyListeners();
  }

  ///get available orders pagination data from the server
  Future<OrderResponsePaginationApi> getOrderPaginationData(
      BuildContext context, int page, int size) async {
    try {
      UserEntity currentUser = await UserAuth().getCurrentUser();

      APIRequests request = APIRequests();
      OrderResponsePaginationApi result = await request.execute(
          APIConstants.BASE_URL +
              APIConstants.API_CREATE_ORDER +
              '/' +
              currentUser.authId +
              '?page=' +
              page.toString() +
              '&size=' +
              size.toString(),
          context,
          authToken: "",
          body: "",
          responseClass: OrderResponsePaginationApi(),
          apiMethod: ApiMethod.GET);

      if (result == null) return Future.value(null);

      return Future.value(result);
    } catch (e) {
      print(e);
      return Future.value(null);
    }
  }


  Future<bool> loadMore() async {
    Responses response;
    if (_currentPageID * pageSize > orderList.length) {
      OrderResponsePaginationApi tempResponse =
      await getOrderPaginationData(context, _currentPageID + 1, 10);
      tempResponse.data.forEach((order) {
        orderList.add(order);
      });
    }
    if (response == Responses.DATA_RETRIEVED){
      return true;
    }
    return false;
  }
}

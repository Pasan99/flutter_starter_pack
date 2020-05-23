import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_deliver/src/api/api_constants.dart';
import 'package:food_deliver/src/api/api_requests.dart';
import 'package:food_deliver/src/api/models/request/cancel_order_request_api.dart';
import 'package:food_deliver/src/api/models/response/order_response_api.dart';
import 'package:food_deliver/src/utills/language_helper.dart';
import 'package:food_deliver/src/utills/response_codes.dart';

class OrderDetailsViewModel extends ChangeNotifier {
  static const String Received = "Received";
  static const String Confirmed = "Confirmed";
  static const String Scheduled = "Scheduled";
  static const String Picked_Up = "Picked Up";
  static const String On_Route = "On Route";
  static const String Delivered = "Delivered";
  static const String Cancelled = "Cancelled";
  static const String Customer_Cancelled = "Customer Cancelled";
  Responses currentResponse;


  bool RECEIVED = false;
  bool CONFIRMED = false;
  bool SCHEDULED = false;
  bool PICKED_UP = false;
  bool ON_ROUTE = false;
  bool CANCELLED = false;
  bool CUSTOMER_CANCELLED = false;
  bool DELIVERED = false;

  String orderStatus = "";
  Order selectedOrder;
  Order orderResponse;

  OrderDetailsViewModel(Order order){
    selectedOrder = order;
    this.orderStatus = order.status;
    setStatus(this.orderStatus);
  }

  Future<bool> cancelOrder(BuildContext context) async {
    try {
      if (selectedOrder != null) {
        CancelOrderRequestApi cancelOrderModel = CancelOrderRequestApi(
            orderId: selectedOrder.id,
            reason: "Hello"
        );

        APIRequests request = APIRequests();
        Order result = await request.execute(
            APIConstants.BASE_URL + APIConstants.API_CANCEL_ORDER, context,
            authToken: "",
            body: jsonEncode(cancelOrderModel.toMap()),
            responseClass: Order(),
            apiMethod: ApiMethod.POST);

        orderResponse = result;
        if (result.errorBody != null) {
          orderResponse.errorBody = result.errorBody;
          if (result.errorBody.messages != null){
            orderResponse.errorBody.message = await LanguageHelper(names: result.errorBody.messages).getName();
          }
          currentResponse = Responses.DATA_RETRIEVED;
          return Future.value(false);
        }
        currentResponse = Responses.DATA_RETRIEVED;
        return true;
      }
      currentResponse = Responses.NO_DATA;
      return false;
    }catch(i){
      currentResponse = Responses.NETWORK_DISCONNECTED;
      print(i);
      return false;
    }
  }

  setStatus(String status){
    RECEIVED = false;
    CONFIRMED = false;
    SCHEDULED = false;
    PICKED_UP = false;
    ON_ROUTE = false;
    CANCELLED = false;
    CUSTOMER_CANCELLED = false;
    DELIVERED = false;

    switch(status){
      case OrderDetailsViewModel.Received:
        RECEIVED = true;
        break;
      case OrderDetailsViewModel.Confirmed:
        RECEIVED = true;
        SCHEDULED = true;
        CONFIRMED = true;
        break;
      case OrderDetailsViewModel.Scheduled:
        RECEIVED = true;
        SCHEDULED = true;
        CONFIRMED = true;
        break;
      case OrderDetailsViewModel.Picked_Up:
        RECEIVED = true;
        SCHEDULED = true;
        CONFIRMED = true;
        PICKED_UP = true;
        break;
      case OrderDetailsViewModel.On_Route:
        RECEIVED = true;
        SCHEDULED = true;
        CONFIRMED = true;
        PICKED_UP = true;
        ON_ROUTE = true;
        break;
      case OrderDetailsViewModel.Delivered:
        RECEIVED = true;
        SCHEDULED = true;
        CONFIRMED = true;
        PICKED_UP = true;
        ON_ROUTE = true;
        DELIVERED = true;
        break;
      case OrderDetailsViewModel.Cancelled:
        CANCELLED = true;
        break;
      case OrderDetailsViewModel.Customer_Cancelled:
        CANCELLED = true;
        CUSTOMER_CANCELLED = true;
        break;
    }
    notifyListeners();
  }

}

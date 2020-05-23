import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_deliver/src/api/api_constants.dart';
import 'package:food_deliver/src/api/api_requests.dart';
import 'package:food_deliver/src/api/models/api_error_body.dart';
import 'package:food_deliver/src/api/models/request/checkout_transaction_request_api.dart';
import 'package:food_deliver/src/api/models/response/checkout_transaction_response.dart';
import 'package:food_deliver/src/api/models/response/product_response_api.dart';
import 'package:food_deliver/src/db/entity/cart_item_entity.dart';
import 'package:food_deliver/src/db/entity/fees_entity.dart';
import 'package:food_deliver/src/utills/cart_helper.dart';
import 'package:food_deliver/src/utills/language_helper.dart';
import 'package:food_deliver/src/utills/response_codes.dart';

class CartViewModel with ChangeNotifier {
  List<CartItemEntity> items = List<CartItemEntity>();
  List<FeesEntity> fees = List<FeesEntity>();
  List<CartItemEntity> itemsToRemove = List();
  List<CartItemEntity> itemsToChange = List();
  CheckoutTransactionResponseApi validatedOrder;
  Responses currentResponse;

  CartViewModel() {
    getItems();
  }

  double totalPrice = 0;
  double subTotal = 0;
  int quantity = 0;
  double feesTotal = 0;

  double maxOrderCount = 0;
  int maxCashOrderAmount = 100000;

  setTotalsToZero() {
    subTotal = 0;
    totalPrice = 0;
    feesTotal = 0;
  }

  calculateTotal() {
    subTotal = CartHelper().getSubTotal();
    totalPrice = CartHelper().getTotal();
    fees = CartHelper().fees;
  }

  /// get all cart items
  Future<List<CartItemEntity>> getItems() async {
    // get saved cart items
    items = await CartHelper().getCartItems();

    // cart have items
    if (items != null) {
      calculateTotal();
      notifyListeners();
      return Future.value(items);
    }
    // no items
    else {
      calculateTotal();
      notifyListeners();
      return null;
    }
  }

  /// order validation api
//  Future<bool> isOrderValidated(BuildContext context) async {
//    try {
//      ValidateOrderRequestApi validateOrderRequestApi = createValidateOrderRequestApi();
//
//      APIRequests request = APIRequests();
//      ValidateOrderResponseApi result = await request.execute(
//          APIConstants.BASE_URL + APIConstants.API_VALIDATE_ORDER, context,
//          authToken: "",
//          body: jsonEncode(validateOrderRequestApi.toMap(withoutUniqueIDs: false)),
//          responseClass: ValidateOrderResponseApi(),
//          apiMethod: ApiMethod.PUT);
//
//      validatedOrder = result;
//      if (result.errorBody == null) {
//        currentResponse = Responses.DATA_RETRIEVED;
//        notifyListeners();
//        return Future.value(true);
//      } else {
//        if (validatedOrder.errorBody.messages != null) {
//          validatedOrder.errorBody.message =
//              await LanguageHelper(names: validatedOrder.errorBody.messages)
//                  .getName();
//        }
//        currentResponse = Responses.NO_DATA;
//        notifyListeners();
//        return Future.value(false);
//      }
//    } catch (e) {
//      currentResponse = Responses.NETWORK_DISCONNECTED;
//      print(e);
//      return Future.value(false);
//    }
//  }
  // prepare the request model
//  ValidateOrderRequestApi createValidateOrderRequestApi(){
//    List<FeeValidation> feesForValidation =
//    fees.map((fee) => FeeValidation().toFeeValidation(fee)).toList();
//    List<PackageValidation> packagesForValidation = items
//        .map((cartItem) => PackageValidation().toOrderItem(cartItem))
//        .toList();
//    return ValidateOrderRequestApi(
//        fees: feesForValidation,
//        packages: packagesForValidation,
//        storeId: items[0].product.storeId);
//  }

  Future<bool> isOrderValidated(BuildContext context) async {
    try {
      CheckoutTransactionRequestAPI checkoutTransactionRequestAPI =
          createValidateOrderRequestApi();

      APIRequests request = APIRequests();
      CheckoutTransactionResponseApi result = await request.execute(
          APIConstants.BASE_URL_2 + APIConstants.API_CHECKOUT_TRANSACTION,
          context,
          authToken: "",
          body: jsonEncode(
              checkoutTransactionRequestAPI.toMap(withoutUniqueIDs: false)),
          responseClass: CheckoutTransactionResponseApi(),
          apiMethod: ApiMethod.PUT);

      validatedOrder = result;
      await updateOrderStatus();
      if (result.errorBody == null) {
        currentResponse = Responses.DATA_RETRIEVED;
        notifyListeners();
        return Future.value(true);
      } else {
        if (validatedOrder.errorBody.messages != null) {
          validatedOrder.errorBody.message =
              await LanguageHelper(names: validatedOrder.errorBody.messages)
                  .getName();
          currentResponse = Responses.ERROR;
        } else {
          currentResponse = Responses.UNKNOWN_ERROR;
        }
        notifyListeners();
        return Future.value(false);
      }
    } catch (e) {
      currentResponse = Responses.NETWORK_DISCONNECTED;
      print(e);
      return Future.value(false);
    }
  }

  updateOrderStatus() {
    if (validatedOrder != null && validatedOrder.productsStocks != null) {
      items.forEach((item) {
        validatedOrder.productsStocks.forEach((responseProduct) {
          if (responseProduct.Id == item.product.Id) {
            if (responseProduct.stock < item.quantity) {
              if (validatedOrder.errorBody == null) {
                validatedOrder.errorBody = ApiErrorBody();
                validatedOrder.errorBody.products = List();
              }
              validatedOrder.errorBody.messages = {
                "english":
                "Some of the items are changed. Do you like to update the cart ?",
              };
              validatedOrder.errorBody.products.add(ProductResponseApi(
                  stock: responseProduct.stock < 0 ? 0 : responseProduct.stock, Id: responseProduct.Id));
            }
          }
        });
      });
    }
  }

  CheckoutTransactionRequestAPI createValidateOrderRequestApi() {
    if (items != null) {
      List<CheckoutProductRequestApi> lineItems = items
          .map((item) => CheckoutProductRequestApi().toCheckoutProduct(item))
          .toList();
      return CheckoutTransactionRequestAPI(
          lineItems: lineItems, merchantId: items[0].product.storeId);
    }
    return null;
  }

  Future<void> onQuantityChanged(double value, CartItemEntity item) async {
    item.product.inCartCount = value;
    await CartHelper().updateCartItem(item.product);
    getItems();
    notifyListeners();
  }

  Future<void> removeItem(CartItemEntity item) async {
    await CartHelper().removeFromCart(item.product);
    getItems();
    notifyListeners();
  }

  Map<FeesEntity, double> getFinalPayment() {
    Map<FeesEntity, double> paymentTotals = Map();
    // don't change the names
    FeesEntity subtotal = FeesEntity();
    subtotal.name = "Cart Subtotal";
    paymentTotals[subtotal] = subTotal;
    fees.forEach((fee) {
      paymentTotals[fee] = fee.finalAmount;
    });
    FeesEntity total = FeesEntity();
    total.name = "Total";
    paymentTotals[total] = totalPrice;

    return paymentTotals;
  }

  bool isMaximumAmountReached(num amount) {
    if (maxCashOrderAmount < totalPrice + amount) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> clearCart() async {
    if (await CartHelper().clearCart() == CartResponses.Cleared) {
      items.clear();
      await getItems();
      notifyListeners();
      return true;
    }
    return false;
  }

  /// When erorr occurred in validation

  Future<void> makeChanges() async {
    if (itemsToChange.isNotEmpty) {
      itemsToChange.forEach((item) async {
        await onQuantityChanged(item.product.inventoryCount.toDouble(), item);
      });
    }

    if (itemsToRemove.isNotEmpty) {
      itemsToRemove.forEach((item) async {
        await removeItem(item);
      });
    }
  }

  Future<void> updateNewQuantity(String packageId, num inventoryCount) async {
    print(packageId);
    items.forEach((cartItem) async {
      if (cartItem.product.Id == packageId) {
        if (inventoryCount == 0) {
          itemsToRemove.add(cartItem);
        } else {
          cartItem.product.inventoryCount = inventoryCount;
          itemsToChange.add(cartItem);
          cartItem.isChanged = true;
        }
      }
    });
  }

  Future<void> updateNewPrice(String packageId, double amount) async {
    print(packageId);
    items.forEach((cartItem) async {
      if (cartItem.product.Id == packageId) {
        cartItem.product.productAmount = amount;
        await onQuantityChanged(cartItem.quantity, cartItem);
      }
    });
  }

  updateFees(BuildContext context) async {
    // get configurations
    await getItems();
  }
}

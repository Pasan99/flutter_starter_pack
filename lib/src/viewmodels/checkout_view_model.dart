import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:food_deliver/src/api/api_constants.dart';
import 'package:food_deliver/src/api/api_requests.dart';
import 'package:food_deliver/src/api/models/request/mobile_transaction_request_api.dart';
import 'package:food_deliver/src/api/models/response/checkout_transaction_response.dart';
import 'package:food_deliver/src/api/models/response/order_response_api.dart';
import 'package:food_deliver/src/db/dao/cart_item_dao.dart';
import 'package:food_deliver/src/db/dao/contact_dao.dart';
import 'package:food_deliver/src/db/entity/cart_item_entity.dart';
import 'package:food_deliver/src/db/entity/contact_entity.dart';
import 'package:food_deliver/src/db/entity/fees_entity.dart';
import 'package:food_deliver/src/db/entity/user_entity.dart';
import 'package:food_deliver/src/utills/cart_helper.dart';
import 'package:food_deliver/src/utills/city_district_helper.dart';
import 'package:food_deliver/src/utills/language_helper.dart';
import 'package:food_deliver/src/utills/response_codes.dart';
import 'package:food_deliver/src/utills/user_auth.dart';

class CheckoutViewModel with ChangeNotifier {
  ContactEntity selectedContact;
  UserEntity currentUser;
  bool isCurrentUserSelected;
  String city;
  String district;
  Order resultOrder;
  TextEditingController noteEditor = new TextEditingController();
  Responses currentResponse;
  CheckoutTransactionResponseApi validatedOrder;

  final List<CartItemEntity> items;
  final Map<FeesEntity, double> paymentValues;

  CheckoutViewModel(this.items, this.paymentValues, this.validatedOrder) {
    getSelectedUser();
  }

  getSelectedUser() async {
    currentUser = await UserAuth().getCurrentUser();
    if (currentUser.selectedContactId != "me") {
      isCurrentUserSelected = false;
      ContactDAO dao = ContactDAO();
      ContactEntity entity = await dao.getMatchingEntry(ContactEntity(),
          where: "_id = '${currentUser.selectedContactId}'");
      if (entity != null) {
        selectedContact = entity;
      }
    } else {
      isCurrentUserSelected = true;
      selectedContact = UserEntity().toContactEntity(currentUser);
    }

    city = await CityDistrictHelper(cityId: selectedContact.cityId).getCity();
    district =
        await CityDistrictHelper(cityId: selectedContact.cityId).getDistrict();

    notifyListeners();
  }

//  Future<bool> addOrder(BuildContext context,
//      {String note, @required String paymentMethod}) async {
//    CreateOrderRequestApi createOrderRequestApi = CreateOrderRequestApi();
//    try {
//      if (isCurrentUserSelected) {
//        createOrderRequestApi.userId = currentUser.authId;
//      } else {
//        createOrderRequestApi.userId = currentUser.authId;
//        createOrderRequestApi.contactId = currentUser.selectedContactId;
//      }
//
//      createOrderRequestApi.items = List();
//      items.forEach((cartItem) {
//        createOrderRequestApi.items
//            .add(OrderItemRequestApi().toOrderItem(cartItem));
//      });
//      createOrderRequestApi.storeId = items[0].product.storeId;
//      createOrderRequestApi.transactionTotal = paymentValues.values.last;
//      createOrderRequestApi.paymentMethod = paymentMethod;
//      List<FeesEntity> fees = paymentValues.keys.toList();
//      fees.removeAt(fees.length - 1);
//      fees.removeAt(0);
//      createOrderRequestApi.fees =
//          fees.map((fee) => FeesRequestApi().toFeeRequest(fee)).toList();
//      createOrderRequestApi.note = !note.isInvalid() ? note : "";
//
//      Order result = await _createOrder(createOrderRequestApi, context);
//      resultOrder = result;
//
//      if (result != null && result.errorBody == null) {
//        result.convertedName =
//        await LanguageHelper(names: result.storeName).getName();
//        result.items.forEach((item) async {
//          item.convertedPackageName =
//          await LanguageHelper(names: item.packageName).getName();
//          item.packageItems.forEach((packItem) async {
//            packItem.product =
//            await LanguageHelper(names: packItem.productName).getName();
//          });
//        });
//        currentResponse = Responses.DATA_RETRIEVED;
//        return true;
//      }
//      if (result != null) {
//        result.errorBody.message =
//        await LanguageHelper(names: result.errorBody.messages).getName();
//        currentResponse = Responses.NO_DATA;
//      }
//      else{
//        currentResponse = Responses.NETWORK_DISCONNECTED;
//      }
//      return false;
//    }
//    catch(i){
//      print(i);
//      currentResponse = Responses.NETWORK_DISCONNECTED;
//      return false;
//    }
//  }
//
//  Future<Order> _createOrder(
//      CreateOrderRequestApi order, BuildContext context) async {
//    try {
//      APIRequests request = APIRequests();
//      Order result = await request.execute(
//          APIConstants.BASE_URL + APIConstants.API_CREATE_ORDER, context,
//          authToken: "",
//          body: jsonEncode(order.toMap(withoutUniqueIDs: false)),
//          responseClass: Order(),
//          apiMethod: ApiMethod.POST);
//
//      if (result != null && result.errorBody == null) {
//        await _saveInLocalDb(result);
//        notifyListeners();
//        return Future.value(result);
//      } else {
//        currentResponse = Responses.NETWORK_DISCONNECTED;
//        return Future.value(result);
//      }
//    } catch (e) {
//      currentResponse = Responses.NETWORK_DISCONNECTED;
//      print(e);
//      return Future.value(null);
//    }
//  }

  Future<bool> addOrder(BuildContext context,
      {String note, @required String paymentMethod}) async {
    MobileTransactionRequestApi createOrderRequestApi = MobileTransactionRequestApi();
    try {
      if (validatedOrder != null) {
        // User Details - contact Id
        if (isCurrentUserSelected) {
          createOrderRequestApi.contactId = currentUser.authId;
          createOrderRequestApi.contactName = currentUser.name;
          createOrderRequestApi.mainRoad = currentUser.mainRoad;
          createOrderRequestApi.street = currentUser.street;
          createOrderRequestApi.mobileNumber = currentUser.mobileNumber;
          createOrderRequestApi.houseNo = currentUser.houseNo;
          createOrderRequestApi.landMarks = currentUser.landMarks;
        } else {
          // send contact details
          ContactEntity selectedContact = await UserAuth().getSelectedContact();
          createOrderRequestApi.contactId = currentUser.selectedContactId;
          createOrderRequestApi.contactName = selectedContact.name;
          createOrderRequestApi.mainRoad = selectedContact.mainRoad;
          createOrderRequestApi.street = selectedContact.street;
          createOrderRequestApi.mobileNumber = selectedContact.contactNumber;
          createOrderRequestApi.houseNo = selectedContact.houseNo;
          createOrderRequestApi.landMarks = selectedContact.landmarks;
        }

        // Items
        createOrderRequestApi.lineItems = List();
        items.forEach((cartItem) {
          createOrderRequestApi.lineItems.add(LineItemRequestApi().toLineItem(
              cartItemEntity: cartItem, index: items.indexOf(cartItem)));
        });
        // Merchant
        createOrderRequestApi.merchantId = items[0].product.storeId;
        createOrderRequestApi.storeId = items[0].product.storeId;
        // Total Values
        createOrderRequestApi.transaction = TransactionRequestApi(
            discount: 0,
            subTotal: CartHelper().getSubTotal(),
            tax: CartHelper().getFeesTotal(),
            total: CartHelper().getTotal());
        createOrderRequestApi.amountCollected = CartHelper().getTotal();

        // Tax
        List<FeesEntity> fees = paymentValues.keys.toList();
        fees.removeAt(fees.length - 1);
        fees.removeAt(0);
        createOrderRequestApi.tax =
            fees.map((fee) => TaxRequestApi().toTaxRequest(fee)).toList();
        //createOrderRequestApi.note = !note.isInvalid() ? note : "";

        // Other transaction data
        createOrderRequestApi.transactionId = validatedOrder.Id;
        createOrderRequestApi.paymentMethods = List();
        createOrderRequestApi.paymentMethods.add(PaymentMethodsRequestApi(
          amount: CartHelper().getTotal(),
          method: paymentMethod
        ));

        Order result =
        await _createOrder(createOrderRequestApi, context);
        resultOrder = result;

        if (result != null && result.errorBody == null) {
//        result.convertedName =
//        await LanguageHelper(names: result.storeName).getName();
//        result.items.forEach((item) async {
//          item.convertedPackageName =
//          await LanguageHelper(names: item.packageName).getName();
//          item.packageItems.forEach((packItem) async {
//            packItem.product =
//            await LanguageHelper(names: packItem.productName).getName();
//          });
//        });
          currentResponse = Responses.DATA_RETRIEVED;
          return true;
        }
        if (result != null) {
          result.errorBody.message =
          await LanguageHelper(names: result.errorBody.messages).getName();
          currentResponse = Responses.NO_DATA;
        } else {
          currentResponse = Responses.NETWORK_DISCONNECTED;
        }
        return false;
      }
      else {
        currentResponse = Responses.NETWORK_DISCONNECTED;
        return false;
      }
    } catch (i) {
      print(i);
      currentResponse = Responses.NETWORK_DISCONNECTED;
      return false;
    }
  }

  Future<Order> _createOrder(
      MobileTransactionRequestApi order, BuildContext context) async {
    try {
      APIRequests request = APIRequests();
      Order result = await request.execute(
          APIConstants.BASE_URL_2 + APIConstants.API_COMPLETE_MOBILE_TRANSACTION, context,
          authToken: "",
          body: jsonEncode(order.toMap(withoutUniqueIDs: false)),
          responseClass: Order(),
          apiMethod: ApiMethod.POST);

      if (result != null && result.errorBody == null) {
        //await _saveInLocalDb(result);
        notifyListeners();
        return Future.value(result);
      } else {
        currentResponse = Responses.NETWORK_DISCONNECTED;
        return Future.value(result);
      }
    } catch (e) {
      currentResponse = Responses.NETWORK_DISCONNECTED;
      print(e);
      return Future.value(null);
    }
  }

//  Future<bool> _saveInLocalDb(Order response) async {
//    OrderDAO orderDAO = OrderDAO();
//    int success =
//        await orderDAO.insertData(OrderEntity().convertToOrderEntity(response));
//    if (success != null) {
//      return true;
//    }
//    return false;
//  }

  Future<bool> clearCart() async {
    items.forEach((item) async {
      await CartItemDAO()
          .deleteData(CartItemEntity(), where: "ID = '${item.ID}'");
    });
    bool isExist = await CartItemDAO()
        .isExists(CartItemEntity(), where: "ID = '${items[0].ID}'");
    if (isExist) {
      return false;
    }
    return true;
  }
}

import 'package:food_deliver/src/base/api_base_model.dart';
import 'package:food_deliver/src/db/entity/cart_item_entity.dart';
import 'package:food_deliver/src/db/entity/fees_entity.dart';
import 'package:food_deliver/src/ext/list_extension.dart';
import 'package:food_deliver/src/ext/string_extension.dart';

class MobileTransactionRequestApi extends ApiBaseModel<MobileTransactionRequestApi>{
  String transactionId;
  String merchantId;
  String transactionType = "Completed";
  List<LineItemRequestApi> lineItems;
  TransactionRequestApi transaction;
  num amountCollected;
  num balance = 0;
  String receipt = "emailed";
  List<TaxRequestApi> tax;
  String storeId;
  String contactId;
  String contactName;
  String mainRoad;
  String street;
  String mobileNumber;
  String houseNo;
  List<String> landMarks;
  List<PaymentMethodsRequestApi> paymentMethods;

  @override
  MobileTransactionRequestApi toClass(Map<String, dynamic> map) {
    if (map.containsKey('transactionId')) this.transactionId = map['transactionId'];
    if (map.containsKey('merchantId')) this.merchantId = map['merchantId'];
    if (map.containsKey('transactionType')) this.transactionType = map['transactionType'];

    if (map.containsKey('lineItems')) {
      lineItems = List();
      List<dynamic> jsonArr = map['lineItems'];
      if (!jsonArr.isInvalid()) {
        jsonArr.forEach((package) {
          lineItems.add(LineItemRequestApi().toClass(package));
        });
      }
    }

    if (map.containsKey('tax')) {
      tax = List();
      List<dynamic> jsonArr = map['tax'];
      if (!jsonArr.isInvalid()) {
        jsonArr.forEach((package) {
          tax.add(TaxRequestApi().toClass(package));
        });
      }
    }

    if (map.containsKey('transaction')) this.transaction = TransactionRequestApi().toClass(map['transaction']);
    if (map.containsKey('amountCollected')) this.amountCollected = map['amountCollected'];
    if (map.containsKey('balance')) this.balance = map['balance'];
    if (map.containsKey('storeId')) this.storeId = map['storeId'];
    if (map.containsKey('contactId')) this.contactId = map['contactId'];
    if (map.containsKey('contactName')) this.contactName = map['contactName'];
    if (map.containsKey('mainRoad')) this.mainRoad = map['mainRoad'];
    if (map.containsKey('street')) this.street = map['street'];
    if (map.containsKey('mobileNumber')) this.mobileNumber = map['mobileNumber'];
    if (map.containsKey('houseNo')) this.houseNo = map['houseNo'];
    if (map.containsKey('landMarks')) this.landMarks = map['landMarks'];
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.transactionId.isInvalid()) map['transactionId'] = this.transactionId;
    if (!this.merchantId.isInvalid()) map['merchantId'] = this.merchantId;
    if (!this.transactionType.isInvalid()) map['transactionType'] = this.transactionType;
    if (!this.receipt.isInvalid()) map['receipt'] = this.receipt;

    if (!this.lineItems.isInvalid()){
      var newProduct = lineItems.map((product)=> product.toMap()).toList();
      map['lineItems'] = newProduct;
    }
    if (!this.tax.isInvalid()){
      var newTaxes = tax.map((taxItem)=> taxItem.toMap()).toList();
      map['tax'] = newTaxes;
    }

    if (!this.paymentMethods.isInvalid()){
      var newMethods = paymentMethods.map((method)=> method.toMap()).toList();
      map['paymentMethods'] = newMethods;
    }
    if (this.transaction != null) map['transaction'] = this.transaction.toMap();
    if (this.amountCollected != null) map['amountCollected'] = this.amountCollected;
    if (this.balance != null) map['balance'] = this.balance;
    if (this.storeId != null) map['storeId'] = this.storeId;
    if (this.contactId != null) map['contactId'] = this.contactId;
    if (this.contactName != null) map['contactName'] = this.contactName;
    if (this.mainRoad != null) map['mainRoad'] = this.mainRoad;
    if (this.street != null) map['street'] = this.street;
    if (this.mobileNumber != null) map['mobileNumber'] = this.mobileNumber;
    if (this.houseNo != null) map['houseNo'] = this.houseNo;
    if (this.landMarks != null) map['landMarks'] = this.landMarks;
    return map;
  }

}

class TransactionRequestApi extends ApiBaseModel<TransactionRequestApi>{
  num subTotal;
  num tax;
  num discount;
  num total;

  TransactionRequestApi({this.subTotal, this.tax, this.discount, this.total});

  @override
  TransactionRequestApi toClass(Map<String, dynamic> map) {
    if (map.containsKey('subTotal')) this.subTotal = map['subTotal'];
    if (map.containsKey('tax')) this.tax = map['tax'];
    if (map.containsKey('discount')) this.discount = map['discount'];
    if (map.containsKey('total')) this.total = map['total'];
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (subTotal != null) map['subTotal'] = this.subTotal;
    if (tax!= null) map['tax'] = this.tax;
    if (discount != null) map['discount'] = this.discount;
    if (total != null) map['total'] = this.total;
    return map;
  }
}

class PaymentMethodsRequestApi extends ApiBaseModel<PaymentMethodsRequestApi>{
  String method;
  num amount;

  PaymentMethodsRequestApi({this.method, this.amount});

  @override
  PaymentMethodsRequestApi toClass(Map<String, dynamic> map) {
    if (map.containsKey('method')) this.method = map['method'];
    if (map.containsKey('amount')) this.amount = map['amount'];
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (method != null) map['method'] = this.method;
    if (amount!= null) map['amount'] = this.amount;
    return map;
  }
}

class LineItemRequestApi extends ApiBaseModel<LineItemRequestApi> {
  int index;
  String productId;
  String itemName;
  num quantity;
  num unitPrice;
  num discount = 0;
  num lineItemTotal;

  @override
  LineItemRequestApi toClass(Map<String, dynamic> map) {
    if (map.containsKey('index')) this.index = map['index'];
    if (map.containsKey('productId')) this.productId = map['productId'];
    if (map.containsKey('itemName')) this.itemName = map['itemName'];
    if (map.containsKey('quantity')) this.quantity = map['quantity'];
    if (map.containsKey('unitPrice')) this.unitPrice = map['unitPrice'];
    if (map.containsKey('discount')) this.discount = map['discount'];
    if (map.containsKey('lineItemTotal')) this.lineItemTotal = map['lineItemTotal'];
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (index!= null) map['index'] = this.index;
    if (productId!= null) map['productId'] = this.productId;
    if (itemName != null) map['itemName'] = this.itemName;
    if (quantity != null) map['quantity'] = this.quantity;
    if (unitPrice!= null) map['unitPrice'] = this.unitPrice;
    if (discount != null) map['discount'] = this.discount;
    if (lineItemTotal != null) map['lineItemTotal'] = this.lineItemTotal;
    return map;
  }

  LineItemRequestApi toLineItem({CartItemEntity cartItemEntity, int index}){
    LineItemRequestApi orderItem = new LineItemRequestApi();
    orderItem.index = index;
    orderItem.productId = cartItemEntity.product.Id;
    orderItem.itemName = cartItemEntity.product.productName;
    orderItem.quantity = cartItemEntity.quantity;
    orderItem.unitPrice = cartItemEntity.product.productAmount;
    orderItem.lineItemTotal = cartItemEntity.total;

    return orderItem;
  }

}

class TaxRequestApi extends ApiBaseModel<TaxRequestApi> {
  String taxId;
  String taxName;
  num taxAmount;
  String taxRate;

  @override
  TaxRequestApi toClass(Map<String, dynamic> map) {
    if (map.containsKey('taxId')) this.taxId = map['taxId'];
    if (map.containsKey('taxName')) this.taxName = map['taxName'];
    if (map.containsKey('taxAmount')) this.taxAmount = map['taxAmount'];
    if (map.containsKey('taxRate')) this.taxRate = map['taxRate'];

    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.taxId.isInvalid()) map['taxId'] = this.taxId;
    if (taxName != null) map['taxName'] = this.taxName;
    if (!this.taxRate.isInvalid()) map['taxRate'] = this.taxRate;
    if (taxAmount != null) map['taxAmount'] = this.taxAmount;
    return map;
  }

  TaxRequestApi toTaxRequest(FeesEntity feesEntity){
    TaxRequestApi feesRequestApi = new TaxRequestApi();
    feesRequestApi.taxId = feesEntity.feeID;
    feesRequestApi.taxAmount = feesEntity.amount;
    feesRequestApi.taxName = feesEntity.name;
    feesRequestApi.taxRate = feesEntity.feeRate;
    return feesRequestApi;
  }

}

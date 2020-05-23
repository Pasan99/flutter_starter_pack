import 'package:food_deliver/src/base/api_base_model.dart';
import 'package:food_deliver/src/ext/string_extension.dart';

class MobileTransactionResponseApi extends ApiBaseModel<MobileTransactionResponseApi>{
  String transactionId;
  String merchantId;
  String transactionType = "Completed";

  @override
  MobileTransactionResponseApi toClass(Map<String, dynamic> map) {
    if (map.containsKey('_id')) this.transactionId = map['_id'];
    if (map.containsKey('merchantId')) this.merchantId = map['merchantId'];
    if (map.containsKey('transactionType')) this.transactionType = map['transactionType'];
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.transactionId.isInvalid()) map['transactionId'] = this.transactionId;
    if (!this.merchantId.isInvalid()) map['merchantId'] = this.merchantId;
    if (!this.transactionType.isInvalid()) map['transactionType'] = this.transactionType;
    return map;
  }

}


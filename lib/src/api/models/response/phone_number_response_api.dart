import 'package:food_deliver/src/base/api_base_model.dart';
import 'package:food_deliver/src/ext/string_extension.dart';

class PhoneNumberResponseApi extends ApiBaseModel<PhoneNumberResponseApi>{
  String mobileNumber;
  int statusCode;
  int accountStatus;
  String Id;

  PhoneNumberResponseApi({this.mobileNumber});

  @override
  PhoneNumberResponseApi toClass(Map<String, dynamic> map) {
    if (map.containsKey('mobileNumber')) this.mobileNumber = map['mobileNumber'];
    if (map.containsKey('statusCode')) this.statusCode = map['statusCode'];
    if (map.containsKey('accountStatus')) this.accountStatus = map['accountStatus'];
    if (map.containsKey('_id')) this.Id = map['_id'];

    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.mobileNumber.isInvalid()) map['mobileNumber'] = this.mobileNumber;
    if (this.statusCode != null) map['statusCode'] = this.statusCode;
    if (this.accountStatus != null) map['accountStatus'] = this.accountStatus;
    if (this.Id != null) map['_id'] = this.Id;
    return map;
  }

}
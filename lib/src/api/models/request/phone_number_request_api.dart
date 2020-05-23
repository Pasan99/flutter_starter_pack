import 'package:food_deliver/src/base/api_base_model.dart';
import 'package:food_deliver/src/ext/string_extension.dart';

class PhoneNumberRequestApi extends ApiBaseModel<PhoneNumberRequestApi>{
  String mobileNumber;

  PhoneNumberRequestApi({this.mobileNumber});

  @override
  PhoneNumberRequestApi toClass(Map<String, dynamic> map) {
    if (map.containsKey('mobileNumber')) this.mobileNumber = map['mobileNumber'];
    if (map.containsKey('newMobileNumber')) this.mobileNumber = map['newMobileNumber'];

    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.mobileNumber.isInvalid()) map['mobileNumber'] = this.mobileNumber;
    if (!this.mobileNumber.isInvalid()) map['newMobileNumber'] = this.mobileNumber;
    return map;
  }

}
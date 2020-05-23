import 'package:food_deliver/src/base/base_model.dart';

class BlacklistUser extends BaseModel<BlacklistUser>{
  String userId;
  String reason;
  String blacklistedBy;

  @override
  BlacklistUser toClass(Map<String, dynamic> map) {
    if (map.containsKey('userId')) this.userId = map['userId'];
    if (map.containsKey('reason'))
      this.reason = map['reason'];
    if (map.containsKey('blacklistedBy')) this.blacklistedBy = map['blacklistedBy'];
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!withoutUniqueIDs) map['userId'] = this.userId;
    if (this.reason != null)
      map['reason'] = this.reason;
    if (this.blacklistedBy != null) map['blacklistedBy'] = this.blacklistedBy;
    return map;
  }

}

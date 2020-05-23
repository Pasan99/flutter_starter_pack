import 'entity/base_entity.dart';
import '../models/gps_coordinates.dart';
import 'entity/user_entity.dart';

class ViewGenerator{
  String createQuery({BaseEntity parent, BaseEntity child, String joinCondition, String groupBy}){
    String query = "SELECT ";

    String rawQuery =
        "SELECT user.Name, CONCAT( '[', GROUP_CONCAT(JSON_OBJECT('name', packages.Name, 'AMOUNT', packages.Amount)), ']' ) as Items "
        "FROM user JOIN packages "
        "ON user.Id = packages.UserId "
        "GROUP BY user.Name";
  }

  List<String> getUserUsingRawQuery(int userId){
    String user = UserEntity().runtimeType.toString();
    String gps = GpsCoordinates().runtimeType.toString();
    String rawQuery =
        "SELECT $user.Name, $user.ID, $user.authId, $user.mobileNumber, $user.nic, "
        "$user.cityId, $user.mainRoad, $user.street, $user.houseNo, $user.language, $user.landMarks, $user.ordersList, "
        "CONCAT( '[', GROUP_CONCAT(JSON_OBJECT('lat', packages.Name, 'AMOUNT', packages.Amount)), ']' ) as Items "
        "FROM $user JOIN $gps"
        "ON $user.Id = $gps.UserId "
        "GROUP BY user.Name";
  }
}
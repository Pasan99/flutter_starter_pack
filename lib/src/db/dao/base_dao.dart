import '../entity/base_entity.dart';
import '../db_controller.dart';
import 'package:food_deliver/src/ext/string_extension.dart';
import 'package:food_deliver/src/ext/list_extension.dart';
import 'package:sqflite/sqflite.dart';
abstract class BaseDAO<T> {


  ///insert data to a particular DB table and return boolean
  Future<int> insertData(BaseEntity t) async {
    int i = await (await DBController().getDB()).insert(
        t.runtimeType.toString(), t.toMap(),
        conflictAlgorithm: ConflictAlgorithm.rollback
    );
    return Future.value(i);
  }


  ///update data to a particular DB table and return boolean
  Future<bool> updateData(BaseEntity t,
      {String where, List<dynamic> whereArgs}) async {
    int i = await (await DBController().getDB()).update(
        t.runtimeType.toString(), t.toMap(withoutUniqueIDs: true),
        where: where,
        whereArgs: whereArgs,
        conflictAlgorithm: ConflictAlgorithm.rollback
    );
    return Future.value(i > 0);
  }



  ///delete data to a particular DB table and return boolean
  Future<bool> deleteData(BaseEntity t,
      {String where, List<dynamic> whereArgs}) async {
    int i = await (await DBController().getDB()).delete(
        t.runtimeType.toString(),
        where: where,
        whereArgs: whereArgs
    );
    return Future.value(i > 0);
  }


  ///delete data to a particular DB table and return boolean
  Future<bool> isExists(BaseEntity t, {String where}) async {
    int count = Sqflite.firstIntValue(await (await DBController().getDB())
        .rawQuery('SELECT COUNT(*) FROM ' +
        t.runtimeType.toString() +
        ' WHERE ' +
        where));
    return Future.value(count > 0);
  }



  ///return matching entry for given search criteria
  ///[t] set a new object of the desired DB table type here
  ///[where] where query with params to execute in sqlite DB
  Future<BaseEntity> getMatchingEntry(BaseEntity t, {String where}) async {
    List<Map<String, dynamic>> response = await (await DBController().getDB())
        .rawQuery('SELECT * FROM ' +
        t.runtimeType.toString() +
        (where.isInvalid() ? '' : ' WHERE ' + where));
    if (response.isInvalid()) {
      return Future.value(null);
    }
    return Future.value(t.toClass(response.first));
  }



  ///return list of matching entries for given search criteria
  ///[t] set a new object of the desired DB table type here
  ///[columns] column names that needs to included in the response (send null if needs to get all column data)
  ///[where] where query with params to execute in sqlite DB
  ///[whereArgs] values to be assigned to where clause parameters
  ///[limit] response entry count
  ///[offset] start index of the next result set
  Future<List<T>> getMatchingEntries(BaseEntity t,
      {List<String> columns,
        String where,
        List<dynamic> whereArgs,
        int limit,
        int offset,
        String groupBy,
        String orderBy}) async {

    List<T> entityList = List();
    List<Map<String, dynamic>> response = await (await DBController().getDB())
        .query(t.runtimeType.toString(),
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        limit: limit,
        offset: offset,
        groupBy: groupBy,
        orderBy: orderBy);
    if (response.isInvalid()) {
      print(response);
      //entityList.add(t.toClass(response.first));
      print("failed");
      return Future.value(null);
    }
    print("done");
    entityList = t.toClassArray(response);
    return Future.value(entityList);
  }



  ///return a list of entries that matches to the given raw query
  Future<List<T>> getMatchingEntriesFromQuery(BaseEntity t, String rawQuery,
      {List<dynamic> args}) async {
    List<T> entityList = List();
    List<Map<String, dynamic>> response =
    await (await DBController().getDB()).rawQuery(rawQuery, args);
    if (response.isInvalid()) {
      entityList.add(t.toClass(response.first));
      return Future.value(entityList);
    }
    entityList = t.toClassArray(response);
    return Future.value(entityList);
  }

  Future<bool> deleteFromRawQuery(BaseEntity t, String rawQuery,
      {List<dynamic> args}) async {
    List<Map<String, dynamic>> response =
    await (await DBController().getDB()).rawQuery(rawQuery, args);
    print(response);
    if (response == null || response.isEmpty) {
      return true;
    }
    return false;
  }
}

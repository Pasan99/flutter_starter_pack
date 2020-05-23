import '../../base/base_model.dart';

abstract class BaseEntity<T> extends BaseModel<T> {
  ///return the query to create the particular DB table
  String createTable();

  ///return the query to drop the particular DB table
  String dropTable();

  ///return the query to alter the particular DB table
  String alterTable();

  // BaseModel -> toMap(), toClass(), toClassArray(), listToClass(), updateObject()
}

abstract class BaseModel<T> {
  ///convert current class to a map
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false});

  ///convert given map to a class
  T toClass(Map<String, dynamic> map);

  ///convert given map to a class array
  List<T> toClassArray(List<Map<String, dynamic>> array) {
    return List();
  }

  ///convert given json array to a class
  T listToClass(List<dynamic> array) {
    return null;
  }

  ///add new attributes to the existing class object using another same type object
  BaseModel<T> updateObject(T newObject) {
    return this;
  }
}

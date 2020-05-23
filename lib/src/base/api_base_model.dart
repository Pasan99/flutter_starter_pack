import 'package:food_deliver/src/api/models/api_error_body.dart';
import 'package:food_deliver/src/base/base_model.dart';

abstract class ApiBaseModel<T> extends BaseModel{
  ApiErrorBody errorBody;
}
import 'dart:core';

import 'package:food_deliver/src/api/models/response/checkout_transaction_response.dart';
import 'package:food_deliver/src/api/models/response/configuration_response_api.dart';
import 'package:food_deliver/src/api/models/response/package_response_api.dart';
import 'package:food_deliver/src/api/models/response/product_response_api.dart';
import 'package:food_deliver/src/base/base_model.dart';
import 'package:food_deliver/src/ext/string_extension.dart';
import 'package:food_deliver/src/ext/int_extension.dart';
import 'package:food_deliver/src/ext/list_extension.dart';

class ApiErrorBody extends BaseModel<ApiErrorBody> {
  int statusCode;

//  ErrorMessage message1;
  Map<String, dynamic> messages;
  String message;
  String errorCode;

  List<ProductResponseApi> products;
  List<Fee> fees;

  @override
  ApiErrorBody toClass(Map<String, dynamic> map) {
    ApiErrorBody newError = ApiErrorBody();
    if (map.containsKey('statusCode')) newError.statusCode = map['statusCode'];

    if (map.containsKey('message')) {

      if (map['message'] is Map) {
        Map<String, dynamic> newMessage = (map['message'] as Map<String, dynamic>);
        if (newMessage.containsKey("info")){
          if (newMessage["info"] is Map) {
            newError.messages = newMessage['info'];
          }
          else if (newMessage["info"] is String) {
            newError.message = newMessage['info'];
          }
          if (newMessage.containsKey('packages')) {
            newError.products = List();
            List<dynamic> jsonArr = newMessage['packages'];
            if (!jsonArr.isInvalid()) {
              jsonArr.forEach((package) {
                print(package.toString());
                newError.products.add(ProductResponseApi().toClass(package));
              });
            }
          }
          if (newMessage.containsKey('fees')) {
            newError.fees = List();
            List<dynamic> jsonArr = newMessage['fees'];
            if (!jsonArr.isInvalid()) {
              jsonArr.forEach((fee) {
                newError.fees.add(Fee().toClass(fee));
              });
            }
          }
        }
        else{
          newError.messages = newMessage;
        }
      }
      else if (map['message'] is String) {
        newError.message = map['message'];
      }
      if (map.containsKey('errorCode')) newError.errorCode = map['errorCode'];
    }

    return newError;
  }

    @override
    Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
      Map<String, dynamic> map = Map();
      if (!this.statusCode.isInvalid()) map['statusCode'] = this.statusCode;
      if (!this.message.isInvalid()) map['message'] = this.message;
      if (!this.errorCode.isInvalid()) map['errorCode'] = this.errorCode;
      return map;
    }

    @override
    List<ApiErrorBody> toClassArray(List<Map<String, dynamic>> array) {
      return array.map((error) => ApiErrorBody().toClass(error)).toList();
    }

    @override
    ApiErrorBody listToClass(List array) {
      List<ApiErrorBody> result = array.map((error) => ApiErrorBody().toClass(error)).toList();
      result[0].message =
      "Error occured while processing the order. Please try again later.";
      return result[0];
    }
  }



//class ErrorMessage extends BaseModel<ErrorMessage>{
//  String sinhala;
//  String tamil;
//  String english;
//
//  @override
//  ErrorMessage toClass(Map<String, dynamic> map) {
//    if (map.containsKey('sinhala')) this.sinhala = map['sinhala'];
//    if (map.containsKey('tamil')) this.tamil = map['tamil'];
//    if (map.containsKey('english')) this.english = map['english'];
//    return this;
//  }
//
//  @override
//  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
//    Map<String, dynamic> map = Map();
//    if (!this.sinhala.isInvalid()) map['sinhala'] = this.sinhala;
//    if (!this.tamil.isInvalid()) map['tamil'] = this.tamil;
//    if (!this.english.isInvalid()) map['mainRoad'] = this.english;
//    return map;
//  }
//
//  bool isInvalid(){
//    if (sinhala.isInvalid() || tamil.isInvalid() || english.isInvalid()){
//      return true;
//    }
//    return false;
//  }


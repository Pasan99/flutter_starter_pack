import 'package:flutter/material.dart';
import 'package:food_deliver/src/db/dao/fees_dao.dart';
import 'package:food_deliver/src/db/entity/cart_item_entity.dart';
import 'package:food_deliver/src/db/entity/fees_entity.dart';

import 'language_helper.dart';

class CartTotalCalculator{
  List<FeesEntity> fees;
  final List<CartItemEntity> items;
  double _feesTotal = 0;

  CartTotalCalculator({@required this.items});

  _getFees() async {
    double subTotal = getSubTotal();
    FeesDAO feesDAO = FeesDAO();
    fees = await feesDAO.getMatchingEntriesFromQuery(
        FeesEntity(), "SELECT * FROM FeesEntity");
    _feesTotal = 0;
    fees.forEach((fee) async {
      if (fee.feeType == "Percentage") {
        fee.finalAmount =
        ((subTotal.toDouble() * fee.amount.toDouble()) / 100.toDouble());
        print(fee.finalAmount);
        _feesTotal += fee.finalAmount;
      } else {
        fee.finalAmount = fee.amount.toDouble();
        _feesTotal += fee.amount;
      }
      fee.name = await LanguageHelper(names: fee.names).getName();
    });
  }

  double getSubTotal(){
    if (items != null && items.length > 0) {
      double total = 0;
      for (CartItemEntity item in items) {
        total += item.total;
      }
      return total;
    }
    else{
      return 0;
    }
  }

  Future<double> getTotal() async {
    await _getFees();
    if (fees != null && items != null){
      double subTotal = getSubTotal();
      return subTotal + _feesTotal;
    }
    return 0;
  }

  double getFeeTotal(){
    return _feesTotal;
  }
}
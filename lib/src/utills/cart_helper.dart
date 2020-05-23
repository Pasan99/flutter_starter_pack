import 'package:food_deliver/src/db/dao/cart_item_dao.dart';
import 'package:food_deliver/src/db/dao/fees_dao.dart';
import 'package:food_deliver/src/db/entity/cart_item_entity.dart';
import 'package:food_deliver/src/db/entity/fees_entity.dart';
import 'package:food_deliver/src/db/entity/product_entity.dart';
import 'package:food_deliver/src/db/entity/user_entity.dart';
import 'package:food_deliver/src/utills/user_auth.dart';

import 'language_helper.dart';

enum CartResponses{
  IsAlreadyIn,
  IsDeleted,
  Idle,
  Added,
  Failed,
  Removed,
  NotExist,
  Updated,
  Cleared,
  IsEmpty,
  OutOfStock
}

class CartHelper{
  static final CartHelper _singleton = CartHelper._internal();
  List<CartItemEntity> items = List<CartItemEntity>();
  List<FeesEntity> fees = List<FeesEntity>();

  // values
  double totalPrice = 0;
  double subTotal = 0;
  int quantity = 0;
  double feesTotal = 0;

  factory CartHelper() {
    return _singleton;
  }

  CartHelper._internal(){
    getCartItems();
  }

  String getCurrentStoreId(){
    if (items == null || items.length == 0){
      return null;
    }
    return items[0].product.storeId;
  }

  /// get all cart items
  Future<List<CartItemEntity>> getCartItems() async {
    // get saved cart items
    items = await getCartItemsFromLocalDB();

    // cart have items
    if (items != null) {
      items.forEach((item){
        item.product.inCartCount = item.quantity;
      });
      localizeItemNames();
      calculateTotal();
      return Future.value(items);
    }
    // no items
    else {
      calculateTotal();
      return null;
    }
  }

  /// return all products' ids that are added to cart
  Future<List<String>> getProductIds() async{
    List<String> ids = new List();
    items = await getCartItemsFromLocalDB();
    if (items != null) {
      items.forEach((item) {
        ids.add(item.product.Id);
      });
      return ids;
    }
    return null;
  }

  Future<List<CartItemEntity>> getCartItemsFromLocalDB() async {
    CartItemDAO dao = CartItemDAO();
    List<CartItemEntity> cartItems = List<CartItemEntity>();
    cartItems = await dao.getMatchingEntries(CartItemEntity());
    return cartItems;
  }

  /// get Cart item count
  Future<int> getCartItemCount() async {
    await getCartItems();
    if (items != null) {
      return items.length;
    }
    return 0;
  }

  bool isInCart(ProductEntity product) {
    bool isIn = false;
    if (items != null) {
      items.forEach((item) {
        if (item.productId == product.Id) {
          isIn = true;
        }
      });

      if (isIn) {
        return true;
      }
    }
    return false;
  }

  /// Remove Item from cart
  Future<CartResponses> removeFromCart(ProductEntity product) async {
    bool isIn = false;
    if (items != null) {
      items.forEach((item) {
        if (item.product.Id == product.Id) {
          isIn = true;
        }
      });

      if (isIn) {
        // remove from database
        CartItemDAO cartItemDAO = new CartItemDAO();
        CartItemEntity selected = await CartItemEntity().addProduct(product);
        bool isSuccess = await cartItemDAO.deleteData(selected, where: "productId == '${product.Id}'" );

        if (isSuccess){
          await getCartItems();
          return CartResponses.Removed;
        }
      }
      else{
        return CartResponses.NotExist;
      }
    }

    return CartResponses.Failed;
  }

  /// Add to cart
  Future<CartResponses> addToCart(ProductEntity product) async {
    bool isIn = false;
    // in stock
    if (product.stock == null || product.stock >= (product.qntIncrements != null && product.qntIncrements.length > 0 ? product.qntIncrements[0] : 1)) {
      if (items != null) {
        items.forEach((item) {
          if (item.productId == product.Id) {
            isIn = true;
          }
        });
        if (isIn) {
          return CartResponses.IsAlreadyIn;
        }
      }

      // insert to database
      CartItemDAO cartItemDAO = new CartItemDAO();
      ProductEntity tempProduct = product;
      tempProduct.isAddedToCart = true;
      tempProduct.inCartCount =
      product.qntIncrements != null && product.qntIncrements.length > 0
          ? product.qntIncrements[0]
          : 1;
      CartItemEntity newItem = await CartItemEntity().addProduct(tempProduct);
      newItem.quantity = tempProduct.inCartCount;
      newItem.total = tempProduct.inCartCount * tempProduct.productAmount;
      int result = await cartItemDAO.insertData(newItem);

      if (result != null) {
        await getCartItems();
        return CartResponses.Added;
      }
      return CartResponses.Failed;
    }
    // out of stock
    return CartResponses.OutOfStock;
  }

  /// Update Cart Item data
  Future<CartResponses> updateCartItem(ProductEntity product) async {
    // in stock
    if (product.stock == null || product.stock >= product.inCartCount) {
      await getCartItems();
      CartItemEntity cartItem;
      bool isIn = false;
      if (items != null) {
        items.forEach((item) {
          print(product.Id);
          if (item.product.Id == product.Id) {
            isIn = true;
            cartItem = item;
            cartItem.quantity = product.inCartCount;
            cartItem.total =
                cartItem.product.productAmount * product.inCartCount;
          }
        });
      }
      if (items != null) {
        if (isIn) {
          // remove from database
          print("Update Item - ${cartItem.product.productName} : ${cartItem
              .total} ( X${cartItem.quantity} )");
          CartItemDAO cartItemDAO = new CartItemDAO();
          bool isSuccess = await cartItemDAO.updateData(
              cartItem, where: "productId == '${product.Id}'");

          if (isSuccess) {
            await getCartItems();
            return CartResponses.Updated;
          }
        }
        else {
          return CartResponses.NotExist;
        }
      }
      return CartResponses.Failed;
    }
    // out of stock
    return CartResponses.OutOfStock;
  }


  /// remove all items from cart
  Future<CartResponses> clearCart() async {
    if (items != null) {
      bool isSuccess = await CartItemDAO()
          .deleteFromRawQuery(CartItemEntity(), "Delete From ${CartItemEntity().runtimeType.toString()}");
      print(isSuccess);
      if (isSuccess) {
        items.clear();
        return CartResponses.Cleared;
      }
      return CartResponses.Failed;
    }

    return CartResponses.IsEmpty;
  }


  /// set names of the packages and package items to match the current user's language
  localizeItemNames(){
    items.forEach((item) async {
      UserEntity currentUser = await UserAuth().getCurrentUser();
      if (currentUser.language.toLowerCase() != "english") {
        item.product.productName =
        await LanguageHelper(names: item.product.productNames).getName();
      }
    });
  }

  bool isMaximumAmountReached(num amount){
    if (items != null && items.length > 0 && items[0].storeMaxOrderLimit != null){
      if (totalPrice + amount > items[0].storeMaxOrderLimit){
        return true;
      }
      return false;
    }
    return false;
  }

  num getMaximumTransactionLimit(){
    if (items != null && items.length > 0 && items[0] != null) {
      return items[0].product.storeMaxOrderLimit;
    }
    return 0;
  }

  /// Calculate the cart total with fees
  Future<void> calculateTotal() async {
    // if cart do have items
    if (items != null && items.length > 0) {
      subTotal = getSubTotal();
      feesTotal = getFeesTotal();
      totalPrice = subTotal + feesTotal;
    }
    // if cart doesn't have items
    else {
      setTotalsToZero();
      getFeesTotal();
    }
  }

  // depend on class attribute - items
  double getSubTotal(){
    double total = 0;
    if (items != null) {
      for (CartItemEntity item in items) {
        total += item.total;
        print("${item.product.productName} : ${item.total} ( X${item.quantity} )");
      }
    }
    return total;
  }

  double getTotal(){
    double total = 0;
    total += getFeesTotal();
    total += getSubTotal();
    return total;
  }

  double getFeesTotal(){
    double total = 0;
    if (items != null && items.length > 0){
      for(CartItemEntity item in items) {
        print("Product : ${item.product.fees}");
        if (item.product.fees != null && item.product.fees.length > 0) {
          fees = item.product.fees;
          fees.forEach((fee){
            if (fee.feeType.toLowerCase() == "%") {
              fee.finalAmount =
              ((subTotal.toDouble() * fee.amount.toDouble()) / 100.toDouble());
              print(fee.finalAmount);
              feesTotal += fee.finalAmount;
              total += fee.finalAmount;
            } else {
              fee.finalAmount = fee.amount.toDouble();
              feesTotal += fee.amount;
              total += fee.amount;
            }
          });
          break;
        }
      }
    }
    return total;
  }

  setTotalsToZero(){
    subTotal = 0;
    totalPrice = 0;
    feesTotal = 0;
  }

//  Future<double> _getFees() async {
//    FeesDAO feesDAO = FeesDAO();
//    fees = await feesDAO.getMatchingEntriesFromQuery(
//        FeesEntity(), "SELECT * FROM FeesEntity");
//    feesTotal = 0;
//    fees.forEach((fee) async {
//      if (fee.feeType == "Percentage") {
//        fee.finalAmount =
//        ((subTotal.toDouble() * fee.amount.toDouble()) / 100.toDouble());
//        print(fee.finalAmount);
//        feesTotal += fee.finalAmount;
//      } else {
//        fee.finalAmount = fee.amount.toDouble();
//        feesTotal += fee.amount;
//      }
//      fee.name = await LanguageHelper(names: fee.names).getName();
//    });
//    return feesTotal;
//  }

}
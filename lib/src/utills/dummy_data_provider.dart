import 'package:food_deliver/src/api/models/response/categoryResposeApi.dart';
import 'package:food_deliver/src/api/models/response/configuration_response_api.dart';
import 'package:food_deliver/src/api/models/response/product_response_api.dart';
import 'package:food_deliver/src/db/entity/fees_entity.dart';
import 'package:food_deliver/src/db/entity/product_entity.dart';

class DummyDataProvider {
  static List<CategoryResponseApi> setCategoryDummyData() {
    List<CategoryResponseApi> categories = List();
    categories.add(CategoryResponseApi(
        name: "Cosmetics",
        Id: "5e4cd8b6c0ea0931da2fa76a",
        imageUrl: "https://www.rossanoferretti.com/pub/media/catalog/category/RF-category-product-mobile.png"));
    categories.add(CategoryResponseApi(name: "Grocery",
        Id: "5e4cd8b6c0ea0931da2fa76a",
        imageUrl: "https://lankainformation.lk/media/k2/items/cache/ba8020c8d2fcb00e8370aa5350cda100_XL.jpg"));
    categories.add(CategoryResponseApi(name: "Beverages",
        Id: "5e4cd8b6c0ea0931da2fa76a",
        imageUrl: "https://www.coca-colacompany.com/content/dam/journey/us/en/responsible-business/sustainable-business/coca-cola-portfolio-reduced-sugar-options-card-mobile.jpeg"));
    categories.add(CategoryResponseApi(name: "Fashion",
        Id: "5e4cd8b6c0ea0931da2fa76a",
        imageUrl: "https://wp-en.oberlo.com/wp-content/uploads/2018/08/New-Products-1280x720.jpg"));
    categories.add(CategoryResponseApi(name: "Electronics",
        Id: "5e4cd8b6c0ea0931da2fa76a",
        imageUrl: "https://46ba123xc93a357lc11tqhds-wpengine.netdna-ssl.com/wp-content/uploads/2019/09/amazon-alexa-event-sept-2019.jpg"));
    categories.add(CategoryResponseApi(name: "Ladies Collections",
        Id: "5e4cd8b6c0ea0931da2fa76a",
        imageUrl: "https://jnj-content-lab.brightspotcdn.com/dims4/default/a046d32/2147483647/strip/true/crop/1174x660+150+0/resize/910x512!/quality/90/?url=https%3A%2F%2Fjnj-content-lab.brightspotcdn.com%2Fa3%2F64%2F4b691de042b2a853e1bdab4fd1e8%2Flede-neutrogena-brightboost.jpg"));
    categories.add(CategoryResponseApi(name: "Sweets",
        Id: "5e4cd8b6c0ea0931da2fa76a",
        imageUrl: "https://www.tescoplc.com/media/475550/health_hero_image-1.jpg"));
    return categories;
  }

  static List<ProductEntity> setProductsDummyData() {
    List<ProductEntity> products = List();
    ProductEntity store1 = ProductEntity();
    store1.Id = "32973437482dsafaewqrt342rfacsd954372";
    store1.productName = "Energy Drink - Orange Flavour";
    store1.productAmount = 350;
    store1.storeId = "DEFAULT_MERCHANT";
    store1.image =
    "https://www.tescoplc.com/media/475550/health_hero_image-1.jpg";
    store1.description =
    "It is a long established fact that a reader will be distracted by the readable "
        "content of a page when looking at its layout. The point of using Lorem Ipsum is "
        "that it has a more-or-less normal distribution of letters, as opposed to using "
        "'Content here, content here', making it look like readable English. ";
    store1.unitOfMeasure = UnitOfMeasure(name: "Liter", symbol: "L");
    store1.qntIncrements = [0.25, 0.5, 0.75, 1, 1.5];
    store1.fees = [
      FeesEntity().convertToFeesEntity(
          Fee(feeRate: 100, convertedName: "Delivery Fee", feeType: "flat")),
      FeesEntity().convertToFeesEntity(
          Fee(feeRate: 3.5, convertedName: "Tax", feeType: "percentage"))
    ];
    products.add(store1);

    ProductEntity store2 = ProductEntity();
    store2.Id = "329734374dsafdas82954372";
    store2.productName = "Regenerist Micro-Sculpting Cream";
    store2.productAmount = 4500;
    store2.storeId = "DEFAULT_MERCHANT";
    store2.image =
    "https://hips.hearstapps.com/vader-prod.s3.amazonaws.com/1564075908-51F27qAxshL.jpg?crop=1xw:1.00xh;center,top&resize=768:*";
    store2.description =
    "It is a long established fact that a reader will be distracted by the readable "
        "content of a page when looking at its layout. The point of using Lorem Ipsum is "
        "that it has a more-or-less normal distribution of letters, as opposed to using "
        "'Content here, content here', making it look like readable English. ";
    store2.fees = [
      FeesEntity().convertToFeesEntity(
          Fee(feeRate: 100, convertedName: "Delivery Fee", feeType: "flat")),
      FeesEntity().convertToFeesEntity(
          Fee(feeRate: 3.5, convertedName: "Tax", feeType: "percentage"))
    ];
    products.add(store2);

    ProductEntity store3 = ProductEntity();
    store3.Id = "3297343748feasdfdsa2954372";
    store3.productName =
    "Rapid Wrinkle Repair Daily Face Moisturizer with SPF 30";
    store3.productAmount = 2100;
    store3.storeId = "DEFAULT_MERCHANT";
    store3.image =
    "https://hips.hearstapps.com/vader-prod.s3.amazonaws.com/1564172769-wrinkle-creams-1564172750.jpg?crop=0.933xw:0.933xh;0.0304xw,0.0224xh&resize=768:*";
    store3.description =
    "It is a long established fact that a reader will be distracted by the readable "
        "content of a page when looking at its layout. The point of using Lorem Ipsum is "
        "that it has a more-or-less normal distribution of letters, as opposed to using "
        "'Content here, content here', making it look like readable English. ";
    store3.fees = [
      FeesEntity().convertToFeesEntity(
          Fee(feeRate: 100, convertedName: "Delivery Fee", feeType: "flat")),
      FeesEntity().convertToFeesEntity(
          Fee(feeRate: 3.5, convertedName: "Tax", feeType: "percentage"))
    ];
    products.add(store3);

    ProductEntity store4 = ProductEntity();
    store4.Id = "3297343748232rweqfcasd954372";
    store4.productName = "Multi Correxion 5 In 1 Daily Moisturizer SPF 30";
    store4.productAmount = 10;
    store4.storeId = "DEFAULT_MERCHANT";
    store4.image =
    "https://hips.hearstapps.com/vader-prod.s3.amazonaws.com/1564169663-multi-correxion-roc-1564169654.jpg?crop=1xw:1xh;center,top&resize=768:*";
    store4.description =
    "It is a long established fact that a reader will be distracted by the readable "
        "content of a page when looking at its layout. The point of using Lorem Ipsum is "
        "that it has a more-or-less normal distribution of letters, as opposed to using "
        "'Content here, content here', making it look like readable English. ";
    store4.unitOfMeasure = UnitOfMeasure(name: "Mili gram", symbol: "mg");
    store4.qntIncrements = [50, 100, 250];
    store4.fees = [
      FeesEntity().convertToFeesEntity(
          Fee(feeRate: 100, convertedName: "Delivery Fee", feeType: "flat")),
      FeesEntity().convertToFeesEntity(
          Fee(feeRate: 3.5, convertedName: "Tax", feeType: "percentage"))
    ];
    products.add(store4);
    return products;
  }

  static List<ProductEntity> setTopProductsDummyData() {
    List<ProductEntity> topProducts = List();
    ProductEntity store1 = ProductEntity();
    store1.Id = "32973437482dsafaewqrt342rfacsd954372";
    store1.productName = "Energy Drink - Orange Flavour";
    store1.productAmount = 350;
    store1.image =
    "https://www.tescoplc.com/media/475550/health_hero_image-1.jpg";
    store1.description =
    "It is a long established fact that a reader will be distracted by the readable "
        "content of a page when looking at its layout. The point of using Lorem Ipsum is "
        "that it has a more-or-less normal distribution of letters, as opposed to using "
        "'Content here, content here', making it look like readable English. ";
    store1.unitOfMeasure = UnitOfMeasure(name: "Liter", symbol: "L");
    store1.qntIncrements = [0.25, 0.5, 0.75, 1, 1.5];
    store1.fees = [
      FeesEntity().convertToFeesEntity(
          Fee(feeRate: 100, convertedName: "Delivery Fee", feeType: "flat")),
      FeesEntity().convertToFeesEntity(
          Fee(feeRate: 3.5, convertedName: "Tax", feeType: "percentage"))
    ];
    topProducts.add(store1);

    ProductEntity store2 = ProductEntity();
    store2.Id = "329734374dsafdas82954372";
    store2.productName = "Regenerist Micro-Sculpting Cream";
    store2.productAmount = 4500;
    store2.image =
    "https://hips.hearstapps.com/vader-prod.s3.amazonaws.com/1564075908-51F27qAxshL.jpg?crop=1xw:1.00xh;center,top&resize=768:*";
    store2.description =
    "It is a long established fact that a reader will be distracted by the readable "
        "content of a page when looking at its layout. The point of using Lorem Ipsum is "
        "that it has a more-or-less normal distribution of letters, as opposed to using "
        "'Content here, content here', making it look like readable English. ";
    store2.fees = [
      FeesEntity().convertToFeesEntity(
          Fee(feeRate: 100, convertedName: "Delivery Fee", feeType: "flat")),
      FeesEntity().convertToFeesEntity(
          Fee(feeRate: 3.5, convertedName: "Tax", feeType: "percentage"))
    ];
    topProducts.add(store2);

    ProductEntity store3 = ProductEntity();
    store3.Id = "3297343748feasdfdsa2954372";
    store3.productName =
    "Rapid Wrinkle Repair Daily Face Moisturizer with SPF 30";
    store3.productAmount = 2100;
    store3.image =
    "https://hips.hearstapps.com/vader-prod.s3.amazonaws.com/1564172769-wrinkle-creams-1564172750.jpg?crop=0.933xw:0.933xh;0.0304xw,0.0224xh&resize=768:*";
    store3.description =
    "It is a long established fact that a reader will be distracted by the readable "
        "content of a page when looking at its layout. The point of using Lorem Ipsum is "
        "that it has a more-or-less normal distribution of letters, as opposed to using "
        "'Content here, content here', making it look like readable English. ";
    store3.fees = [
      FeesEntity().convertToFeesEntity(
          Fee(feeRate: 100, convertedName: "Delivery Fee", feeType: "flat")),
      FeesEntity().convertToFeesEntity(
          Fee(feeRate: 3.5, convertedName: "Tax", feeType: "percentage"))
    ];
    topProducts.add(store3);

    ProductEntity store4 = ProductEntity();
    store4.Id = "3297343748232rweqfcasd954372";
    store4.productName = "Multi Correxion 5 In 1 Daily Moisturizer SPF 30";
    store4.productAmount = 10;
    store4.image =
    "https://hips.hearstapps.com/vader-prod.s3.amazonaws.com/1564169663-multi-correxion-roc-1564169654.jpg?crop=1xw:1xh;center,top&resize=768:*";
    store4.description =
    "It is a long established fact that a reader will be distracted by the readable "
        "content of a page when looking at its layout. The point of using Lorem Ipsum is "
        "that it has a more-or-less normal distribution of letters, as opposed to using "
        "'Content here, content here', making it look like readable English. ";
    store4.unitOfMeasure = UnitOfMeasure(name: "Mili gram", symbol: "mg");
    store4.qntIncrements = [50, 100, 250];
    store4.fees = [
      FeesEntity().convertToFeesEntity(
          Fee(feeRate: 100, convertedName: "Delivery Fee", feeType: "flat")),
      FeesEntity().convertToFeesEntity(
          Fee(feeRate: 3.5, convertedName: "Tax", feeType: "percentage"))
    ];
    topProducts.add(store4);

    return topProducts;
  }
}
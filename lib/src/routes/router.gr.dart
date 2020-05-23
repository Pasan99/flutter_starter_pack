// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:food_deliver/src/ui/pages/splash_screen_page.dart';
import 'package:food_deliver/src/ui/pages/registration/getting_started_page.dart';
import 'package:food_deliver/src/ui/pages/registration/language_selection_page.dart';
import 'package:food_deliver/src/ui/pages/outdated/language_Select_Page.dart';
import 'package:food_deliver/src/ui/pages/phone_number_register_page.dart';
import 'package:food_deliver/src/ui/pages/registration/otp_verification_page.dart';
import 'package:food_deliver/src/ui/pages/registration/location_map_page.dart';
import 'package:food_deliver/src/ui/pages/outdated/register_page.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:food_deliver/src/ui/pages/navigation_page.dart';
import 'package:food_deliver/src/ui/pages/outdated/location_selection_page.dart';
import 'package:food_deliver/src/viewmodels/create_user_viewmodel.dart';
import 'package:food_deliver/src/ui/pages/checkout_page.dart';
import 'package:food_deliver/src/db/entity/cart_item_entity.dart';
import 'package:food_deliver/src/db/entity/fees_entity.dart';
import 'package:food_deliver/src/api/models/response/checkout_transaction_response.dart';
import 'package:food_deliver/src/ui/pages/outdated/delivery_informationPage.dart';
import 'package:food_deliver/src/ui/pages/outdated/select_addressPage.dart';
import 'package:food_deliver/src/ui/pages/my_order_shop_details_Page.dart';
import 'package:food_deliver/src/api/models/response/order_response_api.dart';
import 'package:food_deliver/src/ui/fragments/my_orders_fragment.dart';
import 'package:food_deliver/src/ui/fragments/cart_fragment.dart';
import 'package:food_deliver/src/ui/pages/registration/manage_locations_page.dart';
import 'package:food_deliver/src/ui/pages/registration/location_register_page.dart';
import 'package:food_deliver/src/ui/pages/store_selection_page.dart';
import 'package:food_deliver/src/ui/pages/category_based_store_selection_page.dart';
import 'package:food_deliver/src/api/models/response/categoryResposeApi.dart';
import 'package:food_deliver/src/ui/pages/search/product_search_page.dart';
import 'package:food_deliver/src/ui/pages/products_selection_page.dart';
import 'package:food_deliver/src/api/models/response/store_response_api.dart';
import 'package:food_deliver/src/ui/pages/store_category_based_products_page.dart';
import 'package:food_deliver/src/ui/pages/product_details_page.dart';
import 'package:food_deliver/src/db/entity/product_entity.dart';
import 'package:food_deliver/src/ui/pages/search/global_search_page.dart';
import 'package:food_deliver/src/ui/pages/view_all_categories_page.dart';
import 'package:food_deliver/src/ui/pages/store_view_all_categories_page.dart';
import 'package:food_deliver/src/ui/pages/orde_submitted_page.dart';

abstract class Routes {
  static const splashScreenPage = '/';
  static const gettingStartedScreen = '/getting-started-screen';
  static const pickLanguagePage = '/pick-language-page';
  static const language_select_page = '/language_select_page';
  static const phoneNumberRegisterPage = '/phone-number-register-page';
  static const otpVerificationPage = '/otp-verification-page';
  static const locationMapPage = '/location-map-page';
  static const registrationPage = '/registration-page';
  static const navigationPage = '/navigation-page';
  static const locationSelectPage = '/location-select-page';
  static const checkoutPage = '/checkout-page';
  static const deliveyInfomationPage = '/delivey-infomation-page';
  static const selectAddressPage = '/select-address-page';
  static const myOrderShopDetailPage = '/my-order-shop-detail-page';
  static const myOrder_FragmentPage = '/my-order_-fragment-page';
  static const cartFragment = '/cart-fragment';
  static const manageLocationsPage = '/manage-locations-page';
  static const locationRegisterPage = '/location-register-page';
  static const storeSelectionPage = '/store-selection-page';
  static const categoryBasedStoreSelectionPage =
      '/category-based-store-selection-page';
  static const productSearchPage = '/product-search-page';
  static const productSelectionPage = '/product-selection-page';
  static const storeCategoryBasedProductsPage =
      '/store-category-based-products-page';
  static const productDetailsPage = '/product-details-page';
  static const globalSearchPage = '/global-search-page';
  static const viewAllCategoriesPage = '/view-all-categories-page';
  static const storeViewAllCategoriesPage = '/store-view-all-categories-page';
  static const orderSubmittedPage = '/order-submitted-page';
  static const all = {
    splashScreenPage,
    gettingStartedScreen,
    pickLanguagePage,
    language_select_page,
    phoneNumberRegisterPage,
    otpVerificationPage,
    locationMapPage,
    registrationPage,
    navigationPage,
    locationSelectPage,
    checkoutPage,
    deliveyInfomationPage,
    selectAddressPage,
    myOrderShopDetailPage,
    myOrder_FragmentPage,
    cartFragment,
    manageLocationsPage,
    locationRegisterPage,
    storeSelectionPage,
    categoryBasedStoreSelectionPage,
    productSearchPage,
    productSelectionPage,
    storeCategoryBasedProductsPage,
    productDetailsPage,
    globalSearchPage,
    viewAllCategoriesPage,
    storeViewAllCategoriesPage,
    orderSubmittedPage,
  };
}

class Router extends RouterBase {
  @override
  Set<String> get allRoutes => Routes.all;

  @Deprecated('call ExtendedNavigator.ofRouter<Router>() directly')
  static ExtendedNavigatorState get navigator =>
      ExtendedNavigator.ofRouter<Router>();

  @override
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.splashScreenPage:
        if (hasInvalidArgs<SplashScreenPageArguments>(args)) {
          return misTypedArgsRoute<SplashScreenPageArguments>(args);
        }
        final typedArgs =
            args as SplashScreenPageArguments ?? SplashScreenPageArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => SplashScreenPage(key: typedArgs.key),
          settings: settings,
        );
      case Routes.gettingStartedScreen:
        if (hasInvalidArgs<GettingStartedScreenArguments>(args)) {
          return misTypedArgsRoute<GettingStartedScreenArguments>(args);
        }
        final typedArgs = args as GettingStartedScreenArguments ??
            GettingStartedScreenArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => GettingStartedScreen(key: typedArgs.key),
          settings: settings,
        );
      case Routes.pickLanguagePage:
        if (hasInvalidArgs<PickLanguagePageArguments>(args)) {
          return misTypedArgsRoute<PickLanguagePageArguments>(args);
        }
        final typedArgs =
            args as PickLanguagePageArguments ?? PickLanguagePageArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => PickLanguagePage(key: typedArgs.key),
          settings: settings,
        );
      case Routes.language_select_page:
        return MaterialPageRoute<dynamic>(
          builder: (context) => Language_select_Page(),
          settings: settings,
        );
      case Routes.phoneNumberRegisterPage:
        if (hasInvalidArgs<PhoneNumberRegisterPageArguments>(args)) {
          return misTypedArgsRoute<PhoneNumberRegisterPageArguments>(args);
        }
        final typedArgs = args as PhoneNumberRegisterPageArguments ??
            PhoneNumberRegisterPageArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => PhoneNumberRegisterPage(key: typedArgs.key),
          settings: settings,
        );
      case Routes.otpVerificationPage:
        if (hasInvalidArgs<OtpVerificationPageArguments>(args,
            isRequired: true)) {
          return misTypedArgsRoute<OtpVerificationPageArguments>(args);
        }
        final typedArgs = args as OtpVerificationPageArguments;
        return MaterialPageRoute<dynamic>(
          builder: (context) => OtpVerificationPage(
              phoneNumber: typedArgs.phoneNumber, key: typedArgs.key),
          settings: settings,
        );
      case Routes.locationMapPage:
        if (hasInvalidArgs<LocationMapPageArguments>(args, isRequired: true)) {
          return misTypedArgsRoute<LocationMapPageArguments>(args);
        }
        final typedArgs = args as LocationMapPageArguments;
        return MaterialPageRoute<dynamic>(
          builder: (context) => LocationMapPage(typedArgs.registrationType,
              key: typedArgs.key,
              contactID: typedArgs.contactID,
              onContactCreated: typedArgs.onContactCreated),
          settings: settings,
        );
      case Routes.registrationPage:
        if (hasInvalidArgs<RegistrationPageArguments>(args, isRequired: true)) {
          return misTypedArgsRoute<RegistrationPageArguments>(args);
        }
        final typedArgs = args as RegistrationPageArguments;
        return MaterialPageRoute<dynamic>(
          builder: (context) => RegistrationPage(
              typedArgs.registrationType, typedArgs.selectedLocation,
              key: typedArgs.key,
              contactID: typedArgs.contactID,
              onContactCreated: typedArgs.onContactCreated),
          settings: settings,
        );
      case Routes.navigationPage:
        if (hasInvalidArgs<NavigationPageArguments>(args)) {
          return misTypedArgsRoute<NavigationPageArguments>(args);
        }
        final typedArgs =
            args as NavigationPageArguments ?? NavigationPageArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => NavigationPage(key: typedArgs.key),
          settings: settings,
        );
      case Routes.locationSelectPage:
        if (hasInvalidArgs<LocationSelectPageArguments>(args,
            isRequired: true)) {
          return misTypedArgsRoute<LocationSelectPageArguments>(args);
        }
        final typedArgs = args as LocationSelectPageArguments;
        return MaterialPageRoute<dynamic>(
          builder: (context) => LocationSelectPage(
              key: typedArgs.key,
              model: typedArgs.model,
              isDistrict: typedArgs.isDistrict),
          settings: settings,
        );
      case Routes.checkoutPage:
        if (hasInvalidArgs<CheckoutPageArguments>(args, isRequired: true)) {
          return misTypedArgsRoute<CheckoutPageArguments>(args);
        }
        final typedArgs = args as CheckoutPageArguments;
        return MaterialPageRoute<dynamic>(
          builder: (context) => CheckoutPage(
              items: typedArgs.items,
              paymentValues: typedArgs.paymentValues,
              validatedOrder: typedArgs.validatedOrder,
              onOrderPlaced: typedArgs.onOrderPlaced),
          settings: settings,
          fullscreenDialog: true,
        );
      case Routes.deliveyInfomationPage:
        return MaterialPageRoute<dynamic>(
          builder: (context) => DeliveyInfomationPage(),
          settings: settings,
        );
      case Routes.selectAddressPage:
        return MaterialPageRoute<dynamic>(
          builder: (context) => SelectAddressPage(),
          settings: settings,
        );
      case Routes.myOrderShopDetailPage:
        if (hasInvalidArgs<MyOrderShopDetailPageArguments>(args)) {
          return misTypedArgsRoute<MyOrderShopDetailPageArguments>(args);
        }
        final typedArgs = args as MyOrderShopDetailPageArguments ??
            MyOrderShopDetailPageArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => MyOrderShopDetailPage(
              key: typedArgs.key,
              order: typedArgs.order,
              language: typedArgs.language,
              onOrderStatusChanged: typedArgs.onOrderStatusChanged),
          settings: settings,
        );
      case Routes.myOrder_FragmentPage:
        if (hasInvalidArgs<MyOrderFragmentPageArguments>(args)) {
          return misTypedArgsRoute<MyOrderFragmentPageArguments>(args);
        }
        final typedArgs = args as MyOrderFragmentPageArguments ??
            MyOrderFragmentPageArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => MyOrderFragmentPage(
              key: typedArgs.key, onDirectToHome: typedArgs.onDirectToHome),
          settings: settings,
        );
      case Routes.cartFragment:
        if (hasInvalidArgs<CartFragmentArguments>(args)) {
          return misTypedArgsRoute<CartFragmentArguments>(args);
        }
        final typedArgs =
            args as CartFragmentArguments ?? CartFragmentArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => CartFragment(
              key: typedArgs.key,
              onCartItemChanged: typedArgs.onCartItemChanged,
              onOrderPlaced: typedArgs.onOrderPlaced),
          settings: settings,
        );
      case Routes.manageLocationsPage:
        if (hasInvalidArgs<ManageLocationsPageArguments>(args,
            isRequired: true)) {
          return misTypedArgsRoute<ManageLocationsPageArguments>(args);
        }
        final typedArgs = args as ManageLocationsPageArguments;
        return MaterialPageRoute<dynamic>(
          builder: (context) => ManageLocationsPage(
              key: typedArgs.key, onCartCleared: typedArgs.onCartCleared),
          settings: settings,
        );
      case Routes.locationRegisterPage:
        if (hasInvalidArgs<LocationRegisterPageArguments>(args,
            isRequired: true)) {
          return misTypedArgsRoute<LocationRegisterPageArguments>(args);
        }
        final typedArgs = args as LocationRegisterPageArguments;
        return MaterialPageRoute<dynamic>(
          builder: (context) => LocationRegisterPage(
              key: typedArgs.key,
              onContactCreated: typedArgs.onContactCreated,
              registrationType: typedArgs.registrationType,
              onSave: typedArgs.onSave,
              contactId: typedArgs.contactId),
          settings: settings,
        );
      case Routes.storeSelectionPage:
        if (hasInvalidArgs<StoreSelectionPageArguments>(args,
            isRequired: true)) {
          return misTypedArgsRoute<StoreSelectionPageArguments>(args);
        }
        final typedArgs = args as StoreSelectionPageArguments;
        return MaterialPageRoute<dynamic>(
          builder: (context) => StoreSelectionPage(
              key: typedArgs.key,
              onCartPressed: typedArgs.onCartPressed,
              onCartItemChanged: typedArgs.onCartItemChanged),
          settings: settings,
        );
      case Routes.categoryBasedStoreSelectionPage:
        if (hasInvalidArgs<CategoryBasedStoreSelectionPageArguments>(args,
            isRequired: true)) {
          return misTypedArgsRoute<CategoryBasedStoreSelectionPageArguments>(
              args);
        }
        final typedArgs = args as CategoryBasedStoreSelectionPageArguments;
        return MaterialPageRoute<dynamic>(
          builder: (context) => CategoryBasedStoreSelectionPage(
              key: typedArgs.key,
              onCartPressed: typedArgs.onCartPressed,
              onCartItemChanged: typedArgs.onCartItemChanged,
              categoriesModel: typedArgs.categoriesModel),
          settings: settings,
        );
      case Routes.productSearchPage:
        if (hasInvalidArgs<ProductSearchPageArguments>(args)) {
          return misTypedArgsRoute<ProductSearchPageArguments>(args);
        }
        final typedArgs =
            args as ProductSearchPageArguments ?? ProductSearchPageArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => ProductSearchPage(
              key: typedArgs.key,
              productSearchType: typedArgs.productSearchType,
              onCartPressed: typedArgs.onCartPressed,
              onCartItemChanged: typedArgs.onCartItemChanged,
              onRemoveFromCart: typedArgs.onRemoveFromCart,
              merchantId: typedArgs.merchantId,
              categoryId: typedArgs.categoryId),
          settings: settings,
        );
      case Routes.productSelectionPage:
        if (hasInvalidArgs<ProductSelectionPageArguments>(args,
            isRequired: true)) {
          return misTypedArgsRoute<ProductSelectionPageArguments>(args);
        }
        final typedArgs = args as ProductSelectionPageArguments;
        return MaterialPageRoute<dynamic>(
          builder: (context) => ProductSelectionPage(
              key: typedArgs.key,
              storeResponseApi: typedArgs.storeResponseApi,
              onCartPressed: typedArgs.onCartPressed),
          settings: settings,
        );
      case Routes.storeCategoryBasedProductsPage:
        if (hasInvalidArgs<StoreCategoryBasedProductsPageArguments>(args,
            isRequired: true)) {
          return misTypedArgsRoute<StoreCategoryBasedProductsPageArguments>(
              args);
        }
        final typedArgs = args as StoreCategoryBasedProductsPageArguments;
        return MaterialPageRoute<dynamic>(
          builder: (context) => StoreCategoryBasedProductsPage(
              key: typedArgs.key,
              categoriesModel: typedArgs.categoriesModel,
              onCartPressed: typedArgs.onCartPressed,
              storeResponseApi: typedArgs.storeResponseApi),
          settings: settings,
        );
      case Routes.productDetailsPage:
        if (hasInvalidArgs<ProductDetailsPageArguments>(args,
            isRequired: true)) {
          return misTypedArgsRoute<ProductDetailsPageArguments>(args);
        }
        final typedArgs = args as ProductDetailsPageArguments;
        return MaterialPageRoute<dynamic>(
          builder: (context) => ProductDetailsPage(
              key: typedArgs.key,
              productEntity: typedArgs.productEntity,
              onCartPressed: typedArgs.onCartPressed,
              onCartItemCountChanged: typedArgs.onCartItemCountChanged),
          settings: settings,
        );
      case Routes.globalSearchPage:
        if (hasInvalidArgs<GlobalSearchPageArguments>(args)) {
          return misTypedArgsRoute<GlobalSearchPageArguments>(args);
        }
        final typedArgs =
            args as GlobalSearchPageArguments ?? GlobalSearchPageArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => GlobalSearchPage(
              key: typedArgs.key, onCartPressed: typedArgs.onCartPressed),
          settings: settings,
        );
      case Routes.viewAllCategoriesPage:
        if (hasInvalidArgs<ViewAllCategoriesPageArguments>(args)) {
          return misTypedArgsRoute<ViewAllCategoriesPageArguments>(args);
        }
        final typedArgs = args as ViewAllCategoriesPageArguments ??
            ViewAllCategoriesPageArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => ViewAllCategoriesPage(
              key: typedArgs.key, onCartPressed: typedArgs.onCartPressed),
          settings: settings,
        );
      case Routes.storeViewAllCategoriesPage:
        if (hasInvalidArgs<StoreViewAllCategoriesPageArguments>(args)) {
          return misTypedArgsRoute<StoreViewAllCategoriesPageArguments>(args);
        }
        final typedArgs = args as StoreViewAllCategoriesPageArguments ??
            StoreViewAllCategoriesPageArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => StoreViewAllCategoriesPage(
              key: typedArgs.key,
              onCartPressed: typedArgs.onCartPressed,
              storeResponseApi: typedArgs.storeResponseApi),
          settings: settings,
        );
      case Routes.orderSubmittedPage:
        return MaterialPageRoute<dynamic>(
          builder: (context) => OrderSubmittedPage(),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

// *************************************************************************
// Arguments holder classes
// **************************************************************************

//SplashScreenPage arguments holder class
class SplashScreenPageArguments {
  final Key key;
  SplashScreenPageArguments({this.key});
}

//GettingStartedScreen arguments holder class
class GettingStartedScreenArguments {
  final Key key;
  GettingStartedScreenArguments({this.key});
}

//PickLanguagePage arguments holder class
class PickLanguagePageArguments {
  final Key key;
  PickLanguagePageArguments({this.key});
}

//PhoneNumberRegisterPage arguments holder class
class PhoneNumberRegisterPageArguments {
  final Key key;
  PhoneNumberRegisterPageArguments({this.key});
}

//OtpVerificationPage arguments holder class
class OtpVerificationPageArguments {
  final dynamic phoneNumber;
  final Key key;
  OtpVerificationPageArguments({@required this.phoneNumber, this.key});
}

//LocationMapPage arguments holder class
class LocationMapPageArguments {
  final int registrationType;
  final Key key;
  final String contactID;
  final Function onContactCreated;
  LocationMapPageArguments(
      {@required this.registrationType,
      this.key,
      this.contactID,
      this.onContactCreated});
}

//RegistrationPage arguments holder class
class RegistrationPageArguments {
  final int registrationType;
  final LatLng selectedLocation;
  final Key key;
  final String contactID;
  final Function onContactCreated;
  RegistrationPageArguments(
      {@required this.registrationType,
      @required this.selectedLocation,
      this.key,
      this.contactID,
      this.onContactCreated});
}

//NavigationPage arguments holder class
class NavigationPageArguments {
  final Key key;
  NavigationPageArguments({this.key});
}

//LocationSelectPage arguments holder class
class LocationSelectPageArguments {
  final Key key;
  final CreateUserViewModel model;
  final bool isDistrict;
  LocationSelectPageArguments(
      {this.key, @required this.model, this.isDistrict});
}

//CheckoutPage arguments holder class
class CheckoutPageArguments {
  final List<CartItemEntity> items;
  final Map<FeesEntity, double> paymentValues;
  final CheckoutTransactionResponseApi validatedOrder;
  final Function onOrderPlaced;
  CheckoutPageArguments(
      {@required this.items,
      @required this.paymentValues,
      @required this.validatedOrder,
      this.onOrderPlaced});
}

//MyOrderShopDetailPage arguments holder class
class MyOrderShopDetailPageArguments {
  final Key key;
  final Order order;
  final String language;
  final Function onOrderStatusChanged;
  MyOrderShopDetailPageArguments(
      {this.key, this.order, this.language, this.onOrderStatusChanged});
}

//MyOrderFragmentPage arguments holder class
class MyOrderFragmentPageArguments {
  final Key key;
  final Function onDirectToHome;
  MyOrderFragmentPageArguments({this.key, this.onDirectToHome});
}

//CartFragment arguments holder class
class CartFragmentArguments {
  final Key key;
  final Function onCartItemChanged;
  final Function onOrderPlaced;
  CartFragmentArguments({this.key, this.onCartItemChanged, this.onOrderPlaced});
}

//ManageLocationsPage arguments holder class
class ManageLocationsPageArguments {
  final Key key;
  final Function onCartCleared;
  ManageLocationsPageArguments({this.key, @required this.onCartCleared});
}

//LocationRegisterPage arguments holder class
class LocationRegisterPageArguments {
  final Key key;
  final Function onContactCreated;
  final int registrationType;
  final Function onSave;
  final dynamic contactId;
  LocationRegisterPageArguments(
      {this.key,
      this.onContactCreated,
      @required this.registrationType,
      this.onSave,
      this.contactId});
}

//StoreSelectionPage arguments holder class
class StoreSelectionPageArguments {
  final Key key;
  final Function onCartPressed;
  final Function onCartItemChanged;
  StoreSelectionPageArguments(
      {this.key,
      @required this.onCartPressed,
      @required this.onCartItemChanged});
}

//CategoryBasedStoreSelectionPage arguments holder class
class CategoryBasedStoreSelectionPageArguments {
  final Key key;
  final Function onCartPressed;
  final Function onCartItemChanged;
  final CategoryResponseApi categoriesModel;
  CategoryBasedStoreSelectionPageArguments(
      {this.key,
      @required this.onCartPressed,
      @required this.onCartItemChanged,
      @required this.categoriesModel});
}

//ProductSearchPage arguments holder class
class ProductSearchPageArguments {
  final Key key;
  final ProductSearchType productSearchType;
  final Function onCartPressed;
  final Function onCartItemChanged;
  final Function onRemoveFromCart;
  final String merchantId;
  final String categoryId;
  ProductSearchPageArguments(
      {this.key,
      this.productSearchType,
      this.onCartPressed,
      this.onCartItemChanged,
      this.onRemoveFromCart,
      this.merchantId,
      this.categoryId});
}

//ProductSelectionPage arguments holder class
class ProductSelectionPageArguments {
  final Key key;
  final StoreResponseApi storeResponseApi;
  final Function onCartPressed;
  ProductSelectionPageArguments(
      {this.key, @required this.storeResponseApi, this.onCartPressed});
}

//StoreCategoryBasedProductsPage arguments holder class
class StoreCategoryBasedProductsPageArguments {
  final Key key;
  final CategoryResponseApi categoriesModel;
  final Function onCartPressed;
  final StoreResponseApi storeResponseApi;
  StoreCategoryBasedProductsPageArguments(
      {this.key,
      @required this.categoriesModel,
      this.onCartPressed,
      @required this.storeResponseApi});
}

//ProductDetailsPage arguments holder class
class ProductDetailsPageArguments {
  final Key key;
  final ProductEntity productEntity;
  final Function onCartPressed;
  final Function onCartItemCountChanged;
  ProductDetailsPageArguments(
      {this.key,
      @required this.productEntity,
      this.onCartPressed,
      @required this.onCartItemCountChanged});
}

//GlobalSearchPage arguments holder class
class GlobalSearchPageArguments {
  final Key key;
  final Function onCartPressed;
  GlobalSearchPageArguments({this.key, this.onCartPressed});
}

//ViewAllCategoriesPage arguments holder class
class ViewAllCategoriesPageArguments {
  final Key key;
  final Function onCartPressed;
  ViewAllCategoriesPageArguments({this.key, this.onCartPressed});
}

//StoreViewAllCategoriesPage arguments holder class
class StoreViewAllCategoriesPageArguments {
  final Key key;
  final Function onCartPressed;
  final StoreResponseApi storeResponseApi;
  StoreViewAllCategoriesPageArguments(
      {this.key, this.onCartPressed, this.storeResponseApi});
}

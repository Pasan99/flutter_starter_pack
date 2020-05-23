import 'package:auto_route/auto_route_annotations.dart';
import 'package:food_deliver/src/ui/fragments/cart_fragment.dart';
import 'package:food_deliver/src/ui/fragments/my_orders_fragment.dart';
import 'package:food_deliver/src/ui/pages/category_based_store_selection_page.dart';
import 'package:food_deliver/src/ui/pages/checkout_page.dart';
import 'package:food_deliver/src/ui/pages/orde_submitted_page.dart';
import 'package:food_deliver/src/ui/pages/registration/language_selection_page.dart';
import 'package:food_deliver/src/ui/pages/registration/location_map_page.dart';
import 'package:food_deliver/src/ui/pages/registration/location_register_page.dart';
import 'package:food_deliver/src/ui/pages/registration/manage_locations_page.dart';
import 'package:food_deliver/src/ui/pages/my_order_shop_details_Page.dart';
import 'package:food_deliver/src/ui/pages/navigation_page.dart';
import 'package:food_deliver/src/ui/pages/registration/otp_verification_page.dart';
import 'package:food_deliver/src/ui/pages/outdated/delivery_informationPage.dart';
import 'package:food_deliver/src/ui/pages/outdated/language_Select_Page.dart';
import 'package:food_deliver/src/ui/pages/outdated/location_selection_page.dart';
import 'package:food_deliver/src/ui/pages/outdated/register_page.dart';
import 'package:food_deliver/src/ui/pages/outdated/select_addressPage.dart';
import 'package:food_deliver/src/ui/pages/phone_number_register_page.dart';
import 'package:food_deliver/src/ui/pages/product_details_page.dart';
import 'package:food_deliver/src/ui/pages/products_selection_page.dart';
import 'package:food_deliver/src/ui/pages/registration/getting_started_page.dart';
import 'package:food_deliver/src/ui/pages/search/global_search_page.dart';
import 'package:food_deliver/src/ui/pages/search/product_search_page.dart';
import 'package:food_deliver/src/ui/pages/splash_screen_page.dart';
import 'package:food_deliver/src/ui/pages/store_category_based_products_page.dart';
import 'package:food_deliver/src/ui/pages/store_selection_page.dart';
import 'package:food_deliver/src/ui/pages/store_view_all_categories_page.dart';
import 'package:food_deliver/src/ui/pages/view_all_categories_page.dart';

@MaterialAutoRouter()
class $Router {
  @initial
  SplashScreenPage splashScreenPage;
  GettingStartedScreen gettingStartedScreen;
  PickLanguagePage pickLanguagePage;
  Language_select_Page language_select_page;
  PhoneNumberRegisterPage phoneNumberRegisterPage;
  OtpVerificationPage otpVerificationPage;
  LocationMapPage locationMapPage;
  RegistrationPage registrationPage;
  NavigationPage navigationPage;
  LocationSelectPage locationSelectPage;
//  PackageSelectionPage packageSelectionPage;
  @MaterialRoute(fullscreenDialog: true)
//  PackageDetailsPage packageDetailsPage;
  CheckoutPage checkoutPage;
  DeliveyInfomationPage deliveyInfomationPage;
  SelectAddressPage selectAddressPage;
  MyOrderShopDetailPage myOrderShopDetailPage;
  MyOrderFragmentPage myOrder_FragmentPage;
  CartFragment cartFragment;
  ManageLocationsPage manageLocationsPage;
  LocationRegisterPage locationRegisterPage;
  StoreSelectionPage storeSelectionPage;
  CategoryBasedStoreSelectionPage categoryBasedStoreSelectionPage;
  ProductSearchPage productSearchPage;
  ProductSelectionPage productSelectionPage;
  StoreCategoryBasedProductsPage storeCategoryBasedProductsPage;
  ProductDetailsPage productDetailsPage;
  GlobalSearchPage globalSearchPage;
  ViewAllCategoriesPage viewAllCategoriesPage;
  StoreViewAllCategoriesPage storeViewAllCategoriesPage;
  OrderSubmittedPage orderSubmittedPage;
}

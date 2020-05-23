class APIConstants {
  //API request urls
  static final String BASE_URL = 'https://api.myfairspace.com';
//    static final String BASE_URL = 'http://18.209.80.184:9002';
  static final String BASE_URL_2 = 'http://13.234.49.204:9002';
  static final String BASE_URL_P = 'https://api.myfairspace.com';
  static final String HANDSHAKE_URL = '/handshake';

  //OTP related API
//  static final String API_GET_OTP = '/users/';
//  static final String API_PUT_VERIFY_OTP = '/users/verify/';

  static final String API_VISITOR = '/auth/visitor';

  // Search API
  static final String API_SEARCH = '/search';
  static final String API_STORE_SEARCH= '/store_search';
  static final String API_IN_STORE= '/in_store_search';
  static final String API_CATEGORY= '/in_category_search';

  // Categories api
  static final String API_GET_CATEGORIES = '/categories';
  static final String API_GET_MASTER_CATEGORIES = '/mastercategories/';

  // Home
  static final String API_GET_HOME_PAGE= '/posters/home';

  // Products api
  static final String API_GET_PRODUCTS = '/products';
  static final String API_GET_TOP_PRODUCTS = '/products/sells/frequences';
  static final String API_GET_STORES_BY_CATEGORY = '/stores/byMasterCategory/';
  static final String API_GET_STORE_CATEGORIES_BY_CATEGORY = '/categories/views/';

  //District API
  static final String API_GET_DISTRICT = '/districts';

  //Configuration API
  static final String API_GET_CONFIG = '/configurations';

  // OTP
  static final String API_OTP_VERIFICATION = '/users/verify';

  //Contact API
  static final String API_POST_CONTACTS = '/contacts';

  //Order API
  static final String API_GET_ORDERS = '/orders/';// '/orders/{userID}
  static final String API_CREATE_ORDER = '/orders' ;
  static final String API_VALIDATE_ORDER = '/orders/validateOrder' ;
  static final String API_CANCEL_ORDER = '/orders/cancelOrder' ;
  static final String API_CHECKOUT_TRANSACTION = '/transactions/checkoutTransaction/' ;
  static final String API_COMPLETE_MOBILE_TRANSACTION = '/transactions/completeMobileTransaction/' ;

  static final int SUCCESS_CODE = 200;
  static final int CREATED_CODE = 201;

  //Group related urls
  static const API_CREATE_USER = '/users';
  static const API_GET_STORES_BY_CITY = '/stores/byCity';
  static const API_OTP = '/users/';
}

class HttpRequestParameters {
  //OTP related parameters
  static final String OTP_REQUEST_URL_PARAM = '1'; //request otp
  static final String OTP_CHANGE_URL_PARAM = '2'; //change otp
}

class HttpConstants {
  static const HTTP_CONSTANTS_DEF_TIMEOUT = 5; //in seconds
}

class HttpAPIHeaderConstants {
  static const HTTP_API_HEAD_CONSTANTS_CONTENT = 'content-type';
  static const HTTP_API_HEAD_CONSTANTS_AUTH = 'Authorization';
  static const HTTP_API_HEAD_CONSTANTS_AUTH_BEARER = 'Bearer ';
  static const HTTP_API_HEAD_CONSTANTS_CONTENT_JSON = 'application/json';
}

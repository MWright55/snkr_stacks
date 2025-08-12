//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:googleapis/calendar/v3.dart';
//import 'getToken.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/colors.dart';

///Strip API Connect Account Key
const String STRIPE_CONNECT = 'acct_1RNjYy1444PDM8xA';

///User Logo to be used on:
/// Login page
/// Registration Page
/// Main Feed
/// User Page

const String LOGO = './assets/images/ss_black.png';
const String HOLDER = './assets/images/holder.png';
const String HOLDERB = './assets/images/ss_black.png';
const String HOLDERC = './assets/images/ScreenHolder.jpg';
const String APPLE_BUTTON = './assets/images/appleButton.png';
const String ANDROID_BUTTON = './assets/images/googleButton.png';
const String PHONE_MODEL = './assets/images/home-img.png';

///Firebase Credentials
///Information gathered from Firebase Console
///***VERY IMPORTANT*** Manually update in main.dart

const String FB_API_KEY = 'AIzaSyClSNDSVQrcNUlQ9HUB0PqLTfhybE3fUs0';
const String FB_DB_URL = 'https://snkrstacks-default-rtdb.firebaseio.com/';
const String FB_PROJECT_ID = 'snkrstacks';
const String FB_APP_ID = '1:113140806715:android:8e8eb128be92c1f149d81e';

///User Accent Color
///The accent color is used in the app for the tertiary color set in main.dart.

///Stripe Secret Token -> Moved
///Stripe Public Token -> Moved

///Tax Percent
const double TAXRATE = 0.06;

///Shipping Rate
const double SHIPPING = 14.95;

///Firebase Url - Orders
const String ORDERS_URL = 'https://snkrstacks-default-rtdb.firebaseio.com/orders.json';

///Firebase Url - Products
const String PRODUCTS_URL = 'https://snkrstacks-default-rtdb.firebaseio.com/products.json';

///Firebase Url - Purchased
const String PURCHASED_URL = 'https://snkrstacks-default-rtdb.firebaseio.com/purchased.json';

///Firebase Url - Archived
const String ARCHIVED_URL = 'https://snkrstacks-default-rtdb.firebaseio.com/reejected.json';

///Firebase Url - Admin
const String ADMIN_URL = 'https://snkrstacks-default-rtdb.firebaseio.com/admins.json';

///Firebase Url - Delete Product
///***VERY IMPORTANT*** Manually update in products_providers.dart and shippments_provider.dart

///Firebase Url - Update Product
///***VERY IMPORTANT*** Manually update in products_providers.dart and shippments_provider.dart

///DataBase Item Limit
const int DB_LIMIT = 1000;

///Google Search API Key
const String PLACE_API_KEY = "AIzaSyBqzGTO7IkDLwATDy-7AL0u770Iq0_dR2I";

///Google Search URL
const String PLACE_URL = "https://maps.googleapis.com/maps/api/place/autocomplete/json";

///Business Name
const String BIZ_KEY = "biz_abc123";

///List for Edit Product Screen

const List<String> STATUS_LIST = ['New', 'Like-New', 'Used', 'Beater', 'Other'];

final List<String> TYPE_LIST = ['Apparel', 'Accessories', 'Footwear', 'Other'];

final List<String> SIZE_LIST = [
  'X-Small',
  'Small',
  'Medium',
  'Large',
  'X-Large',
  'XX-Large',
  'XXX-Large',
  '-----',
  'M 5   / W 6.5',
  'M 5.5 / W 7',
  'M 6   / W 7.5',
  'M 6.5 / W 8',
  'M 7   / W 8.5',
  'M 7.5 / W 9',
  'M 8   / W 9.5',
  'M 8.5 / W 10',
  'M 9   / W 10.5',
  'M 9.5 / W 11',
  'M 10   / W 11.5',
  'M 10.5 / W 12',
  'M 11   / W 12.5',
  'M 11.5 / W 13',
  'M 12   / W 13.5',
  'M 12.5 / W 14',
  'M 13   / W 14.5',
  'M 14',
  'M 15',
  '-----',
  'Other',
  'Not Applicable',
];

class ShopifyConfig {
  static const storeUrl = "https://snkrstacks.myshopify.com";
  static const discountCode = "SNKRSTACKS"; // change easily
}

///All Characters for Key
const String ALL_CHARS = 'AaBbCcDdlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1EeFfGgHhIiJjKkL234567890';

///FAQ Page
///

const String LINE_END = 'Thank You For Your Business';

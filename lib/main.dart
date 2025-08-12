import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snkr_stacks/screens/authenticate/vndy_forgot.dart';
import 'package:snkr_stacks/screens/authenticate/vndy_login.dart';
import 'package:snkr_stacks/screens/authenticate/vndy_signup.dart';
import 'package:snkr_stacks/screens/delete_account_screen.dart';
import 'package:snkr_stacks/screens/edit_product_screen.dart';
import 'package:snkr_stacks/screens/faq_screen.dart';
import 'package:snkr_stacks/screens/no_internet.dart';
import 'package:snkr_stacks/screens/product_checkout_screen.dart';
import 'package:snkr_stacks/screens/purchased_products_screen.dart';
import 'package:snkr_stacks/screens/review_purchase_screen.dart';
import 'package:snkr_stacks/screens/search_products_screen.dart';
import 'package:snkr_stacks/wrapper/wrapper.dart';
import "package:provider/provider.dart";
import 'package:snkr_stacks/services/auth.dart';
import 'package:snkr_stacks/wrapper/wrapper.dart';
import 'package:snkr_stacks/wrapper/wrapper.dart';
import 'firebase_options.dart';
import 'home/home.dart';
import 'home/homeUser.dart';
import 'models/user.dart';
import 'package:snkr_stacks/screens/product_detail_screen.dart';
import 'package:snkr_stacks/providers/products_provider.dart';
import 'package:snkr_stacks/providers/shippments_provider.dart';
import 'package:snkr_stacks/providers/orders.dart';
import 'package:snkr_stacks/providers/connectivity.dart';
import 'package:snkr_stacks/screens/user_products_screen.dart';
import 'package:snkr_stacks/screens/shopify_checkout_screen.dart';
import 'package:snkr_stacks/screens/vndy_feed.dart';
import 'package:snkr_stacks/screens/profile_screen.dart';
import 'package:snkr_stacks/providers/resources.dart' as Resources;
import 'services/shopify_service.dart';

/// WBefOH1lDPOdzRCxXoxz9IFjTS73
///snkrStacks Admin Token API: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
///snkrStacks storefront token API:1619ac2fe5c1000a0769bf6c601da6e2

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  print('📦 Firebase apps: ${Firebase.apps}');
  print('🌐 Firebase DB URL: ${FirebaseDatabase.instance.databaseURL}');

  await dotenv.load(fileName: "assets/.env");
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  ///Update for user in .env
  //Stripe.publishableKey = 'pk_test_51IN2IzCOjsikW1onkwL3obNwntKNNuXe7YbIaEFRCd1Pf2xytb1zSK284sOsyST18WeEnj63QzwIFuWnaQD396US004mW2vVqP';

  Stripe.publishableKey = dotenv.env['STRIPE_PUB']!;

  Stripe.merchantIdentifier = 'VNDY Test Application';
  await Stripe.instance.applySettings();

  runApp(MyApp());
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}

// final shopifyService = ShopifyService(
//   storeUrl: 'https://snkrstacks.myshopify.com/',
//   accessToken: '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',
//   storefrontToken: '1619ac2fe5c1000a0769bf6c601da6e2', // Replace with real token
// );

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => Shippments()),
        ChangeNotifierProvider(create: (_) => Orders()),
        ChangeNotifierProvider(create: (_) => Products()),
        ChangeNotifierProvider(create: (_) => User(uid: '')),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
      ],

      child: MaterialApp(
        scrollBehavior: MyCustomScrollBehavior(),
        title: 'VNDY',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: GoogleFonts.bebasNeue().fontFamily,
          colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: Colors.black,
            onPrimary: Colors.white,
            secondary: Colors.white,
            onSecondary: Colors.black,
            error: Colors.red,
            onError: Colors.white,
            surface: Colors.white,
            onSurface: Colors.black,
            tertiary: Colors.deepOrange,
          ),
        ),

        debugShowCheckedModeBanner: false,

        //* Login Options **//
        home: Wrapper(),
        // home: Scaffold(
        //   appBar: AppBar(title: Text('Dev Sync Test')),
        //   body: Center(child: Text('Tap FAB to sync Shopify → Firestore')),
        //   floatingActionButton: FloatingActionButton(
        //     child: Icon(Icons.sync),
        //     onPressed: () async {
        //       print('🟡 Starting Shopify → Firestore sync...');
        //       final products = await shopifyService.fetchProducts();
        //       await shopifyService.pushProductsToFirebase(products);
        //       print('✅ Sync complete!');
        //     },
        //   ),
        // ),

        //home: VndyLogin(),
        //home: Home(),
        //home: HomeUser(),
        //* Login Options **//
        routes: {
          VndyLogin.id: (context) => VndyLogin(),
          VndySignup.id: (context) => VndySignup(),
          VndyForgot.id: (context) => VndyForgot(),
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
          UserProductsScreen.routeName: (context) => UserProductsScreen(),
          //EditProductScreen.routeName: (context) => EditProductScreen(),
          //EditProductScreenOG.routeName: (context) => EditProductScreenOG(),
          //VndyPostImageScreen.routeName: (context) => VndyPostImageScreen(),
          //ProductCheckoutScreen.routeName: (context) => ProductCheckoutScreen(),
          //PurchasedProductsScreen.routeName: (context) => PurchasedProductsScreen(),
          SearchProductsScreen.routeName: (context) => SearchProductsScreen(),
          VndyFeed.routeName: (context) => VndyFeed(),
          //ReviewPurchaseScreen.routeName: (context) => ReviewPurchaseScreen(),
          ProfileScreen.routeName: (context) => ProfileScreen(),
          FAQScreen.routeName: (context) => FAQScreen(),
          NoInternetScreen.routeName: (context) => NoInternetScreen(),
          DeleteAccountScreen.routeName: (context) => DeleteAccountScreen(),
        },
      ),
    );
  }
}

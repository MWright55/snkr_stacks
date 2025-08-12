// import 'package:badges/badges.dart' as Badge;
// import 'package:snkr_stacks/providers/resources.dart' as RESOURCES;
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:snkr_stacks/screens/profile_screen.dart';
// import 'package:snkr_stacks/screens/purchased_products_screen.dart';
// import 'package:snkr_stacks/screens/search_products_screen.dart';
// import 'package:snkr_stacks/screens/user_products_screen.dart';
// import 'package:snkr_stacks/screens/vndy_feed.dart';
// import '../providers/products_provider.dart';
// import '../providers/shippments_provider.dart';
// import 'dimensions.dart';
//
// class SuperBody extends StatefulWidget {
//   @override
//   _HomeState createState() => _HomeState();
// }
//
// class _HomeState extends State<SuperBody> {
//   int _currentIndex = 0;
//   late ScrollController _scrollController;
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController()
//       ..addListener(() {
//         setState(() {});
//       });
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose(); // dispose the controller
//     super.dispose();
//   }
//
//   // This function is triggered when the user presses the back-to-top button
//   void _scrollToTop() {
//     _scrollController.animateTo(0, duration: Duration(milliseconds: 2500), curve: Curves.ease);
//   }
//
//   final List<Widget> _children = [VndyFeed(), SearchProductsScreen(), UserProductsScreen(), PurchasedProductsScreen(), ProfileScreen()];
//
//   @override
//   Widget build(BuildContext context) {
//     final postedData = Provider.of<Products>(context);
//     final productsData = Provider.of<Shippments>(context);
//     final currentWidth = MediaQuery.of(context).size.width;
//     final productsDataFontSize = (productsData.items.length - 1) * 3.0;
//
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         if (constraints.maxWidth < mobileWidth) {
//           //--mobile--
//           return Scaffold(
//             // body: ResponsiveLayout(
//             //   mobileBody: MyMobileBody(),
//             //   tabletBody: MyTabletBody(),
//             //   desktopBody: MyDesktopBody(),
//             // ),
//             body: _children[_currentIndex],
//             bottomNavigationBar: BottomNavigationBar(
//               currentIndex: _currentIndex,
//               type: BottomNavigationBarType.fixed,
//               backgroundColor: Colors.white,
//               //selectedItemColor: Colors.black87,
//               selectedItemColor: Theme.of(context).colorScheme.tertiary,
//               unselectedItemColor: Colors.grey,
//               items: [
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.home_outlined, size: 27.5),
//                   activeIcon: GestureDetector(
//                     onDoubleTap: () {
//                       print(productsData.items.length);
//                     },
//                     child: Icon(Icons.home, size: 30.5),
//                   ),
//                   label: (''),
//                 ),
//                 BottomNavigationBarItem(icon: Icon(Icons.search_outlined, size: 27.5), activeIcon: Icon(Icons.search, size: 30.5), label: ('')),
//                 BottomNavigationBarItem(
//                   icon: Badge.Badge(
//                     badgeContent: Text('${postedData.items.length}', style: const TextStyle(color: Colors.white)),
//                     position: Badge.BadgePosition.topEnd(),
//                     showBadge: postedData.items.length > 0 ? true : false,
//                     badgeAnimation: Badge.BadgeAnimation.fade(animationDuration: Duration(milliseconds: 200)),
//
//                     ///Accent Color
//                     badgeStyle: Badge.BadgeStyle(badgeColor: Theme.of(context).colorScheme.tertiary),
//                     child: Icon(Icons.shopping_basket_outlined, size: 27.5),
//                   ),
//                   activeIcon: Badge.Badge(
//                     badgeContent: Text('${postedData.items.length}', style: const TextStyle(color: Colors.white)),
//                     position: Badge.BadgePosition.topEnd(),
//                     showBadge: postedData.items.length > 0 ? true : false,
//                     badgeAnimation: Badge.BadgeAnimation.fade(animationDuration: Duration(milliseconds: 200)),
//
//                     ///Accent Color
//                     badgeStyle: Badge.BadgeStyle(badgeColor: Theme.of(context).colorScheme.tertiary),
//                     child: Icon(Icons.shopping_basket_outlined, size: 30.5),
//                   ),
//                   label: (''),
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Badge.Badge(
//                     badgeContent: Text('${productsData.items.length}', style: const TextStyle(color: Colors.white)),
//                     position: Badge.BadgePosition.topEnd(),
//                     showBadge: productsData.items.length > 0 ? true : false,
//                     badgeAnimation: Badge.BadgeAnimation.fade(animationDuration: Duration(milliseconds: 200)),
//
//                     ///Accent Color
//                     badgeStyle: Badge.BadgeStyle(badgeColor: Theme.of(context).colorScheme.tertiary),
//                     child: Icon(Icons.local_shipping_outlined, size: 27.5),
//                   ),
//                   activeIcon: Badge.Badge(
//                     badgeContent: Text('${productsData.items.length}', style: const TextStyle(color: Colors.white)),
//                     position: Badge.BadgePosition.topEnd(),
//                     showBadge: productsData.items.length > 0 ? true : false,
//                     badgeAnimation: Badge.BadgeAnimation.fade(animationDuration: Duration(milliseconds: 200)),
//
//                     ///Accent Color
//                     badgeStyle: Badge.BadgeStyle(badgeColor: Theme.of(context).colorScheme.tertiary),
//                     child: Icon(Icons.local_shipping_outlined, size: 30.5),
//                   ),
//                   label: (''),
//                 ),
//                 BottomNavigationBarItem(icon: Icon(Icons.person_outline_sharp, size: 27.5), activeIcon: Icon(Icons.person_sharp, size: 30.5), label: ('')),
//               ],
//               onTap: (index) {
//                 setState(() {
//                   _currentIndex = index;
//                 });
//               },
//             ),
//           );
//         } else if (constraints.maxWidth < tabletWidth) {
//           //--tablet--
//           return Scaffold(
//             // body: ResponsiveLayout(
//             //   mobileBody: MyMobileBody(),
//             //   tabletBody: MyTabletBody(),
//             //   desktopBody: MyDesktopBody(),
//             // ),
//             //body: _children[_currentIndex]);
//             body: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 NavigationRail(
//                   leading: SizedBox(height: 50),
//                   elevation: 5,
//                   minWidth: 80,
//                   selectedIndex: _currentIndex,
//                   onDestinationSelected: (int index) {
//                     setState(() {
//                       _currentIndex = index;
//                     });
//                   },
//                   labelType: NavigationRailLabelType.none,
//                   // unselectedLabelTextStyle: TextStyle(color: Colors.grey, fontSize: 12),
//                   // selectedLabelTextStyle: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontSize: 15),
//                   destinations: [
//                     NavigationRailDestination(
//                       icon: Icon(Icons.home_outlined, color: Colors.grey, size: 27.5),
//                       selectedIcon: GestureDetector(
//                         onDoubleTap: () {
//                           print(productsData.items.length);
//                         },
//                         child: Icon(Icons.home, color: Theme.of(context).colorScheme.tertiary, size: 30.5),
//                       ),
//                       label: Text(''),
//                       padding: EdgeInsets.only(bottom: 16.0),
//                     ),
//                     NavigationRailDestination(
//                       icon: Icon(Icons.search_outlined, color: Colors.grey, size: 27.5),
//                       selectedIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.tertiary, size: 30.5),
//                       label: Text(''),
//                       padding: EdgeInsets.only(bottom: 16.0),
//                     ),
//                     NavigationRailDestination(
//                       icon: Badge.Badge(
//                         badgeContent: Text('${postedData.items.length}', style: const TextStyle(color: Colors.white)),
//                         position: Badge.BadgePosition.topEnd(),
//                         showBadge: postedData.items.length > 0 ? true : false,
//                         badgeAnimation: Badge.BadgeAnimation.fade(animationDuration: Duration(milliseconds: 200)),
//
//                         ///Accent Color
//                         badgeStyle: Badge.BadgeStyle(badgeColor: Theme.of(context).colorScheme.tertiary),
//                         child: Icon(Icons.shopping_basket_outlined, color: Colors.grey, size: 27.5),
//                       ),
//                       selectedIcon: Badge.Badge(
//                         badgeContent: Text('${postedData.items.length}', style: const TextStyle(color: Colors.white)),
//                         position: Badge.BadgePosition.topEnd(),
//                         showBadge: postedData.items.length > 0 ? true : false,
//                         badgeAnimation: Badge.BadgeAnimation.fade(animationDuration: Duration(milliseconds: 200)),
//
//                         ///Accent Color
//                         badgeStyle: Badge.BadgeStyle(badgeColor: Theme.of(context).colorScheme.tertiary),
//                         child: Icon(Icons.shopping_basket_outlined, color: Theme.of(context).colorScheme.tertiary, size: 30.5),
//                       ),
//                       label: Text(''),
//                       padding: EdgeInsets.only(bottom: 16.0),
//                     ),
//                     NavigationRailDestination(
//                       icon: Badge.Badge(
//                         badgeContent: Text('${productsData.items.length}', style: const TextStyle(color: Colors.white)),
//                         position: Badge.BadgePosition.topEnd(),
//                         showBadge: productsData.items.length > 0 ? true : false,
//                         badgeAnimation: Badge.BadgeAnimation.fade(animationDuration: Duration(milliseconds: 200)),
//
//                         ///Accent Color
//                         badgeStyle: Badge.BadgeStyle(badgeColor: Theme.of(context).colorScheme.tertiary),
//                         child: Icon(Icons.local_shipping_outlined, color: Colors.grey, size: 27.5),
//                       ),
//                       selectedIcon: Badge.Badge(
//                         badgeContent: Text('${productsData.items.length}', style: const TextStyle(color: Colors.white)),
//                         position: Badge.BadgePosition.topEnd(),
//                         showBadge: productsData.items.length > 0 ? true : false,
//                         badgeAnimation: Badge.BadgeAnimation.fade(animationDuration: Duration(milliseconds: 200)),
//
//                         ///Accent Color
//                         badgeStyle: Badge.BadgeStyle(badgeColor: Theme.of(context).colorScheme.tertiary),
//                         child: Icon(Icons.local_shipping_outlined, color: Theme.of(context).colorScheme.tertiary, size: 30.5),
//                       ),
//                       label: Text(''),
//                       padding: EdgeInsets.only(bottom: 16.0),
//                     ),
//                     NavigationRailDestination(
//                       icon: Icon(Icons.person_outline_sharp, color: Colors.grey, size: 27.5),
//                       selectedIcon: Icon(Icons.person_sharp, color: Theme.of(context).colorScheme.tertiary, size: 30.5),
//                       label: Text(''),
//                       padding: EdgeInsets.only(bottom: 16.0),
//                     ),
//                   ],
//                 ),
//                 VerticalDivider(thickness: 1, width: 1, color: Colors.white10),
//                 // This is the main content.
//                 Expanded(
//                   flex: 5,
//                   child: Scaffold(
//                     body: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 100),
//                       child: Align(
//                         alignment: Alignment.topCenter,
//                         child: Container(alignment: Alignment.center, width: 500, child: _children[_currentIndex]),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         } else {
//           //--desktop--
//           return Scaffold(
//             // body: ResponsiveLayout(
//             //   mobileBody: MyMobileBody(),
//             //   tabletBody: MyTabletBody(),
//             //   desktopBody: MyDesktopBody(),
//             // ),
//             //body: _children[_currentIndex]);
//             body: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 NavigationRail(
//                   extended: true,
//                   leading: SizedBox(height: 50),
//                   elevation: 5,
//                   minWidth: 80,
//                   selectedIndex: _currentIndex,
//                   onDestinationSelected: (int index) {
//                     setState(() {
//                       _currentIndex = index;
//                     });
//                   },
//                   labelType: NavigationRailLabelType.none,
//                   unselectedLabelTextStyle: TextStyle(color: Colors.grey, fontSize: 12),
//                   selectedLabelTextStyle: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontSize: 15),
//                   destinations: [
//                     NavigationRailDestination(
//                       icon: Icon(Icons.home_outlined, color: Colors.grey, size: 27.5),
//                       selectedIcon: GestureDetector(
//                         onDoubleTap: () {
//                           print(productsData.items.length);
//                         },
//                         child: Icon(Icons.home, color: Theme.of(context).colorScheme.tertiary, size: 30.5),
//                       ),
//                       label: Text('Feed'),
//                       padding: EdgeInsets.only(bottom: 16.0),
//                     ),
//                     NavigationRailDestination(
//                       icon: Icon(Icons.search_outlined, color: Colors.grey, size: 27.5),
//                       selectedIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.tertiary, size: 30.5),
//                       label: Text('Search'),
//                       padding: EdgeInsets.only(bottom: 16.0),
//                     ),
//                     NavigationRailDestination(
//                       icon: Badge.Badge(
//                         badgeContent: Text('${postedData.items.length}', style: const TextStyle(color: Colors.white)),
//                         position: Badge.BadgePosition.topEnd(),
//                         showBadge: postedData.items.length > 0 ? true : false,
//                         badgeAnimation: Badge.BadgeAnimation.fade(animationDuration: Duration(milliseconds: 200)),
//
//                         ///Accent Color
//                         badgeStyle: Badge.BadgeStyle(badgeColor: Theme.of(context).colorScheme.tertiary),
//                         child: Icon(Icons.shopping_basket_outlined, color: Colors.grey, size: 27.5),
//                       ),
//                       selectedIcon: Badge.Badge(
//                         badgeContent: Text('${postedData.items.length}', style: const TextStyle(color: Colors.white)),
//                         position: Badge.BadgePosition.topEnd(),
//                         showBadge: postedData.items.length > 0 ? true : false,
//                         badgeAnimation: Badge.BadgeAnimation.fade(animationDuration: Duration(milliseconds: 200)),
//
//                         ///Accent Color
//                         badgeStyle: Badge.BadgeStyle(badgeColor: Theme.of(context).colorScheme.tertiary),
//                         child: Icon(Icons.shopping_basket_outlined, color: Theme.of(context).colorScheme.tertiary, size: 30.5),
//                       ),
//                       label: Text('Products'),
//                       padding: EdgeInsets.only(bottom: 16.0),
//                     ),
//                     NavigationRailDestination(
//                       icon: Badge.Badge(
//                         badgeContent: Text('${productsData.items.length}', style: const TextStyle(color: Colors.white)),
//                         position: Badge.BadgePosition.topEnd(),
//                         showBadge: productsData.items.length > 0 ? true : false,
//                         badgeAnimation: Badge.BadgeAnimation.fade(animationDuration: Duration(milliseconds: 200)),
//
//                         ///Accent Color
//                         badgeStyle: Badge.BadgeStyle(badgeColor: Theme.of(context).colorScheme.tertiary),
//                         child: Icon(Icons.local_shipping_outlined, color: Colors.grey, size: 27.5),
//                       ),
//                       selectedIcon: Badge.Badge(
//                         badgeContent: Text('${productsData.items.length}', style: const TextStyle(color: Colors.white)),
//                         position: Badge.BadgePosition.topEnd(),
//                         showBadge: productsData.items.length > 0 ? true : false,
//                         badgeAnimation: Badge.BadgeAnimation.fade(animationDuration: Duration(milliseconds: 200)),
//
//                         ///Accent Color
//                         badgeStyle: Badge.BadgeStyle(badgeColor: Theme.of(context).colorScheme.tertiary),
//                         child: Icon(Icons.local_shipping_outlined, color: Theme.of(context).colorScheme.tertiary, size: 30.5),
//                       ),
//                       label: Text('Orders'),
//                       padding: EdgeInsets.only(bottom: 16.0),
//                     ),
//                     NavigationRailDestination(
//                       icon: Icon(Icons.person_outline_sharp, color: Colors.grey, size: 27.5),
//                       selectedIcon: Icon(Icons.person_sharp, color: Theme.of(context).colorScheme.tertiary, size: 30.5),
//                       label: Text('Profile'),
//                       padding: EdgeInsets.only(bottom: 16.0),
//                     ),
//                   ],
//                 ),
//                 VerticalDivider(thickness: 1, width: 1, color: Colors.white10),
//                 // This is the main content.
//                 Expanded(
//                   child: Scaffold(
//                     body: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 100),
//                       child: Align(
//                         alignment: Alignment.topCenter,
//                         child: Container(alignment: Alignment.center, width: 750, child: _children[_currentIndex]),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//       },
//     );
//   }
// }

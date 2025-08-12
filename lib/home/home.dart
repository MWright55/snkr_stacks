import 'package:badges/badges.dart' as Badge;
import 'package:snkr_stacks/providers/resources.dart' as RESOURCES;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snkr_stacks/screens/profile_screen.dart';
import 'package:snkr_stacks/screens/purchased_products_screen.dart';
import 'package:snkr_stacks/screens/search_products_screen.dart';
import 'package:snkr_stacks/screens/user_products_screen.dart';
import 'package:snkr_stacks/screens/vndy_feed.dart';
import '../providers/products_provider.dart';
import '../providers/shippments_provider.dart';
import '../responsive/super_body.dart';
import '../widgets/products_feed.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  // late Shippments productsData;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);

    // Delay access to context
    Future.microtask(() {
      // productsData = Provider.of<Shippments>(context, listen: false);
      // productsData.fetchAndSetOrders(); // This ensures items are loaded
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<Widget> _children = [VndyFeed(), SearchProductsScreen(), UserProductsScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    //final productsData = Provider.of<Shippments>(context);
    final postedData = Provider.of<Products>(context);

    final currentWidth = MediaQuery.of(context).size.width;

    //  final productsDataFontSize = (productsData.items.length - 1) * 3.0;

    return Scaffold(
      // body: SuperBody(),
      // body: _children[_currentIndex],
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        //selectedItemColor: Colors.black87,
        selectedItemColor: Theme.of(context).colorScheme.tertiary,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 27.5),
            activeIcon: GestureDetector(
              onDoubleTap: () {
                // print(productsData.items.length);
                ProductsFeed.globalKey.currentState?.scrollToTop();
              },
              child: Icon(Icons.home, size: 30.5),
            ),
            label: (''),
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search_outlined, size: 27.5), activeIcon: Icon(Icons.search, size: 30.5), label: ('')),
          BottomNavigationBarItem(
            icon: Badge.Badge(
              badgeContent: Text('${postedData.items.length}', style: const TextStyle(color: Colors.white)),
              position: Badge.BadgePosition.topEnd(),
              showBadge: postedData.items.length > 0 ? true : false,
              badgeAnimation: Badge.BadgeAnimation.fade(animationDuration: Duration(milliseconds: 200)),

              ///Accent Color
              badgeStyle: Badge.BadgeStyle(badgeColor: Theme.of(context).colorScheme.tertiary),
              child: Icon(Icons.shopping_basket_outlined, size: 27.5),
            ),
            activeIcon: Badge.Badge(
              badgeContent: Text('${postedData.items.length}', style: const TextStyle(color: Colors.white)),
              position: Badge.BadgePosition.topEnd(),
              showBadge: postedData.items.length > 0 ? true : false,
              badgeAnimation: Badge.BadgeAnimation.fade(animationDuration: Duration(milliseconds: 200)),

              ///Accent Color
              badgeStyle: Badge.BadgeStyle(badgeColor: Theme.of(context).colorScheme.tertiary),
              child: Icon(Icons.shopping_basket_outlined, size: 30.5),
            ),
            label: (''),
          ),
          // BottomNavigationBarItem(
          //   icon: Badge.Badge(
          //     badgeContent: Text('${productsData.items.length}', style: const TextStyle(color: Colors.white)),
          //     position: Badge.BadgePosition.topEnd(),
          //     showBadge: productsData.items.length > 0 ? true : false,
          //     badgeAnimation: Badge.BadgeAnimation.fade(animationDuration: Duration(milliseconds: 200)),
          //
          //     ///Accent Color
          //     badgeStyle: Badge.BadgeStyle(badgeColor: Theme.of(context).colorScheme.tertiary),
          //     child: Icon(Icons.local_shipping_outlined, size: 27.5),
          //   ),
          //   activeIcon: Badge.Badge(
          //     badgeContent: Text('${productsData.items.length}', style: const TextStyle(color: Colors.white)),
          //     position: Badge.BadgePosition.topEnd(),
          //     showBadge: productsData.items.length > 0 ? true : false,
          //     badgeAnimation: Badge.BadgeAnimation.fade(animationDuration: Duration(milliseconds: 200)),
          //
          //     ///Accent Color
          //     badgeStyle: Badge.BadgeStyle(badgeColor: Theme.of(context).colorScheme.tertiary),
          //     child: Icon(Icons.local_shipping_outlined, size: 30.5),
          //   ),
          //   label: (''),
          // ),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_sharp, size: 27.5), activeIcon: Icon(Icons.person_sharp, size: 30.5), label: ('')),
        ],
        // onTap: (index) {
        //   setState(() {
        //     _currentIndex = index;
        //   });
        // },
        onTap: (index) {
          _pageController.animateToPage(index, duration: Duration(milliseconds: 350), curve: Curves.easeInOut);
        },
      ),
    );
  }
}

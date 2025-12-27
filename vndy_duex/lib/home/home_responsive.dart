import 'package:flutter/material.dart';
import '../providers/products_provider.dart';
import '../responsive/responsive_layout.dart';

// TODO: replace these with your actual screens:
import 'package:vndy_duex/screens/authenticate/vndy_forgot.dart';
import 'package:vndy_duex/screens/authenticate/vndy_login.dart';
import 'package:vndy_duex/screens/authenticate/vndy_signup.dart';
import 'package:vndy_duex/screens/delete_account_screen.dart';
import 'package:vndy_duex/screens/edit_product_screen.dart';
import 'package:vndy_duex/screens/faq_screen.dart';
import 'package:vndy_duex/screens/no_internet.dart';
import 'package:vndy_duex/screens/product_checkout_screen.dart';
import 'package:vndy_duex/screens/purchased_products_screen.dart';
import 'package:vndy_duex/screens/review_purchase_screen.dart';
import 'package:vndy_duex/screens/search_products_screen.dart';
import 'package:vndy_duex/screens/product_detail_screen.dart';
import 'package:vndy_duex/screens/vndy_feed.dart';
import 'package:vndy_duex/screens/profile_screen.dart';

import '../screens/user_products_screen.dart';
enum AppTab { home, search, posted, shipped, profile }

class HomeResponsive extends StatefulWidget {
  const HomeResponsive({super.key});

  @override
  State<HomeResponsive> createState() => _HomeResponsiveState();
}

class _HomeResponsiveState extends State<HomeResponsive> {
  late PageController _pageController;
  int _currentIndex = 0;

  List<Widget> get _pages => [
    VndyLogin(),
    VndySignup(),
    VndyForgot(),
    ProductDetailScreen(),
    UserProductsScreen(),
    EditProductScreen(),
    ProductCheckoutScreen(),
    PurchasedProductsScreen(),
    SearchProductsScreen(),
    VndyFeed(),
    ReviewPurchaseScreen(),
    ProfileScreen(),
    FAQScreen(),
    NoInternetScreen(),
    DeleteAccountScreen(),        // Profile
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildMobile(context),
      tablet: _buildTablet(context),
      desktop: _buildDesktop(context),
    );
  }

  // 📱 MOBILE — your current style (bottom nav)
  Widget _buildMobile(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // keep behavior same
        children: _pages,
      ),
      bottomNavigationBar: _MobileBottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
      ),
    );
  }

  // 📲 TABLET — left sidebar (icons only), content centered-ish
  Widget _buildTablet(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _SideNavRail(
            selectedIndex: _currentIndex,
            onSelect: _onTabSelected,
            extended: false, // icons only
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: _pages,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🖥️ DESKTOP — Instagram style: extended left nav + centered content
  Widget _buildDesktop(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _SideNavRail(
            selectedIndex: _currentIndex,
            onSelect: _onTabSelected,
            extended: true, // icons + labels (Instagram-style)
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: _pages,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }




}

class _MobileBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _MobileBottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).colorScheme.tertiary,
      unselectedItemColor: Colors.white,
      backgroundColor: Colors.black.withOpacity(0.85),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      iconSize: 26,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_outlined),
          activeIcon: Icon(Icons.search),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_basket_outlined),
          activeIcon: Icon(Icons.shopping_basket),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_shipping_outlined),
          activeIcon: Icon(Icons.local_shipping),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: '',
        ),
      ],
      onTap: onTap,
    );
  }
}

class _SideNavRail extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final bool extended; // false = icons only, true = icons + labels

  const _SideNavRail({
    required this.selectedIndex,
    required this.onSelect,
    required this.extended,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onSelect,
      extended: extended,
      backgroundColor: Colors.black,
      selectedIconTheme: IconThemeData(
        color: Theme.of(context).colorScheme.tertiary,
        size: 26,
      ),
      unselectedIconTheme: const IconThemeData(
        color: Colors.white70,
        size: 24,
      ),
      selectedLabelTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.tertiary,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelTextStyle: const TextStyle(
        color: Colors.white70,
      ),
      labelType:
      extended ? NavigationRailLabelType.all : NavigationRailLabelType.none,
      leading: Padding(
        padding: const EdgeInsets.only(top: 24.0, bottom: 24),
        child: extended
            ? Text(
          'VNDY',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        )
            : const Icon(Icons.storefront, color: Colors.white, size: 28),
      ),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.search_outlined),
          selectedIcon: Icon(Icons.search),
          label: Text('Search'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.shopping_basket_outlined),
          selectedIcon: Icon(Icons.shopping_basket),
          label: Text('Posted'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.local_shipping_outlined),
          selectedIcon: Icon(Icons.local_shipping),
          label: Text('Shipped'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: Text('Profile'),
        ),
      ],
    );
  }
}


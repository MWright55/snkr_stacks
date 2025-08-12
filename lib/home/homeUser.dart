import 'package:flutter/material.dart';
import 'package:snkr_stacks/screens/profile_screen.dart';
import 'package:snkr_stacks/screens/vndy_feed.dart';
import 'package:snkr_stacks/screens/search_products_screen.dart';

import '../widgets/products_feed.dart';

class HomeUser extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeUser> {
  int _currentIndex = 0;
  late final PageController _pageController;
  final List<Widget> _children = [VndyFeed(), SearchProductsScreen(), ProfileScreen()];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                ProductsFeed.globalKey.currentState?.scrollToTop();
              },
              child: Icon(Icons.home, size: 30.5),
            ),
            label: (''),
            backgroundColor: Colors.grey,
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search_outlined, size: 27.5), activeIcon: Icon(Icons.search, size: 30.5), label: (''), backgroundColor: Colors.grey),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_sharp, size: 27.5), activeIcon: Icon(Icons.person_sharp, size: 30.5), label: (''), backgroundColor: Colors.grey),
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

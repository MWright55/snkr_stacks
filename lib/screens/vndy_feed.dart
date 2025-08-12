import 'package:flutter/material.dart';
import 'package:snkr_stacks/screens/products_overview_screen.dart';

class VndyFeed extends StatefulWidget {
  static const routeName = '/vndy-feed';

  @override
  _VndyHomeState createState() => _VndyHomeState();
}

class _VndyHomeState extends State<VndyFeed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ProductsOverviewScreen());
  }
}

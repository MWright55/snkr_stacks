// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:snkr_stacks/widgets/purchase_product_item.dart';
// import 'package:snkr_stacks/providers/shippments_provider.dart';
// import 'dart:async';
//
// class PurchasedProductsScreen extends StatefulWidget {
//   static const routeName = '/purchased-products';
//
//   @override
//   State<PurchasedProductsScreen> createState() => _PurchasedProductsScreenState();
// }
//
// class _PurchasedProductsScreenState extends State<PurchasedProductsScreen> {
//   late Future<void> _future;
//
//   Future<void> _refreshProducts(BuildContext context) async {
//     await Provider.of<Shippments>(context, listen: false).fetchAndSetOrders();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _future = _refreshProducts(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     //final productsData = Provider.of<Shippments>(context);
//     //final productsData = Provider.of<Products>(context);
//
//     // print('**Done with initState() purchased_products_screen**');
//     print('**Now in purchased_products_screen**');
//     print('SystemTime: ${DateTime.now()}');
//     // print('productsData.items.length :: ${productsData.items.length}');
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(toolbarHeight: 50, centerTitle: true, surfaceTintColor: Colors.transparent, title: const Text('Pending Orders'), backgroundColor: Colors.white),
//       body: FutureBuilder(
//         future: _future,
//         builder: (ctx, snapshot) => RefreshIndicator(
//           onRefresh: () => _refreshProducts(context),
//           child: Padding(
//             padding: EdgeInsets.all(0),
//             child: productsData.items.isEmpty
//                 ? Center(
//                     child: Text(
//                       ' No Pending Orders',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
//                     ),
//                   )
//                 : ListView.builder(
//                     key: PageStorageKey<String>('userPage'),
//                     itemCount: productsData.items.length,
//                     itemBuilder: (_, i) => Column(children: [PurchaseProductItem(productsData.items[i].id, productsData.items[i].title, productsData.items[i].imageUrl0, productsData.items[i].sku)]),
//                   ),
//           ),
//         ),
//       ),
//     );
//   }
// }

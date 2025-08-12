import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snkr_stacks/providers/products_provider.dart';

//import 'package:vndy/providers/product.dart';
import 'package:snkr_stacks/widgets/product_item.dart';
import '../providers/shippments_provider.dart';
//import 'package:vndy/providers/product.dart';

class ProductsFeed extends StatefulWidget {
  final bool showFavs;

  ProductsFeed(this.showFavs, {Key? key}) : super(key: globalKey);

  // 👇 Optional: Expose key for external access
  static final GlobalKey<_ProductsFeedState> globalKey = GlobalKey<_ProductsFeedState>();

  @override
  _ProductsFeedState createState() => _ProductsFeedState();
}

class _ProductsFeedState extends State<ProductsFeed> {
  bool _showBackToTopButton = false;

  late ScrollController _scrollController;
  late PageController _pageController;

  @override
  void initState() {
    print('**Now in products_feed**');
    print('SystemTime: ${DateTime.now()}');
    super.initState();
    Provider.of<Products>(context, listen: false).fetchAndSetProducts();

    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController.offset >= 2750) {
            _showBackToTopButton = true; // show the back-to-top button
          } else {
            _showBackToTopButton = false; // hide the back-to-top button
          }
        });
      });

    _pageController = PageController()
      ..addListener(() {
        setState(() {
          if (_pageController.offset >= 2750) {
            _showBackToTopButton = true; // show the back-to-top button
          } else {
            _showBackToTopButton = false; // hide the back-to-top button
          }
        });
      });
  }

  // advancedStatusCheck(NewVersionPlus newVersion) async {
  //   final status = await newVersion.getVersionStatus();
  //   if (status != null) {
  //     debugPrint(status.releaseNotes);
  //     debugPrint(status.appStoreLink);
  //     debugPrint(status.localVersion);
  //     debugPrint(status.storeVersion);
  //     debugPrint(status.canUpdate.toString());
  //     // newVersion.showUpdateDialog(
  //     //   context: context,
  //     //   versionStatus: status,
  //     //   dialogTitle: 'Custom Title',
  //     //   dialogText: 'Custom Text',
  //     //   launchModeVersion: LaunchModeVersion.external,
  //     //   allowDismissal: false,
  //     // );
  //   }
  // }

  @override
  void dispose() {
    _scrollController.dispose(); // dispose the controller
    super.dispose();
  }

  // This function is triggered when the user presses the back-to-top button
  void scrollToTop() {
    _pageController.animateTo(0, duration: Duration(milliseconds: 2500), curve: Curves.ease);
  }

  Future<void> _refreshFeed(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    print("🌀 Rebuilding ProductsFeed");
    final productsData = Provider.of<Products>(context);
    print('📦 Products loaded: ${productsData.items.length}');

    //print("::products::");
    //print(productsData.items.length);

    /*GridViewBuilder*/
    //    return GridView.builder(
    //      // padding: const EdgeInsets.all(10.0),
    //      padding: const EdgeInsets.all(10.0),
    //      itemCount: products.length,
    //      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
    //        //create: (c) => products[i],
    //        value: products[i],
    //        child: ProductItem(),
    //      ),
    //      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //          crossAxisCount: 1,
    //          //childAspectRatio: 3 / 2,
    //          //childAspectRatio: 4 / 3,
    //          // childAspectRatio: 5 / 3,
    //          //childAspectRatio: 5 / 4,
    //          //childAspectRatio: 4 / 5,
    //          childAspectRatio: 1 / 1,
    //          crossAxisSpacing: 10.0,
    //          mainAxisSpacing: 10.0),
    //    );
    /*GridViewBuilder*/
    /*ListViewBuilder*/

    return Scaffold(
      backgroundColor: Colors.white,
      body: productsData.items.isEmpty
          ? Center(
              child: Text(
                ' Products feed is empty',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
              ),
            )
          : RefreshIndicator(
              onRefresh: () => _refreshFeed(context),

              ///card View
              ///child: ListView.builder(
              ///change for TikTok View
              child: PageView.builder(
                allowImplicitScrolling: true,

                ///-----------------------
                scrollDirection: Axis.vertical,
                key: PageStorageKey<String>('feedPage'),

                controller: _pageController,

                itemCount: productsData.items.length,
                itemBuilder: (ctx, i) => ChangeNotifierProvider.value(value: productsData.items[i], child: ProductItem()),
              ),
            ),
      floatingActionButton: _showBackToTopButton == false
          ? null
          : FloatingActionButton(
              onPressed: scrollToTop,
              child: Icon(Icons.arrow_upward, color: Colors.white),
              backgroundColor: Theme.of(context).colorScheme.tertiary,
            ),
    );
    /*ListViewBuilder*/
  }
}

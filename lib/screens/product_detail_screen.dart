import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//import 'package:photo_view/photo_view.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:provider/provider.dart';
import 'package:snkr_stacks/providers/product.dart';
import 'package:snkr_stacks/providers/products_provider.dart';
import 'package:snkr_stacks/providers/shippments_provider.dart';
import 'package:snkr_stacks/screens/product_checkout_screen.dart';

//import 'package:video_player/video_player.dart';
import 'package:flutter/scheduler.dart';
import 'package:snkr_stacks/screens/shopify_checkout_screen.dart';

import '../main.dart';
import '../responsive/dimensions.dart';
import '../services/shopify_service.dart';
import 'package:snkr_stacks/services/shopify_service.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';

  @override
  // _ProductDetailScreenState createState() => _ProductDetailScreenState();
  State<StatefulWidget> createState() {
    return _ProductDetailScreenState();
  }
}

Future<void> _refreshProducts(BuildContext context) async {
  //await Provider.of<Shippments>(context, listen: false).fetchAndSetOrders();
  print("refreshProducts called");
}

class _ProductDetailScreenState extends State<ProductDetailScreen> with SingleTickerProviderStateMixin {
  int _current = 0;
  var red, blue, green;
  String clearPurchase = "false";
  PageStorageBucket _bucket = PageStorageBucket();

  final double minScale = 1;
  final double maxScale = 4;

  double scale = 1;
  OverlayEntry? entry;

  late TransformationController controller;
  late AnimationController animationController;
  Animation<Matrix4>? animation;

  //late VideoPlayerController _controller;

  void initState() {
    super.initState();

    controller = TransformationController();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 200))
      ..addListener(() => controller.value = animation!.value)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          removeOverlay();
        }
      });

    ///video controller
    // _controller = VideoPlayerController.networkUrl(Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
    //   ..setLooping(true)
    //   ..initialize().then((_) {
    //     setState(() {});
    //     _controller.play();
    //   });
    ///video controller
  } //End initState

  void dispose() {
    controller.dispose();
    animationController.dispose();
    //_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Center(child: buildImage());

  //OG Setup
  // @override
  // Widget build(BuildContext context) {
  Widget buildImage() {
    //Hero Transition speed
    timeDilation = 1.5;
    final productID = ModalRoute.of(context)!.settings.arguments as String; //is the id

    final loadedProduct = Provider.of<Products>(context, listen: false).findById(productID);

    if (loadedProduct == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Product Not Found")),
        body: const Center(child: Text("This product no longer exists.")),
      );
    }

    //final purchasedProducts = Provider.of<Shippments>(context, listen: false);
    final double _height = MediaQuery.of(context).size.height;

    bool blockScroll = false;
    ScrollController controller = ScrollController();

    List<String> imgList = [];

    //  PhotoView(
    //   imageProvider: NetworkImage(loadedProduct.imageUrl0),
    //   backgroundDecoration: BoxDecoration(color: Colors.white),
    //   minScale: PhotoViewComputedScale.contained,
    //   maxScale: PhotoViewComputedScale.covered * 2.5,
    // );

    //PhotoViewController _controller = PhotoViewController();

    // if (loadedProduct!.imageUrl0 != "null" && loadedProduct.imageUrl0 != null && loadedProduct.imageUrl0 != "") {
    //   imgList.add(loadedProduct.imageUrl0);
    //   print("URL0 ADDED");
    // }
    // if (loadedProduct.imageUrl1 != "null" && loadedProduct.imageUrl1 != null && loadedProduct.imageUrl1 != "") {
    //   imgList.add(loadedProduct.imageUrl1);
    //   print("URL0 ADDED");
    // }
    // if (loadedProduct.imageUrl2 != "null" && loadedProduct.imageUrl2 != null && loadedProduct.imageUrl2 != "") {
    //   imgList.add(loadedProduct.imageUrl2);
    //   print("URL0 ADDED");
    // }
    // print("URL0:" + loadedProduct.imageUrl0);
    // print("URL1:" + loadedProduct.imageUrl1);
    // print("URL2:" + loadedProduct.imageUrl2);

    if (loadedProduct != null && loadedProduct.imageUrls.isNotEmpty) {
      imgList = loadedProduct.imageUrls.where((url) => url != null && url != "null" && url.trim().isNotEmpty).toList();
    }

    print("Image URLs found: ${loadedProduct.imageUrls.length}");
    //loadedProduct.imageUrls.forEach((url) => print("➡️ $url"));

    final List<Widget> imageSliders = imgList
        .map(
          (item) => Container(
            child: Container(
              child: PinchZoom(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Stack(
                    children: <Widget>[
                      Image.network(width: double.infinity, item, fit: BoxFit.cover),

                      ///video controller
                      // _controller.value.isInitialized
                      //     ? AspectRatio(
                      //         aspectRatio: _controller.value.aspectRatio,
                      //         child: VideoPlayer(_controller),
                      //       )
                      //     : CircularProgressIndicator(),

                      ///video controller
                      Container(height: MediaQuery.of(context).size.width),
                    ],
                  ),
                ),
                maxScale: 2.5,
                onZoomStart: () {
                  print('Start zooming');
                },
                onZoomEnd: () {
                  print('Stop zooming');
                },
              ),
            ),
          ),
        )
        .toList();

    //   if (MediaQuery.of(context).size.width < mobileWidth)
    {
      //--mobile--
      return Align(
        alignment: Alignment.center,
        child: Scaffold(
          backgroundColor: Colors.white,
          //extendBodyBehindAppBar: true,
          appBar: AppBar(backgroundColor: Colors.white, surfaceTintColor: Colors.transparent, elevation: 0, centerTitle: true, title: Text(loadedProduct.title)),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(5.0),
                  width: double.infinity,
                  height: 450,
                  child: Hero(
                    tag: productID,
                    child: PageStorage(
                      bucket: _bucket,
                      child: GridTile(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop(false);
                          },
                          onDoubleTap: () {
                            print("Now on Product Detail page");
                          },
                          child: CarouselSlider(
                            items: imageSliders,
                            options: CarouselOptions(
                              // aspectRatio: 2.0,
                              height: _height,
                              viewportFraction: 1.0,
                              initialPage: 0,
                              enlargeCenterPage: true,
                              // enlargeCenterPage: false,
                              enableInfiniteScroll: false,
                              autoPlay: false,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _current = index;
                                  print("_current: $index");
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imgList.map((url) {
                    int index = imgList.indexOf(url);
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(shape: BoxShape.circle, color: _current == index ? Color.fromRGBO(0, 0, 0, 0.9) : Color.fromRGBO(0, 0, 0, 0.4)),
                    );
                  }).toList(),
                ),
                //SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 15.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                '${loadedProduct.title}',
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w900,

                                  //letterSpacing: 2.5,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text('\$${loadedProduct.price.toStringAsFixed(2)}', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Status',
                              //'${loadedProduct.title}',
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                //letterSpacing: 2.5,
                              ),
                            ),
                            Text('${loadedProduct.status}', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Category',
                              //'${loadedProduct.title}',
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                //letterSpacing: 2.5,
                              ),
                            ),
                            Text('${loadedProduct.type}', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Size',
                              //'${loadedProduct.title}',
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                //letterSpacing: 2.5,
                              ),
                            ),
                            Text('${loadedProduct.size}', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          '${loadedProduct.description}',
                          style: TextStyle(fontSize: 14.5, color: Colors.black54, height: 1.35, fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
              //  ),
            ),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black)],
            ),
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  minimumSize: Size(0, 48),
                  textStyle: TextStyle(fontFamily: GoogleFonts.bebasNeue().fontFamily, fontSize: 18.0, fontWeight: FontWeight.w700, color: Colors.white, wordSpacing: 2.0, letterSpacing: 1.9),
                  backgroundColor: Colors.black,
                ),
                child: Text('Buy Now'),

                // onPressed: () {
                //   _refreshProducts(context);
                //   // _checkIfPurchased(loadedProduct.sku, purchasedProducts, loadedProduct);
                //   print('Check if available A');
                //   print('pageURL: ${loadedProduct.pageUrl}');
                //   Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ShopifyCheckoutScreen(checkoutUrl: loadedProduct.pageUrl as String)));
                // },

                // onPressed: () async {
                //   print('🛒 BUY NOW tapped for product: ${loadedProduct.title}');
                //
                //   // ✅ Grab the first variant ID (later: add selector for multiple variants)
                //   final variants = loadedProduct.variants;
                //   if (variants == null || variants.isEmpty) {
                //     print('❌ No variants found for this product.');
                //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('This product cannot be purchased right now.')));
                //     return;
                //   }
                //
                //   final variantId = variants.first['id'].toString();
                //   final quantity = 1; // default to 1 for now
                //
                //   print('✅ Using variantId: $variantId');
                //
                //   // ✅ Shopify Cart Deep Link (PLAIN)
                //   final shopifyService = await getDefaultShopifyService();
                //   final checkoutUrl = "${shopifyService.storeUrl}/cart/$variantId:$quantity";
                //
                //   // ✅ Shopify Cart Deep Link (WITH DISCOUNT)
                //   // toggle this block ON if you want discount tracking enabled:
                //   // final checkoutUrl = "https://snkrgram.myshopify.com/cart/$variantId:$quantity?discount=SNKRSTACKS";
                //
                //   print('🌐 Generated checkout URL: $checkoutUrl');
                //
                //   // ✅ Navigate to WebView checkout
                //   Navigator.of(context).push(MaterialPageRoute(builder: (_) => ShopifyCheckoutScreen(checkoutUrl: checkoutUrl)));
                // },
                onPressed: () async {
                  print('🛒 BUY NOW tapped for product: ${loadedProduct.title}');

                  final variants = loadedProduct.variants;

                  if (variants is List && variants.isNotEmpty && variants.first is Map) {
                    final variantId = variants.first['id']?.toString();
                    if (variantId == null || variantId.isEmpty) {
                      print('❌ Variant ID is null or empty');
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Invalid variant ID.')));
                      return;
                    }

                    final quantity = 1;

                    try {
                      final shopifyService = await getPrimaryShopifyService();

                      // ✅ Option A: Storefront API (commented out for now)
                      // final checkoutUrl = await shopifyService.createCheckout(variantId, quantity);

                      // ✅ Option B: Deep link
                      final checkoutUrl = "${shopifyService.storeUrl}/cart/$variantId:$quantity";

                      print('🌐 Generated checkout URL: $checkoutUrl');
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => ShopifyCheckoutScreen(checkoutUrl: checkoutUrl)));
                    } catch (e) {
                      print('❌ Error during checkout: $e');
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Failed to process checkout.')));
                    }
                  } else {
                    print('❌ No valid variants found for this product.');
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ No variants available for this product.')));
                  }
                },
              ),
            ),
          ),
        ),
      );
    }
    // else if (MediaQuery.of(context).size.width < tabletWidth) {
    //   //--tablet--
    //   return Padding(
    //     padding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 15.0),
    //     // padding: const EdgeInsets.all(8.0),
    //     child: Scaffold(
    //       appBar: AppBar(backgroundColor: Colors.white, surfaceTintColor: Colors.transparent, elevation: 0, centerTitle: true, title: Text(loadedProduct.title)),
    //       body: Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 100.0),
    //         child: Row(
    //           children: [
    //             // Left Column
    //             Expanded(
    //               flex: 1,
    //               child: Padding(
    //                 padding: const EdgeInsets.all(20.0),
    //                 child: Container(
    //                   color: Colors.blue,
    //                   child: Column(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: [
    //                       Expanded(
    //                         child: Container(
    //                           color: Colors.red,
    //                           child: Center(
    //                             child: Container(
    //                               padding: const EdgeInsets.symmetric(vertical: 150),
    //                               color: Colors.orangeAccent,
    //                               width: double.infinity,
    //                               height: double.infinity,
    //                               child: Hero(
    //                                 tag: productID,
    //                                 child: PageStorage(
    //                                   bucket: _bucket,
    //                                   child: GridTile(
    //                                     child: GestureDetector(
    //                                       onTap: () {
    //                                         Navigator.of(context).pop();
    //                                       },
    //                                       onDoubleTap: () {
    //                                         print("Now on Product Detail page");
    //                                       },
    //                                       child: CarouselSlider(
    //                                         items: imageSliders,
    //                                         options: CarouselOptions(
    //                                           // aspectRatio: 2.0,
    //                                           height: _height,
    //                                           viewportFraction: 1.0,
    //                                           initialPage: 0,
    //                                           enlargeCenterPage: true,
    //                                           // enlargeCenterPage: false,
    //                                           enableInfiniteScroll: false,
    //                                           autoPlay: false,
    //                                           onPageChanged: (index, reason) {
    //                                             setState(() {
    //                                               _current = index;
    //                                               print("_current: $index");
    //                                             });
    //                                           },
    //                                         ),
    //                                       ),
    //                                     ),
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                       Container(
    //                         //color: Colors.purple, // Bottom row in the left column
    //                         height: 50,
    //                         child: Center(
    //                           child: Row(
    //                             mainAxisAlignment: MainAxisAlignment.center,
    //                             children: imgList.map((url) {
    //                               int index = imgList.indexOf(url);
    //                               return Container(
    //                                 width: 8.0,
    //                                 height: 8.0,
    //                                 margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
    //                                 decoration: BoxDecoration(shape: BoxShape.circle, color: _current == index ? Color.fromRGBO(0, 0, 0, 0.9) : Color.fromRGBO(0, 0, 0, 0.4)),
    //                               );
    //                             }).toList(),
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //
    //             // Right Column
    //             Expanded(
    //               flex: 1,
    //               child: Padding(
    //                 padding: const EdgeInsets.all(20.0),
    //                 child: Container(
    //                   //color: Colors.red,
    //                   child: Column(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Expanded(
    //                         child: Padding(
    //                           padding: const EdgeInsets.all(8.0),
    //                           // child: Column(
    //                           //   crossAxisAlignment: CrossAxisAlignment.start,
    //                           //   children: [
    //                           //     Text(
    //                           //       'Label 1',
    //                           //       style: TextStyle(color: Colors.yellow, fontSize: 16),
    //                           //     ),
    //                           //     SizedBox(height: 10),
    //                           //     Text(
    //                           //       'Label 2',
    //                           //       style: TextStyle(color: Colors.green, fontSize: 16),
    //                           //     ),
    //                           //     SizedBox(height: 10),
    //                           //     Text(
    //                           //       'Label 3',
    //                           //       style: TextStyle(color: Colors.orange, fontSize: 16),
    //                           //     ),
    //                           //     SizedBox(height: 10),
    //                           //     Text(
    //                           //       'Label 4',
    //                           //       style: TextStyle(color: Colors.cyan, fontSize: 16),
    //                           //     ),
    //                           //   ],
    //                           // ),
    //                           child: Column(
    //                             mainAxisAlignment: MainAxisAlignment.center,
    //                             children: <Widget>[
    //                               Padding(
    //                                 padding: const EdgeInsets.only(top: 10.0),
    //                                 child: Row(
    //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                                   children: <Widget>[
    //                                     Expanded(
    //                                       child: Text(
    //                                         '${loadedProduct.title}',
    //                                         softWrap: true,
    //                                         style: TextStyle(
    //                                           fontSize: 18.0,
    //                                           fontWeight: FontWeight.w900,
    //
    //                                           //letterSpacing: 2.5,
    //                                         ),
    //                                       ),
    //                                     ),
    //                                     SizedBox(width: 10),
    //                                     Text('\$${loadedProduct.price.toStringAsFixed(2)}', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
    //                                   ],
    //                                 ),
    //                               ),
    //                               Padding(
    //                                 padding: const EdgeInsets.only(top: 10.0),
    //                                 child: Row(
    //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                                   children: <Widget>[
    //                                     Text(
    //                                       'Status',
    //                                       //'${loadedProduct.title}',
    //                                       softWrap: true,
    //                                       style: TextStyle(
    //                                         fontSize: 18,
    //                                         fontWeight: FontWeight.w600,
    //                                         //letterSpacing: 2.5,
    //                                       ),
    //                                     ),
    //                                     Text('${loadedProduct.status}', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
    //                                   ],
    //                                 ),
    //                               ),
    //                               Padding(
    //                                 padding: const EdgeInsets.only(top: 10.0),
    //                                 child: Row(
    //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                                   children: <Widget>[
    //                                     Text(
    //                                       'Category',
    //                                       //'${loadedProduct.title}',
    //                                       softWrap: true,
    //                                       style: TextStyle(
    //                                         fontSize: 18,
    //                                         fontWeight: FontWeight.w600,
    //                                         //letterSpacing: 2.5,
    //                                       ),
    //                                     ),
    //                                     Text('${loadedProduct.type}', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
    //                                   ],
    //                                 ),
    //                               ),
    //                               Padding(
    //                                 padding: const EdgeInsets.only(top: 10.0),
    //                                 child: Row(
    //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                                   children: <Widget>[
    //                                     Text(
    //                                       'Size',
    //                                       //'${loadedProduct.title}',
    //                                       softWrap: true,
    //                                       style: TextStyle(
    //                                         fontSize: 18,
    //                                         fontWeight: FontWeight.w600,
    //                                         //letterSpacing: 2.5,
    //                                       ),
    //                                     ),
    //                                     Text('${loadedProduct.size}', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
    //                                   ],
    //                                 ),
    //                               ),
    //                               Padding(
    //                                 padding: const EdgeInsets.only(top: 10.0),
    //                                 child: Text(
    //                                   '${loadedProduct.description}',
    //                                   style: TextStyle(fontSize: 14.5, color: Colors.black54, height: 1.35, fontWeight: FontWeight.w400),
    //                                 ),
    //                               ),
    //                               SizedBox(height: 40),
    //                             ],
    //                           ),
    //                         ),
    //                       ),
    //                       Container(
    //                         width: double.infinity,
    //                         decoration: BoxDecoration(color: Colors.white),
    //                         child: Padding(
    //                           padding: EdgeInsets.all(15.0),
    //                           child: TextButton(
    //                             style: TextButton.styleFrom(
    //                               foregroundColor: Colors.white,
    //                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    //                               minimumSize: Size(0, 48),
    //                               textStyle: TextStyle(
    //                                 fontFamily: GoogleFonts.bebasNeue().fontFamily,
    //                                 fontSize: 18.0,
    //                                 fontWeight: FontWeight.w700,
    //                                 color: Colors.white,
    //                                 wordSpacing: 2.0,
    //                                 letterSpacing: 1.9,
    //                               ),
    //                               backgroundColor: Colors.black,
    //                             ),
    //                             child: Text('Checkout'),
    //                             onPressed: () {
    //                               _refreshProducts(context);
    //                               _checkIfPurchased(loadedProduct.sku, purchasedProducts, loadedProduct);
    //                               print('Check if available B');
    //                             },
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   );
    // }
    // else {
    //   //--desktop--
    //   return Padding(
    //     padding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 15.0),
    //     // padding: const EdgeInsets.all(8.0),
    //     child: Scaffold(
    //       appBar: AppBar(backgroundColor: Colors.white, surfaceTintColor: Colors.transparent, elevation: 0, centerTitle: true, title: Text(loadedProduct.title)),
    //       body: Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 100.0),
    //         child: Row(
    //           children: [
    //             // Left Column
    //             Expanded(
    //               flex: 1,
    //               child: Padding(
    //                 padding: const EdgeInsets.all(20.0),
    //                 child: Container(
    //                   //color: Colors.blue,
    //                   child: Column(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Expanded(
    //                         child: Container(
    //                           child: Center(
    //                             child: Container(
    //                               padding: const EdgeInsets.symmetric(vertical: 50),
    //                               width: double.infinity,
    //                               height: double.infinity,
    //                               child: Hero(
    //                                 tag: productID,
    //                                 child: PageStorage(
    //                                   bucket: _bucket,
    //                                   child: GridTile(
    //                                     child: GestureDetector(
    //                                       onTap: () {
    //                                         Navigator.of(context).pop();
    //                                       },
    //                                       onDoubleTap: () {
    //                                         print("Now on Product Detail page");
    //                                       },
    //                                       child: CarouselSlider(
    //                                         items: imageSliders,
    //                                         options: CarouselOptions(
    //                                           // aspectRatio: 2.0,
    //                                           height: _height,
    //                                           viewportFraction: 1.0,
    //                                           initialPage: 0,
    //                                           enlargeCenterPage: true,
    //                                           // enlargeCenterPage: false,
    //                                           enableInfiniteScroll: false,
    //                                           autoPlay: false,
    //                                           onPageChanged: (index, reason) {
    //                                             setState(() {
    //                                               _current = index;
    //                                               print("_current: $index");
    //                                             });
    //                                           },
    //                                         ),
    //                                       ),
    //                                     ),
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                       Container(
    //                         //color: Colors.purple, // Bottom row in the left column
    //                         height: 50,
    //                         child: Center(
    //                           child: Row(
    //                             mainAxisAlignment: MainAxisAlignment.center,
    //                             children: imgList.map((url) {
    //                               int index = imgList.indexOf(url);
    //                               return Container(
    //                                 width: 8.0,
    //                                 height: 8.0,
    //                                 margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
    //                                 decoration: BoxDecoration(shape: BoxShape.circle, color: _current == index ? Color.fromRGBO(0, 0, 0, 0.9) : Color.fromRGBO(0, 0, 0, 0.4)),
    //                               );
    //                             }).toList(),
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             // Right Column
    //             Expanded(
    //               flex: 1,
    //               child: Padding(
    //                 padding: const EdgeInsets.all(20.0),
    //                 child: Container(
    //                   //color: Colors.red,
    //                   child: Column(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Expanded(
    //                         child: Padding(
    //                           padding: const EdgeInsets.all(8.0),
    //                           // child: Column(
    //                           //   crossAxisAlignment: CrossAxisAlignment.start,
    //                           //   children: [
    //                           //     Text(
    //                           //       'Label 1',
    //                           //       style: TextStyle(color: Colors.yellow, fontSize: 16),
    //                           //     ),
    //                           //     SizedBox(height: 10),
    //                           //     Text(
    //                           //       'Label 2',
    //                           //       style: TextStyle(color: Colors.green, fontSize: 16),
    //                           //     ),
    //                           //     SizedBox(height: 10),
    //                           //     Text(
    //                           //       'Label 3',
    //                           //       style: TextStyle(color: Colors.orange, fontSize: 16),
    //                           //     ),
    //                           //     SizedBox(height: 10),
    //                           //     Text(
    //                           //       'Label 4',
    //                           //       style: TextStyle(color: Colors.cyan, fontSize: 16),
    //                           //     ),
    //                           //   ],
    //                           // ),
    //                           child: Column(
    //                             mainAxisAlignment: MainAxisAlignment.center,
    //                             children: <Widget>[
    //                               Padding(
    //                                 padding: const EdgeInsets.only(top: 10.0),
    //                                 child: Row(
    //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                                   children: <Widget>[
    //                                     Expanded(
    //                                       child: Text(
    //                                         '${loadedProduct.title}',
    //                                         softWrap: true,
    //                                         style: TextStyle(
    //                                           fontSize: 24.0,
    //                                           fontWeight: FontWeight.w900,
    //
    //                                           //letterSpacing: 2.5,
    //                                         ),
    //                                       ),
    //                                     ),
    //                                     SizedBox(width: 10),
    //                                     Text('\$${loadedProduct.price.toStringAsFixed(2)}', style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500)),
    //                                   ],
    //                                 ),
    //                               ),
    //                               Padding(
    //                                 padding: const EdgeInsets.only(top: 10.0),
    //                                 child: Row(
    //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                                   children: <Widget>[
    //                                     Text(
    //                                       'Status',
    //                                       //'${loadedProduct.title}',
    //                                       softWrap: true,
    //                                       style: TextStyle(
    //                                         fontSize: 24,
    //                                         fontWeight: FontWeight.w600,
    //                                         //letterSpacing: 2.5,
    //                                       ),
    //                                     ),
    //                                     Text('${loadedProduct.status}', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
    //                                   ],
    //                                 ),
    //                               ),
    //                               Padding(
    //                                 padding: const EdgeInsets.only(top: 10.0),
    //                                 child: Row(
    //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                                   children: <Widget>[
    //                                     Text(
    //                                       'Category',
    //                                       //'${loadedProduct.title}',
    //                                       softWrap: true,
    //                                       style: TextStyle(
    //                                         fontSize: 24,
    //                                         fontWeight: FontWeight.w600,
    //                                         //letterSpacing: 2.5,
    //                                       ),
    //                                     ),
    //                                     Text('${loadedProduct.type}', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
    //                                   ],
    //                                 ),
    //                               ),
    //                               Padding(
    //                                 padding: const EdgeInsets.only(top: 10.0),
    //                                 child: Row(
    //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                                   children: <Widget>[
    //                                     Text(
    //                                       'Size',
    //                                       //'${loadedProduct.title}',
    //                                       softWrap: true,
    //                                       style: TextStyle(
    //                                         fontSize: 24,
    //                                         fontWeight: FontWeight.w600,
    //                                         //letterSpacing: 2.5,
    //                                       ),
    //                                     ),
    //                                     Text('${loadedProduct.size}', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
    //                                   ],
    //                                 ),
    //                               ),
    //                               Padding(
    //                                 padding: const EdgeInsets.only(top: 10.0),
    //                                 child: Text(
    //                                   '${loadedProduct.description}',
    //                                   style: TextStyle(fontSize: 16.5, color: Colors.black54, height: 1.35, fontWeight: FontWeight.w400),
    //                                 ),
    //                               ),
    //                               SizedBox(height: 40),
    //                             ],
    //                           ),
    //                         ),
    //                       ),
    //                       Container(
    //                         width: double.infinity,
    //                         decoration: BoxDecoration(color: Colors.white),
    //                         child: Padding(
    //                           padding: EdgeInsets.all(15.0),
    //                           child: TextButton(
    //                             style: TextButton.styleFrom(
    //                               foregroundColor: Colors.white,
    //                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    //                               minimumSize: Size(0, 48),
    //                               textStyle: TextStyle(
    //                                 fontFamily: GoogleFonts.bebasNeue().fontFamily,
    //                                 fontSize: 24.0,
    //                                 fontWeight: FontWeight.w700,
    //                                 color: Colors.white,
    //                                 wordSpacing: 2.0,
    //                                 letterSpacing: 1.9,
    //                               ),
    //                               backgroundColor: Colors.black,
    //                             ),
    //                             child: Text('Checkout'),
    //                             onPressed: () {
    //                               _refreshProducts(context);
    //                               _checkIfPurchased(loadedProduct.sku, purchasedProducts, loadedProduct);
    //                               print('Check if available C');
    //                             },
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   );
    // }
  }

  // Future<String> _checkIfPurchased(String sku, Shippments purchasedProducts, Product loadedProduct) async {
  //   print('Now in _checkIfPurchased');
  //   //print('passed SKU: $sku');
  //
  //   // int skuAlt = int.parse(sku);
  //   //String skuAlt = sku;
  //   //print("skuAlt:$skuAlt");
  //   bool match = false;
  //
  //   print("******************");
  //   print(purchasedProducts.items.length);
  //   final List<Product> loadedProducts = [];
  //
  //   bool _information = false;
  //
  //   void updateInformation(information) {
  //     setState(() => _information = information);
  //   }
  //
  //   int x = 0;
  //   int length = loadedProducts.length;
  //   int length2 = purchasedProducts.items.length;
  //   //print("**length**:$length");
  //   //print("**length2**:$length2");
  //   //loadedProducts.forEach((element) {
  //   for (x = 0; x < purchasedProducts.items.length; x++) {
  //     if (purchasedProducts.items[x].sku == sku) {
  //       print("**SKU match Found**");
  //       match = true;
  //     } else {
  //       print("**SKU match not found**");
  //     }
  //     //print(x);
  //     //print(purchasedProducts.items[x].sku);
  //     //print(sku);
  //     // x++;
  //   }
  //
  //   //Navigator.of(context).pushNamed(ProductCheckoutScreen.routeName, arguments: loadedProduct.id);
  //
  //   print("**move to checkout screen**");
  //   // print ("Match: $match");
  //   if (match) {
  //     print("!!!NOT clear for purchase!!!");
  //     Navigator.of(context).pop();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Unfortunately this item no longer available. Please refresh feed.', textAlign: TextAlign.center),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   } else {
  //     print("!!!All clear for purchase!!!");
  //     final information = await Navigator.of(context).pushNamed(ProductCheckoutScreen.routeName, arguments: loadedProduct.id); //Key problem
  //
  //     updateInformation(information);
  //     print("_information: \$_information");
  //     if (_information == true) {
  //       Navigator.pop(context, _information);
  //       _refreshProducts(context);
  //     } else {
  //       _refreshProducts(context);
  //     }
  //   }
  //   return 'done';
  // }

  void showOverlay(BuildContext context) {
    final renderBox = context.findRenderObject()! as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = MediaQuery.of(context).size;

    entry = OverlayEntry(
      builder: (context) {
        final double opacity = ((scale - 1) / (maxScale - 1)).clamp(0.2, 1);
        return Stack(
          children: <Widget>[
            Positioned.fill(
              child: Opacity(
                opacity: opacity,
                child: Container(color: Colors.black),
              ),
            ),
            Positioned(left: offset.dx, top: offset.dy, width: size.width, child: buildImage()),
          ],
        );
      },
    );

    final overlay = Overlay.of(context)!;
    overlay.insert(entry!);
  }

  void removeOverlay() {
    entry?.remove();
    entry = null;
  }

  void resetAnimation() {
    animation = Matrix4Tween(begin: controller.value, end: Matrix4.identity()).animate(CurvedAnimation(parent: animationController, curve: Curves.easeIn));
    animationController.forward(from: 0);
  }
}

//OG Setup

//Alt SetUp
//
//
//   Text _buildRatingStars(int rating) {
//     String stars = '';
//     for (int i = 0; i < rating; i++) {
//       stars += '⭐ ';
//     }
//     stars.trim();
//     return Text(stars);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final productID =
//     ModalRoute
//         .of(context)!
//         .settings
//         .arguments as String; //is the id
//     final loadedProduct = Provider.of<Products>(
//       context,
//       listen: false,
//     ).findById(productID);
//
//
//     return Scaffold(
//       body: Column(
//         children: <Widget>[
//           Stack(
//             children: <Widget>[
//               Container(
//                 height: MediaQuery
//                     .of(context)
//                     .size
//                     .width,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(30.0),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black26,
//                       offset: Offset(0.0, 2.0),
//                       blurRadius: 6.0,
//                     ),
//                   ],
//                 ),
//                 child: Hero(
//                   //tag: widget.destination.imageUrl,
//                   tag: productID,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(30.0),
//                     child: Image(
//                       image: NetworkImage(loadedProduct.imageUrl0),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     IconButton(
//                       icon: Icon(Icons.arrow_back),
//                       iconSize: 30.0,
//                       color: Colors.black,
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                     Row(
//                       children: <Widget>[
//                         IconButton(
//                           icon: Icon(Icons.search),
//                           iconSize: 30.0,
//                           color: Colors.black,
//                           onPressed: () => Navigator.pop(context),
//                         ),
//                         IconButton(
//                           icon: Icon(FontAwesomeIcons.sortAmountDown),
//                           iconSize: 25.0,
//                           color: Colors.black,
//                           onPressed: () => Navigator.pop(context),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Positioned(
//                 left: 20.0,
//                 bottom: 20.0,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       '${loadedProduct.title}',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 35.0,
//                         fontWeight: FontWeight.w600,
//                         letterSpacing: 1.2,
//                       ),
//                     ),
//                     // Row(
//                     //   children: <Widget>[
//                     //     Icon(
//                     //       FontAwesomeIcons.locationArrow,
//                     //       size: 15.0,
//                     //       color: Colors.white70,
//                     //     ),
//                     //     SizedBox(width: 5.0),
//                     //     Text(
//                     //       //widget.destination.country,
//                     //       'USA',
//                     //       style: TextStyle(
//                     //         color: Colors.white70,
//                     //         fontSize: 20.0,
//                     //       ),
//                     //     ),
//                     //   ],
//                     // ),
//                   ],
//                 ),
//               ),
//               // Positioned(
//               //   right: 20.0,
//               //   bottom: 20.0,
//               //   child: Icon(
//               //     Icons.location_on,
//               //     color: Colors.white70,
//               //     size: 25.0,
//               //   ),
//               // ),
//             ],
//           ),
//           Expanded(
//             child: ListView.builder(
//               padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
//               itemCount: 2,
//               itemBuilder: (BuildContext context, int index) {
//                 //   Activity activity = widget.destination.activities[index];
//                 return Stack(
//                   children: <Widget>[
//                     Container(
//                       margin: EdgeInsets.fromLTRB(40.0, 5.0, 20.0, 5.0),
//                       height: 170.0,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(20.0),
//                       ),
//                       child: Padding(
//                         padding: EdgeInsets.fromLTRB(100.0, 20.0, 20.0, 20.0),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Container(
//                                   width: 120.0,
//                                   child: Text(
//                                     //activity.name,
//                                     'Marcus',
//                                     style: TextStyle(
//                                       fontSize: 18.0,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                     overflow: TextOverflow.ellipsis,
//                                     maxLines: 2,
//                                   ),
//                                 ),
//                                 Column(
//                                   children: <Widget>[
//                                     Text(
//                                       '100,000',
//                                       style: TextStyle(
//                                         fontSize: 22.0,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                     Text(
//                                       'per pax',
//                                       style: TextStyle(
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             Text(
//                               //activity.type,
//                               'alpha',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             _buildRatingStars(5),
//                             SizedBox(height: 10.0),
//                             Row(
//                               children: <Widget>[
//                                 Container(
//                                   padding: EdgeInsets.all(5.0),
//                                   width: 70.0,
//                                   decoration: BoxDecoration(
//                                     color: Theme
//                                         .of(context)
//                                         .accentColor,
//                                     borderRadius: BorderRadius.circular(10.0),
//                                   ),
//                                   alignment: Alignment.center,
//                                   child: Text(
//                                     // activity.startTimes[0],
//                                       'beta'
//                                   ),
//                                 ),
//                                 SizedBox(width: 10.0),
//                                 Container(
//                                   padding: EdgeInsets.all(5.0),
//                                   width: 70.0,
//                                   decoration: BoxDecoration(
//                                     color: Theme
//                                         .of(context)
//                                         .accentColor,
//                                     borderRadius: BorderRadius.circular(10.0),
//                                   ),
//                                   alignment: Alignment.center,
//                                   child: Text(
//                                     // activity.startTimes[1],
//                                     'gamma',
//                                   ),
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       left: 20.0,
//                       top: 15.0,
//                       bottom: 15.0,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(20.0),
//                         child: Image(
//                           width: 110.0,
//                           image: NetworkImage(
//                             //  activity.imageUrl,
//                             loadedProduct.imageUrl0,
//                           ),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//Alt

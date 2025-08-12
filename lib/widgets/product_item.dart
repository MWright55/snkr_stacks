import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googleapis/appengine/v1.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:snkr_stacks/providers/product.dart';
import 'package:snkr_stacks/providers/products_provider.dart';
import 'package:snkr_stacks/providers/shippments_provider.dart';
import 'package:snkr_stacks/screens/product_detail_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

//import 'package:video_player/video_player.dart';
import 'package:snkr_stacks/providers/resources.dart' as Resources;
import '../shared/loading.dart';
import 'buttons.dart';

class ProductItem extends StatefulWidget {
  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  late Future<void> _future;

  //late VideoPlayerController _controller;
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool isVideo = false;

  @override
  void initState() {
    super.initState();
    _initialLoad(); // Call a helper that has context available
    final product = Provider.of<Product>(context, listen: false);

    //isVideo = product.imageUrl0.toLowerCase().endsWith('.mp4') || product.imageUrl0.contains('video');

    // if (isVideo) {
    //   _videoController = VideoPlayerController.networkUrl(Uri.parse(product.imageUrl0))
    //     //_videoController = VideoPlayerController.networkUrl(Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
    //     ..initialize().then((_) {
    //       _videoController?.setVolume(0.0); // 👈 Mute it here
    //       setState(() {});
    //
    //       _chewieController = ChewieController(
    //         videoPlayerController: _videoController!,
    //         autoPlay: true,
    //         looping: true,
    //         showControls: false,
    //         showControlsOnInitialize: false,
    //         aspectRatio: _videoController!.value.aspectRatio,
    //       );
    //     });
    // }
  } //End initState

  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _refreshProducts() async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  Future<void> _initialLoad() async {
    await Future.delayed(Duration.zero); // ensures context is ready
    return _refreshProducts();
  }

  @override
  Widget build(BuildContext context) {
    //print('Now in product_item');
    final product = Provider.of<Product>(context, listen: false);

    bool? _information = false;
    // bool _information;

    // Future<void> _refreshProducts(BuildContext context) async {
    //   await Provider.of<Shippments>(context, listen: false).fetchAndSetOrders();
    // }

    void updateInformation(information) {
      setState(() => _information = information);
    }

    // _goToDetails(String holder) async {
    //   final information = await Navigator.of(context).pushNamed(ProductDetailScreen.routeName, arguments: product.id);
    //   updateInformation(information);
    //
    //   print("_information on Product_item: $_information");
    //   if (_information == true) {
    //     _refreshProducts(context);
    //     await Future.delayed(Duration(milliseconds: 250));
    //
    //     // Delete product from feed
    //     print("==>Deleting Product from feed<==");
    //     print("==> calling deleteProduct from product_item");
    //     //Provider.of<Products>(context, listen: false).deleteProduct(product.id, product.imageUrl0);
    //   } else {
    //     _refreshProducts(context);
    //   }
    // }

    Future<void> _goToDetails(String holder) async {
      final didChange = await Navigator.of(context).pushNamed(ProductDetailScreen.routeName, arguments: product.id);

      print("_information on Product_item: $didChange");

      if (didChange == true) {
        await _refreshProducts(); // only refresh if something changed
        await Future.delayed(Duration(milliseconds: 250));
        print("==> Deleting Product from feed <==");
      }
    }

    return Container(
      child: Hero(
        tag: product.id,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          // child: Hero(
          //   tag: product.id,
          child: GestureDetector(
            onTap: () {
              //onDoubleTap: () {
              _goToDetails(product.id);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),

              child: Stack(
                children: [
                  // isVideo
                  //     ? _videoController != null && _videoController!.value.isInitialized
                  //           ? Chewie(controller: _chewieController!)
                  //           : Center(child: CircularProgressIndicator())
                  //     : FadeInImage.memoryNetwork(
                  //         height: MediaQuery.of(context).size.height * .90,
                  //         width: MediaQuery.of(context).size.width,
                  //         fit: BoxFit.cover,
                  //         placeholder: kTransparentImage,
                  //         image: product.imageUrl0,
                  //       ),
                  isVideo
                      ? _videoController != null && _videoController!.value.isInitialized
                            ? Container(
                                height: MediaQuery.of(context).size.height * 0.90,
                                width: MediaQuery.of(context).size.width,
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.width / _videoController!.value.aspectRatio,
                                    child: Chewie(controller: _chewieController!),
                                  ),
                                ),
                              )
                            : Center(child: Loading())
                      : FadeInImage.memoryNetwork(
                          height: MediaQuery.of(context).size.height * .90,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                          placeholder: kTransparentImage,
                          image: product.imageUrls.isNotEmpty ? product.imageUrls.first : 'assets/images/placeholder.png',
                        ),
                  Container(
                    /*LinearGradient [Vertical]*/
                    // decoration: BoxDecoration(
                    //   gradient: LinearGradient(
                    //     colors: [
                    //       Colors.transparent,
                    //       Colors.transparent,
                    //       Colors.black12,
                    //       Colors.black38,
                    //     ],
                    //     stops: [0.0, 0.2, 0.8, 1.0],
                    //   ),
                    // ),
                    /*LinearGradient [Vertical]*/
                    /*RadialGradient [Circular]*/
                    decoration: BoxDecoration(gradient: RadialGradient(radius: 3.5, colors: [Colors.transparent, Colors.black87])),
                    /*RadialGradient [Circular]*/
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        alignment: Alignment(-1, 1),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: product.description,
                                    //style: TextStyle(
                                    style: GoogleFonts.bebasNeue(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: product.description,
                                    //style: TextStyle(
                                    style: GoogleFonts.bebasNeue(
                                      color: Colors.white,
                                      //fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// buttons
                  Container(
                    alignment: Alignment(1, 1),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyButton(icon: Icons.attach_money, number: product.price.toStringAsFixed(2)),
                          MyButton(icon: Icons.checkroom, number: product.type),
                          MyButton(icon: Icons.new_releases_outlined, number: product.status),
                          MyButton(icon: Icons.straighten_outlined, number: product.size),
                        ],
                      ),
                    ),
                  ),

                  /// buttons
                ],
              ),
            ),
          ),
          //  ),
        ),
      ),
    );

    /*Code below is for tik tok view*/
  }
}

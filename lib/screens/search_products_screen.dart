import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:snkr_stacks/providers/products_provider.dart';
import 'package:snkr_stacks/screens/product_detail_screen.dart';
import '../providers/products_provider.dart';
import '../providers/shippments_provider.dart';
import '../responsive/dimensions.dart';

@override
class Model {
  String id;
  String name;
  String title;
  String imageUrl;
  String size;

  Model({required this.id, required this.name, required this.title, required this.imageUrl, required this.size});
}

class SearchProductsScreen extends StatefulWidget {
  static const routeName = '/search-products';

  SearchProductsScreen({Key? key}) : super(key: key);

  @override
  _SearchProductsScreenState createState() => _SearchProductsScreenState();
}

class Debouncer {
  final int milliseconds;
  late VoidCallback action;
  late Timer _timer = Timer(Duration(milliseconds: 1), () {});

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (!_timer.isActive) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _SearchProductsScreenState extends State<SearchProductsScreen> {
  Widget appBarTitle = Text("Search", style: TextStyle(color: Colors.black));
  Icon actionIcon = Icon(Icons.search, color: Colors.black);
  final key = GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = TextEditingController();
  late List<Model> _list;
  List<Model> _searchProductsScreen = [];
  final _debouncer = Debouncer(milliseconds: 200);
  bool _showBackToTopButton = false;
  late ScrollController _scrollController;

  //bool _isSearching;
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController.offset >= 1500) {
            _showBackToTopButton = true; // show the back-to-top button
          } else {
            _showBackToTopButton = false; // hide the back-to-top button
          }
        });
      });
    init();
    print('**Now in search_products_screen');
    print('SystemTime: ${DateTime.now()}');
    // print ('::> offset counter ::> ${_scrollController.offset}');
  }

  @override
  void dispose() {
    _scrollController.dispose(); // dispose the controller
    super.dispose();
  }

  // This function is triggered when the user presses the back-to-top button
  void _scrollToTop() {
    _scrollController.animateTo(0, duration: Duration(milliseconds: 1000), curve: Curves.ease);
  }

  Future<void> _refreshFeed(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
    init();
  }

  void init() {
    //Create Empty List and attach listener
    _list = [];
    _searchProductsScreen = _list;
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          //  _isSearching = false;
          _searchText = "";
          _buildSearchProductsScreen();
        });
      } else {
        setState(() {
          //   _isSearching = true;
          _searchText = _searchQuery.text;
          _buildSearchProductsScreen();
        });
      }
    });
  }

  // void listAdd() {
  //   final productsCount = Provider.of<Products>(context);
  //   _list.clear();
  //
  //   for (var x = 0; x < productsCount.items.length; x++) {
  //     _list.add(
  //       Model(
  //         id: productsCount.items[x].id,
  //         name: productsCount.items[x].title,
  //         title: productsCount.items[x].description,
  //         imageUrl: productsCount.items[x].imageUrl0,
  //         size: productsCount.items[x].size,
  //       ),
  //     );
  //   }
  // }

  void listAdd() {
    final productsCount = Provider.of<Products>(context);
    _list.clear();

    for (var x = 0; x < productsCount.items.length; x++) {
      _list.add(
        Model(
          id: productsCount.items[x].id,
          name: productsCount.items[x].title,
          title: productsCount.items[x].description,
          imageUrl: productsCount.items[x].imageUrls.isNotEmpty ? productsCount.items[x].imageUrls.first : 'assets/images/placeholder.png',
          size: productsCount.items[x].size,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    listAdd();
    //final productsData = Provider.of<Products>(context);

    // if (MediaQuery.of(context).size.width < mobileWidth) {
    //--mobile--
    return Scaffold(
      backgroundColor: Colors.white,
      key: key,
      appBar: PreferredSize(preferredSize: Size.fromHeight(50.0), child: buildBar(context)),
      body: _searchProductsScreen.length == 0
          ? Center(
              child: Text(
                ' No Products Posted',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
              ),
            )
          : RefreshIndicator(
              onRefresh: () => _refreshFeed(context),
              child: GridView.builder(
                controller: _scrollController,
                key: PageStorageKey<String>('searchPage'),
                itemCount: _searchProductsScreen.length,
                //itemCount: productsData.items.length,
                itemBuilder: (context, index) {
                  return GridItem(_searchProductsScreen[index]);
                },
                // 2 Row view
                // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //   crossAxisCount: 2,
                // ),
                // 2 Row view
                // Quilted View
                gridDelegate: SliverQuiltedGridDelegate(
                  crossAxisCount: 3,
                  // mainAxisSpacing: 1,
                  //crossAxisSpacing: 1,
                  repeatPattern: QuiltedGridRepeatPattern.inverted,
                  pattern: [QuiltedGridTile(2, 1), QuiltedGridTile(1, 1), QuiltedGridTile(1, 1), QuiltedGridTile(1, 1), QuiltedGridTile(1, 1)],
                ),
                // Quilted View
              ),
            ),
      floatingActionButton: _showBackToTopButton == false
          ? null
          : FloatingActionButton(
              onPressed: _scrollToTop,
              child: Icon(Icons.arrow_upward, color: Colors.white),
              //backgroundColor: Colors.grey[600],
              ///Accent Color
              backgroundColor: Theme.of(context).colorScheme.tertiary,
            ),
    );
    //   }
    //   else if (MediaQuery.of(context).size.width < tabletWidth) {
    //     //--tablet--
    //     return Scaffold(
    //       backgroundColor: Colors.white,
    //       key: key,
    //       appBar: PreferredSize(preferredSize: Size.fromHeight(50.0), child: buildBar(context)),
    //       body: _searchProductsScreen.length == 0
    //           ? Center(
    //               child: Text(
    //                 ' No Products Posted',
    //                 textAlign: TextAlign.center,
    //                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
    //               ),
    //             )
    //           : RefreshIndicator(
    //               onRefresh: () => _refreshFeed(context),
    //               child: GridView.builder(
    //                 controller: _scrollController,
    //                 key: PageStorageKey<String>('searchPage'),
    //                 itemCount: _searchProductsScreen.length,
    //                 //itemCount: productsData.items.length,
    //                 itemBuilder: (context, index) {
    //                   return GridItem(_searchProductsScreen[index]);
    //                 },
    //                 gridDelegate: SliverQuiltedGridDelegate(
    //                   crossAxisCount: 3,
    //                   repeatPattern: QuiltedGridRepeatPattern.inverted,
    //                   pattern: [QuiltedGridTile(2, 1), QuiltedGridTile(1, 1), QuiltedGridTile(1, 1), QuiltedGridTile(1, 1), QuiltedGridTile(1, 1)],
    //                 ),
    //                 // Quilted View
    //               ),
    //             ),
    //       floatingActionButton: _showBackToTopButton == false
    //           ? null
    //           : FloatingActionButton(
    //               onPressed: _scrollToTop,
    //               child: Icon(Icons.arrow_upward, color: Colors.white),
    //
    //               ///Accent Color
    //               backgroundColor: Theme.of(context).colorScheme.tertiary,
    //             ),
    //     );
    //   } else {
    //     //--desktop--
    //     return Scaffold(
    //       backgroundColor: Colors.white,
    //       key: key,
    //       appBar: PreferredSize(preferredSize: Size.fromHeight(50.0), child: buildBar(context)),
    //       body: _searchProductsScreen.length == 0
    //           ? Center(
    //               child: Text(
    //                 ' No Products Posted',
    //                 textAlign: TextAlign.center,
    //                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
    //               ),
    //             )
    //           : RefreshIndicator(
    //               onRefresh: () => _refreshFeed(context),
    //               child: GridView.builder(
    //                 controller: _scrollController,
    //                 key: PageStorageKey<String>('searchPage'),
    //                 itemCount: _searchProductsScreen.length,
    //                 //itemCount: productsData.items.length,
    //                 itemBuilder: (context, index) {
    //                   return GridItem(_searchProductsScreen[index]);
    //                 },
    //                 gridDelegate: SliverQuiltedGridDelegate(
    //                   crossAxisCount: 5,
    //                   repeatPattern: QuiltedGridRepeatPattern.inverted,
    //                   pattern: [
    //                     QuiltedGridTile(2, 2),
    //                     QuiltedGridTile(2, 1),
    //                     QuiltedGridTile(1, 1),
    //                     QuiltedGridTile(1, 1),
    //                     QuiltedGridTile(1, 2),
    //                     //QuiltedGridTile(1, 1),
    //                   ],
    //                 ),
    //                 // Quilted View
    //               ),
    //             ),
    //       floatingActionButton: _showBackToTopButton == false
    //           ? null
    //           : FloatingActionButton(
    //               onPressed: _scrollToTop,
    //               child: Icon(Icons.arrow_upward, color: Colors.white),
    //
    //               ///Accent Color
    //               backgroundColor: Theme.of(context).colorScheme.tertiary,
    //             ),
    //     );
    //   }
  }

  List<Model>? _buildSearchProductsScreen() {
    if (_searchText.isEmpty) {
      return _searchProductsScreen = _list;
    } else {
      _debouncer.run(() {
        _searchProductsScreen = _list
            .where(
              (element) =>
                  element.name.toLowerCase().contains(_searchText.toLowerCase()) ||
                  element.title.toLowerCase().contains(_searchText.toLowerCase()) ||
                  element.size.toLowerCase().contains(_searchText.toLowerCase()),
            )
            .toList();
        print('**Lenght${_searchProductsScreen.length}');

        _searchProductsScreen;
      });
    }
    return null;
  }

  Widget buildBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 50,
      centerTitle: true,
      title: appBarTitle,
      //elevation: 5,
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      actions: <Widget>[
        IconButton(
          icon: actionIcon,
          onPressed: () {
            setState(() {
              if (this.actionIcon.icon == Icons.search) {
                this.actionIcon = Icon(Icons.close, color: Colors.black);
                this.appBarTitle = TextField(
                  controller: _searchQuery,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Search here..",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                );
                _handleSearchStart();
              } else {
                _handleSearchEnd();
              }
            });
          },
        ),
      ],
    );
  }

  void _handleSearchStart() {
    setState(() {
      //_isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = Icon(Icons.search, color: Colors.black);
      this.appBarTitle = Text("Search", style: TextStyle(color: Colors.white));
      // _isSearching = false;
      _searchQuery.clear();
    });
  }
}

class GridItem extends StatefulWidget {
  final Model model;

  GridItem(this.model);

  @override
  State<GridItem> createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  bool? _information = false;

  void updateInformation(information) {
    setState(() => _information = information);
  }

  Widget build(BuildContext context) {
    //final productsData = Provider.of<Products>(context);
    // return Container(
    //   height: 250,
    //   //width: double.infinity,
    //   child: Card(
    //     margin: EdgeInsets.fromLTRB(5, 5, 5, 7),
    //     elevation: 10.0,
    //     //child: InkWell(
    //     // splashColor: Colors.orange,
    //     // onTap: () {
    //     //   print(model.id);
    //     // },
    //     child: ClipRRect(
    //       borderRadius: BorderRadius.circular(10.0),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: <Widget>[
    //           AspectRatio(
    //             //aspectRatio: 18.0 / 11.0,
    //             aspectRatio: (4 / 3),
    //             child: GestureDetector(
    //               onDoubleTap: () {
    //                 //onLongPress: () {
    //                 Navigator.of(context).pushNamed(
    //                     ProductDetailScreen.routeName,
    //                     arguments: this.model.id);
    //               },
    //               child: Image.network(
    //                 this.model.imageUrl,
    //                 fit: BoxFit.fitWidth,
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //     // ),
    //   ),
    // );

    return Container(
      child: Hero(
        tag: this.widget.model.id,
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          margin: EdgeInsets.fromLTRB(5, 5, 5, 7),
          //elevation: 10.0,
          child: GridTile(
            child: GestureDetector(
              onTap: () {
                //Navigator.of(context).pushNamed(ProductDetailScreen.routeName, arguments: this.model.id);
                _goToDetails(this);
                print("*** back from checkout out ***");
              },
              child: FadeInImage.memoryNetwork(fadeInDuration: Duration(milliseconds: 50), placeholder: kTransparentImage, image: this.widget.model.imageUrl, fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }

  _goToDetails(_GridItemState holder) async {
    print("now in _goToDetails: value of holder => $holder");

    final information = await Navigator.of(context).pushNamed(ProductDetailScreen.routeName, arguments: holder.widget.model.id);
    updateInformation(information);

    print("_information on Product_item: $_information");
    if (_information == true) {
      _refreshProducts(context);
      await Future.delayed(Duration(milliseconds: 250));

      // Delete product from feed
      print("==>Deleting Product from search feed<==");
      print("==> calling deleteProduct from search_product_screen");
      Provider.of<Products>(context, listen: false).deleteProduct(holder.widget.model.id, holder.widget.model.imageUrl);
    } else {
      _refreshProducts(context);
    }
  }

  Future<void> _refreshProducts(BuildContext context) async {
    //await Provider.of<Shippments>(context, listen: false).fetchAndSetOrders();
  }
}

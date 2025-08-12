import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:snkr_stacks/providers/products_provider.dart';

import 'edit_product_screen.dart';

//import 'edit_product_screen_OG.dart';
//import 'package:snkr_stacks/screens/edit_product_screen.dart';

@override
class Model {
  String id;
  String name;
  String title;
  String imageUrl;
  String size;
  String sku;

  Model({required this.id, required this.name, required this.title, required this.imageUrl, required this.size, required this.sku});
}

class UserProductsScreen extends StatefulWidget {
  static const routeName = '/user-products';

  UserProductsScreen({Key? key}) : super(key: key);

  @override
  _UserProductsScreenState createState() => _UserProductsScreenState();
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

class _UserProductsScreenState extends State<UserProductsScreen> {
  Widget appBarTitle = Text("Posted Products", style: TextStyle(color: Colors.black));
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
          if (_scrollController.offset >= 1250) {
            _showBackToTopButton = true; // show the back-to-top button
          } else {
            _showBackToTopButton = false; // hide the back-to-top button
          }
        });
      });
    init();
    print('**Done with initState() in user_products_screen**');
    print('SystemTime: ${DateTime.now()}');
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

  void init() {
    //Create Empty List and attach listener
    _list = [];

    _searchProductsScreen = _list;
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          //_isSearching = false;
          _searchText = "";
          _buildSearchProductsScreen();
        });
      } else {
        setState(() {
          // _isSearching = true;
          _searchText = _searchQuery.text;
          _buildSearchProductsScreen();
        });
      }
    });
  }

  void listAdd() {
    final productsCount = Provider.of<Products>(context);
    _list.clear();

    for (var x = 0; x < productsCount.items.length; x++) {
      //print('**productsCount**:: ${productsCount.items.length}');
      _list.add(
        Model(
          id: productsCount.items[x].id,
          name: productsCount.items[x].title,
          title: productsCount.items[x].description,
          imageUrl: productsCount.items[x].imageUrls.isNotEmpty ? productsCount.items[x].imageUrls.first : 'assets/images/placeholder.png',
          size: productsCount.items[x].size,
          sku: productsCount.items[x].sku,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    listAdd();

    return Scaffold(
      backgroundColor: Colors.white,
      key: key,
      appBar: PreferredSize(preferredSize: Size.fromHeight(50.0), child: buildBar(context)),
      body: _searchProductsScreen.length == 0
          ? Center(
              child: Text(
                ' User Products Is Empty',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
              ),
            )
          : ListView.builder(
              controller: _scrollController,
              key: PageStorageKey<String>('userPage'),
              itemCount: _searchProductsScreen.length,
              //itemCount: productsData.items.length,
              itemBuilder: (context, index) {
                return GridItem(_searchProductsScreen[index]);
              },
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
                  element.sku.toLowerCase().contains(_searchText.toLowerCase()),
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
      //elevation: 5,
      leading: GestureDetector(
        onTap: () {
          // print('add product');
          // Navigator.of(context).pushNamed(EditProductScreen.routeName);
          print('add product OG');
          //Navigator.of(context).pushNamed(EditProductScreenOG.routeName);
        },
        child: Icon(Icons.add_circle_outline, color: Colors.black),
      ),
      centerTitle: true,
      title: appBarTitle,
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
    setState(() {});
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = Icon(Icons.search, color: Colors.black);
      this.appBarTitle = Text("Posted Products", style: TextStyle(color: Colors.white));
      _searchQuery.clear();
    });
  }
}

class GridItem extends StatelessWidget {
  final Model model;

  GridItem(this.model);

  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(this.model.id),
      background: Container(
        color: Colors.red,
        child: Icon(Icons.delete, color: Colors.white, size: 35),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Delete Item?', textAlign: TextAlign.center),
            content: Text('Do you want to delete item from current Inventory?'),
            actions: <Widget>[
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              TextButton(
                child: Text('Yes', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (directions) async {
        try {
          await Provider.of<Products>(context, listen: false).deleteProduct(this.model.id, this.model.imageUrl);
        } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Deleting Item Failed', textAlign: TextAlign.center),
              backgroundColor: Colors.red,
            ),
          );
        }
        //delete
      },
      child: Container(
        child: Hero(
          tag: this.model.id,
          child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            margin: EdgeInsets.fromLTRB(5, 5, 5, 7),
            //elevation: 10.0,
            child: GridTile(
              child: GestureDetector(
                onTap: () {
                  //Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: this.model.id);
                },
                child: Stack(
                  children: [
                    FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      fadeInDuration: Duration(milliseconds: 800),
                      image: this.model.imageUrl,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 26,
                      right: 8,
                      left: 8,
                      child: Text(
                        this.model.name,
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      left: 8,
                      child: Text('SKU: ${this.model.sku}', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

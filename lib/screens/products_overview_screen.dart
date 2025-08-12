import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:snkr_stacks/providers/products_provider.dart';
import 'package:snkr_stacks/widgets/products_feed.dart';
import 'package:snkr_stacks/shared/loading.dart';
import 'package:snkr_stacks/services/auth.dart';
import 'package:snkr_stacks/providers/resources.dart' as Resources;

enum FilterOptions { Favorites, All, Logout, FAQ }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> with WidgetsBindingObserver {
  final AuthService _auth = AuthService();
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  ///log out after inactivity/detached
  // @override
  // Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
  //   super.didChangeAppLifecycleState(state);
  //
  //   //if (state == AppLifecycleState.inactive || state == AppLifecycleState.detached){
  //   if (state == AppLifecycleState.paused){
  //     await _auth.signOut();
  //   }
  //
  // }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Image.asset(Resources.LOGO, fit: BoxFit.cover, height: 40),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: (FilterOptions selectedValue) async {
                print(selectedValue);
                setState(() {
                  // if (selectedValue == FilterOptions.Favorites) {
                  //   _showOnlyFavorites = true;
                  // }
                  if (selectedValue == FilterOptions.Logout) {
                    print(':: Sign Out Pressed ::');
                    _auth.signOut();
                    print(FirebaseAuth.instance.currentUser);
                    print(':: Sign Out Pressed done ::');
                  } else {
                    _showOnlyFavorites = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.exit_to_app_outlined, color: Colors.black),
                      ),
                      Text('Log Out', style: TextStyle(fontFamily: GoogleFonts.bebasNeue().fontFamily, fontSize: 18.0)),
                    ],
                  ),
                  value: FilterOptions.Logout,
                ),
              ],
            ),
          ],
        ),
      ),
      body: _isLoading ? Loading() : ProductsFeed(_showOnlyFavorites),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:snkr_stacks/providers/resources.dart' as Resources;

//import '../models/user.dart';
import 'package:snkr_stacks/screens/delete_account_screen.dart';
import 'package:snkr_stacks/screens/faq_screen.dart';

import '../main.dart';
import '../services/shopify_service.dart';

enum FilterOptions { FAQ, deleteAccount }

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile-screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User? _user;
  String userName = 'Loading User';

  @override
  void initState() {
    print('**Now in porfile_screen**');
    print('SystemTime: ${DateTime.now()}');
    _getCurrentUser();
    super.initState();
    //_getCurrentUser(_user);

    // print("$_user");
  }

  //void _getCurrentUser(FirebaseUser _user) async {
  _getCurrentUser() async {
    // FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    _user = FirebaseAuth.instance.currentUser!;
    //print("currentUser::::!!!> ${_user.uid}");
    //print("currentUser::::!!!> ${_user.email}");
    if (_user != null) {
      setState(() {
        this._user = _user;
      });
    } else {
      //do something
    }
    //return _user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(
      //     Icons.monetization_on,
      //     color: Colors.white,
      //   ),
      //   //backgroundColor: Colors.grey[600],
      //   backgroundColor: Colors.amber,
      //   onPressed: () async {
      //     print("Testing for Refund");
      //     try {
      //       var response =
      //           await http.post(Uri.parse('https://api.stripe.com/v1/refunds'),
      //               //body: body,
      //               headers: {
      //             'Authorization':
      //                 'Bearer sk_test_51IN2IzCOjsikW1onnHc8MZhbHI4VSglHy5tr9bvMYPwwFntOyNsnepdULcEj1D78bQZwZbZEhqTar3SsFyQANNh400hZCwICdd',
      //             'Content-Type': 'application/x-www-form-urlencoded'
      //           });
      //       print('***Create Intent reponse ===> ${response.body.toString()}');
      //       //return jsonDecode(response.body);
      //     } catch (err) {
      //       print('err charging user: ${err.toString()}');
      //     }
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.sync),
        onPressed: () async {
          print('🟡 Starting multi-store scrape from Firebase config...');
          try {
            final service = ShopifyService(
              storeUrl: '', // Placeholder; will be overridden per store
              accessToken: '',
              storefrontToken: '',
            );
            await service.runScraperForAllStores();
            print('✅ Multi-store sync complete!');
          } catch (e) {
            print('❌ Failed to run multi-store scraper: $e');
          }
        },
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        //backgroundColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) async {
              print(selectedValue);
              setState(() {
                if (selectedValue == FilterOptions.FAQ) {
                  print("FAQ Selected");
                  Navigator.of(context).pushNamed(FAQScreen.routeName);
                }
                if (selectedValue == FilterOptions.deleteAccount) {
                  print("Delete Account Selected");
                  Navigator.of(context).pushNamed(DeleteAccountScreen.routeName);
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
                      child: Icon(Icons.question_answer_outlined, color: Colors.black),
                    ),
                    Text('FAQ', style: TextStyle(fontSize: 18.0)),
                  ],
                ),
                value: FilterOptions.FAQ,
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.delete_forever_outlined, color: Colors.black),
                    ),
                    Text('Delete Account', style: TextStyle(fontSize: 18.0)),
                  ],
                ),
                value: FilterOptions.deleteAccount,
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: Future.value(FirebaseAuth.instance.currentUser),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData) {
            //return Text(snapshot.data.uid);
            return ListView(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Hero(
                      tag: 'assets/chris.jpg',
                      child: Container(
                        height: 125.0,
                        width: 125.0,
                        decoration: BoxDecoration(
                          // border: Border.all(
                          //   color: Theme.of(context).colorScheme.primary,
                          //   width: 2.0,
                          // ),
                          borderRadius: BorderRadius.circular(62.5),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            //image: AssetImage('./assets/images/vg.png'),
                            image: AssetImage(Resources.LOGO),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Text(
                      _user!.uid == null ? 'Loading User' : '${_user!.displayName}',
                      style: TextStyle(
                        fontFamily: GoogleFonts.bebasNeue().fontFamily,
                        fontSize: 30.0,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      _user!.uid == null ? 'Loading User' : '${_user!.email}',
                      style: TextStyle(fontFamily: GoogleFonts.bebasNeue().fontFamily, fontSize: 26, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return Text('Loading...');
          }
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
// class ProfileScreen extends StatefulWidget {
//   static const routeName = '/profile-screen';
//
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//       _counter += 1;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(colors: [Color(0xFF00C6FF), Color(0xFF0072FF)], begin: Alignment.topLeft, end: Alignment.bottomRight),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 'Gradient Background Page',
//                 style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 20),
//               Text('Button tapped $_counter times', style: const TextStyle(fontSize: 18, color: Colors.white)),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _incrementCounter,
//                 child: const Text('Tap Me'),
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.blue),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

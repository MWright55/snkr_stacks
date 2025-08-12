// ///checkout scratch -> auto complete api
//
// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
// import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
// import 'package:get/get.dart';
//
// //import 'package:flutter_stripe_web/flutter_stripe_web.dart' as stripe_web;
// import 'package:google_fonts/google_fonts.dart';
// import 'package:googleapis/places/v1.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:uuid/uuid.dart';
// import 'package:snkr_stacks/providers/product.dart';
// import 'package:snkr_stacks/providers/products_provider.dart';
// import 'package:snkr_stacks/providers/resources.dart' as Resources;
// import 'package:flutter/foundation.dart';
// import '../providers/Fee.dart';
// import '../responsive/dimensions.dart';
//
// //import 'package:web/web.dart' as web;
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class ProductCheckoutScreen extends StatefulWidget {
//   static const routeName = '/product-checkout';
//
//   @override
//   _ProductCheckoutScreenState createState() => _ProductCheckoutScreenState();
// }
//
// class _ProductCheckoutScreenState extends State<ProductCheckoutScreen> {
//   final _shipNameFocusNode = FocusNode();
//   final _addressFocusNode = FocusNode();
//   final _cityFocusNode = FocusNode();
//   final _stateFocusNode = FocusNode();
//   final _zipFocusNode = FocusNode();
//   final _phoneFocusNode = FocusNode();
//   final _form = GlobalKey<FormState>();
//   late Map<String, dynamic> paymentIntentData;
//   late Map<String, dynamic> transferIntentData;
//   late Map<String, dynamic> confirmIntentData;
//   late User? _user;
//   late var _searchAddress = TextEditingController(text: "");
//   var uuid = const Uuid();
//   final String token = '1234567890';
//   final String special_value = '';
//   var isWeb = kIsWeb;
//   bool _isProcessing = false;
//
//   Fee? _feeDB;
//
//   //bool _isLoadingFee = true;
//
//   List<dynamic> listOfLocation = [];
//
//   final databaseRef = FirebaseDatabase.instance.ref();
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentUser();
//     _searchAddress.addListener(() {
//       _onChange();
//     });
//     _loadFee();
//   }
//
//   // Future<Fee> fetchFee(String businessId) async {
//   //   final snap = await FirebaseDatabase.instance.ref('fees/$businessId').get();
//   //
//   //   if (!snap.exists) throw Exception('Fee not found');
//   //
//   //   final data = snap.value as Map<dynamic, dynamic>;
//   //   print("type: ${data['feeType']}");
//   //   print("value: ${data['feeValue']}");
//   //
//   //   return Fee(type: data['feeType'] as String, value: (data['feeValue'] as num).toDouble());
//   // }
//
//   Future<Fee> fetchFeeViaRest(String businessId) async {
//     final url = 'https://shoppr-dcf99-51801.firebaseio.com/fees/$businessId.json';
//     final response = await http.get(Uri.parse(url));
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data == null) throw Exception('No data');
//       print("type: ${data['feeType']}");
//       print("value: ${data['feeValue']}");
//       return Fee(type: data['feeType'], value: (data['feeValue'] as num).toDouble());
//     } else {
//       throw Exception('Failed to fetch fee: ${response.statusCode}');
//     }
//   }
//
//   Future<void> _loadFee() async {
//     try {
//       print('Resources.BIZ_KEY: ${Resources.BIZ_KEY}');
//       final fee = await fetchFeeViaRest(Resources.BIZ_KEY); // Your async function returning Fee
//       // final fee = await fetchFee(Resources.BIZ_KEY); // Your async function returning Fee
//       setState(() {
//         _feeDB = fee;
//         //_isLoadingFee = false;
//       });
//     } catch (e) {
//       print('Error loading fee: $e');
//       setState(() {
//         _feeDB = Fee(type: 'flat', value: 0); // Fallback
//         //_isLoadingFee = false;
//       });
//     }
//   }
//
//   _onChange() {
//     placeSuggestion(_searchAddress.text);
//   }
//
//   void placeSuggestion(String input) async {
//     const String apiKey = Resources.PLACE_API_KEY;
//
//     ///for api key from google
//
//     try {
//       String bassedUrl = Resources.PLACE_URL;
//       String request = '$bassedUrl?input=$input&key=$apiKey&sessiontoken=$token';
//       final response = await http.get(Uri.parse(request));
//       final data = json.decode(response.body);
//
//       if (kDebugMode) {
//         print(data);
//       }
//       if (response.statusCode == 200) {
//         setState(() {
//           listOfLocation = json.decode(response.body)['predictions'];
//         });
//       } else {}
//       throw Exception("Fail to load");
//     } catch (e) {
//       print(e.toString());
//     }
//   }
//
//   @override
//   void dispose() {
//     _shipNameFocusNode.dispose();
//     _addressFocusNode.dispose();
//     _cityFocusNode.dispose();
//     _zipFocusNode.dispose();
//     _phoneFocusNode.dispose();
//     _stateFocusNode.dispose();
//     super.dispose();
//   }
//
//   String _generatePurchasetag(int lengthOfString) {
//     final random = Random();
//
//     const allChars = 'AaBbCcDdlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1EeFfGgHhIiJjKkL234567890';
//     // below statement will generate a random string of length using the characters
//     // and length provided to it
//     final randomString = List.generate(lengthOfString, (index) => allChars[random.nextInt(Resources.ALL_CHARS.length)]).join();
//     return randomString; // return the generated string
//   }
//
//   _getCurrentUser() async {
//     // FirebaseUser _user = await FirebaseAuth.instance.currentUser();
//     _user = FirebaseAuth.instance.currentUser!;
//     //print("currentUser::::!!!> ${_user?.uid}");
//     //print("currentUser::::!!!> ${_user.email}");
//     if (_user != null) {
//       setState(() {
//         this._user = _user;
//       });
//     } else {
//       //do something
//     }
//     //return _user;
//   }
//
//   var currentState;
//   final _statesList = [
//     'AL',
//     'AK',
//     'AZ',
//     'AR',
//     'CA',
//     'CO',
//     'CT',
//     'DE',
//     'FL',
//     'GA',
//     'HI',
//     'ID',
//     'IL',
//     'IN',
//     'IA',
//     'KS',
//     'KY',
//     'LA',
//     'ME',
//     'MD',
//     'MA',
//     'MI',
//     'MN',
//     'MS',
//     'MO',
//     'MT',
//     'NE',
//     'NV',
//     'NH',
//     'NJ',
//     'NM',
//     'NY',
//     'NC',
//     'ND',
//     'MP',
//     'OH',
//     'OK',
//     'OR',
//     'PA',
//     'PR',
//     'RI',
//     'SC',
//     'SD',
//     'TN',
//     'TX',
//     'UT',
//     'VT',
//     'VA',
//     'VI',
//     'WA',
//     'WV',
//     'WI',
//     'WY',
//   ];
//
//   // var _state = 'AL';
//
//   var _purchasedProduct = Product(
//     // id: null,
//     id: '',
//     title: '',
//     price: 0,
//     description: '',
//     imageUrl0: '',
//     shippingName: '',
//     status: '',
//     shippingZip: '',
//     shippingPhone: '',
//     type: '',
//     poster: '',
//     shippingCity: '',
//     size: '',
//     imageUrl2: '',
//     imageUrl1: '',
//     shippingAddress: '',
//     shippingState: '',
//     buyer: '',
//     shippingEmail: '',
//     sku: '',
//     postertimeStamp: '',
//     buyertimeStamp: '',
//     piToken: '',
//   );
//
//   var _initValues = {
//     'title': '',
//     'description': '',
//     'price': '',
//     'imageUrl0': '',
//     'sku': '',
//     'status': '',
//     'type': '',
//     'size': '',
//     'shippingName': '',
//     'shippingAddress': '',
//     'shippingCity': '',
//     'shippingState': '',
//     'shippingZip': '',
//     'shippingPhone': '',
//     'shippingEmail': '',
//     'postertimeStamp': '',
//     'poster': '',
//   };
//
//   void _saveForm() {
//     setState(() {
//       _purchasedProduct = Product(
//         title: _purchasedProduct.title,
//         price: _purchasedProduct.price,
//         description: _purchasedProduct.description,
//         imageUrl0: _purchasedProduct.imageUrl0,
//         id: _purchasedProduct.id,
//         isFavorite: _purchasedProduct.isFavorite,
//         sku: _purchasedProduct.sku,
//         status: _purchasedProduct.status,
//         type: _purchasedProduct.type,
//         size: _purchasedProduct.size,
//         shippingName: _purchasedProduct.shippingName,
//         shippingAddress: _purchasedProduct.shippingAddress,
//         shippingCity: _purchasedProduct.shippingCity,
//         shippingState: _purchasedProduct.shippingState,
//         shippingZip: _purchasedProduct.shippingZip,
//         shippingPhone: _purchasedProduct.shippingPhone,
//         shippingEmail: _purchasedProduct.shippingEmail,
//         poster: _purchasedProduct.poster,
//         postertimeStamp: _purchasedProduct.postertimeStamp,
//         imageUrl2: '',
//         imageUrl1: '',
//         buyer: this._user!.email.toString() + ' ::> ' + this._user!.uid.toString(),
//         buyertimeStamp: DateTime.now().toIso8601String(),
//         piToken: _purchasedProduct.piToken,
//       );
//     });
//     final isValid = _form.currentState!.validate();
//
//     print('***Now in !isValid');
//
//     if (!isValid) {
//       print('***Now in !isValid !!!!');
//       return;
//     } else {
//       print('***Now in isValid !!!!');
//       _form.currentState!.save();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_feeDB == null) {
//       return Scaffold(
//         body: Center(child: CircularProgressIndicator()), // show loading while fee loads
//       );
//     }
//
//     final feeType = _feeDB!.type;
//     final feeValue = _feeDB!.value;
//
//     final productID = ModalRoute.of(context)!.settings.arguments as String; //is the id
//     final loadedProduct = Provider.of<Products>(context, listen: false).items.firstWhereOrNull((prod) => prod.id == productID);
//
//     if (loadedProduct == null) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (Navigator.of(context).canPop()) {
//           Navigator.of(context).pop();
//         }
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Items list updated'), backgroundColor: Colors.grey));
//       });
//
//       return Scaffold(body: Center(child: CircularProgressIndicator()));
//     }
//     // print('::> loadedProduct.poster::> ${_purchasedProduct.poster}');
//     // print('::> loadedProduct.postertimeStamp::> ${_purchasedProduct.postertimeStamp}');
//     // print('::> loadedProduct.description::> ${_purchasedProduct.description}');
//
//     final double _screenWidth = MediaQuery.of(context).size.width;
//     double _tax = 0.0;
//     double _feeCharge = 0.0;
//     double _feeFinal = 0.0;
//     double _transfer_total = 0.0;
//
//     _tax = loadedProduct!.price * Resources.TAXRATE;
//     double _total = (loadedProduct.price + _tax + Resources.SHIPPING);
//
//     if (feeType == 'percentage') {
//       _feeCharge = feeValue;
//       _transfer_total = _total - ((loadedProduct.price + _tax + Resources.SHIPPING) * _feeCharge);
//       _feeFinal = _total - _transfer_total;
//     } else if (feeType == 'flat') {
//       _feeFinal = feeValue;
//     }
//
//     // _tax = loadedProduct!.price * Resources.TAXRATE;
//     //
//     // double _total = (loadedProduct.price + _tax + Resources.SHIPPING);
//     // double _transfer_total = _total - ((loadedProduct.price + _tax + Resources.SHIPPING) * _feeCharge);
//     // _feeFinal = _total - _transfer_total;
//
//     //Flat rate transaction fee of $2.00
//     //double _fee = 2;
//
//     ///If _type = percentage, then fee is percentage of _total [.0X]; if _type = flat, then fee is flat rate[X]
//     //double _fee = loadFee() as double;
//
//     print('New _total:${_total.toStringAsFixed(2)}');
//     print('New _transfer_total:${_transfer_total.toStringAsFixed(2)}');
//     print('Fee Total:${_feeFinal.toStringAsFixed(2)}');
//     print('Tax Total:${_tax.toStringAsFixed(2)}');
//
//     // if (MediaQuery
//     //     .of(context)
//     //     .size
//     //     .width < mobileWidth) {
//     //--mobile--
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(elevation: 0, backgroundColor: Colors.white, surfaceTintColor: Colors.transparent, title: Text(loadedProduct.title)),
//         body: SingleChildScrollView(
//           //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//           padding: const EdgeInsets.all(10.0),
//           child: Column(
//             children: <Widget>[
//               SizedBox(height: 10),
//               Card(
//                 clipBehavior: Clip.antiAlias,
//                 //clipBehavior: Clip.antiAlias,
//                 child: Column(
//                   children: [
//                     ListTile(
//                       // leading: CircleAvatar(
//                       //   radius: 45,
//                       //   backgroundImage: NetworkImage(loadedProduct.imageUrl),
//                       // ),
//                       leading: Container(
//                         width: 100.0,
//                         height: 150.0,
//                         decoration: BoxDecoration(
//                           image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(loadedProduct.imageUrl0)),
//                           borderRadius: BorderRadius.all(Radius.circular(3.0)),
//                           color: Colors.black87,
//                         ),
//                       ),
//                       title: Text(loadedProduct.title),
//                       subtitle: Text(
//                         'Status: ${loadedProduct.status}\nCategory: ${loadedProduct.type}\nSize: ${loadedProduct.size}',
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 5,
//                         style: TextStyle(color: Colors.black.withOpacity(0.6)),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Text(loadedProduct.description, style: TextStyle(color: Colors.black.withOpacity(0.6))),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 15.0),
//                 child: Column(
//                   children: <Widget>[
//                     Text(
//                       'Shipping Details:',
//                       softWrap: true,
//                       style: TextStyle(
//                         fontSize: 18.0,
//                         fontWeight: FontWeight.w900,
//                         //letterSpacing: 2.5,
//                       ),
//                     ),
//                     Form(
//                       key: _form,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: <Widget>[
//                           TextFormField(
//                             autofocus: true,
//                             initialValue: _initValues['shippingName'],
//                             decoration: InputDecoration(hintText: 'Full Name'),
//                             textInputAction: TextInputAction.next,
//                             // onFieldSubmitted: (_) {
//                             //   print('Full name -> focus pressed');
//                             //   FocusScope.of(context).unfocus();
//                             //   //FocusScope.of(context).requestFocus(_addressFocusNode);
//                             // },
//                             validator: (value) {
//                               if (value!.isEmpty) {
//                                 return 'Please provide a value.';
//                               }
//                               return null;
//                             },
//                             onSaved: (value) {
//                               if (value != null) {
//                                 _purchasedProduct = Product(
//                                   title: loadedProduct.title,
//                                   price: loadedProduct.price,
//                                   description: loadedProduct.description,
//                                   imageUrl0: loadedProduct.imageUrl0,
//                                   id: loadedProduct.id,
//                                   isFavorite: loadedProduct.isFavorite,
//                                   sku: loadedProduct.sku,
//                                   status: loadedProduct.status,
//                                   type: loadedProduct.type,
//                                   size: loadedProduct.size,
//                                   shippingName: value,
//                                   shippingAddress: _purchasedProduct.shippingAddress,
//                                   shippingCity: _purchasedProduct.shippingCity,
//                                   shippingState: _purchasedProduct.shippingState,
//                                   shippingZip: _purchasedProduct.shippingZip,
//                                   shippingPhone: _purchasedProduct.shippingPhone,
//                                   shippingEmail: _purchasedProduct.shippingEmail,
//                                   poster: loadedProduct.poster,
//                                   postertimeStamp: loadedProduct.postertimeStamp,
//                                   imageUrl2: '',
//                                   imageUrl1: '',
//                                   buyer: this._user!.email.toString() + ' ::> ' + this._user!.uid.toString(),
//                                   buyertimeStamp: DateTime.now().toIso8601String(),
//                                   piToken: _purchasedProduct.piToken,
//                                 );
//                                 print('::> loadedProduct.poster::> ${loadedProduct.poster}');
//                                 print('::> loadedProduct.postertimeStamp::> ${loadedProduct.postertimeStamp}');
//                                 print('::> loadedProduct.description::> ${loadedProduct.description}');
//                               }
//                             },
//                           ),
//                           Container(
//                             width: _screenWidth,
//                             child: TextFormField(
//                               ///turn off/on autocomplete
//                               //controller: _searchAddress,
//                               initialValue: _initValues['shippingAddress'],
//
//                               ///turn off/on autocomplete
//                               decoration: InputDecoration(hintText: 'Address'),
//                               textInputAction: TextInputAction.next,
//                               onChanged: (value) {
//                                 setState(() {});
//                               },
//                               onFieldSubmitted: (_) {
//                                 setShipAddress(_searchAddress.text);
//
//                                 print('addressNode focus::  ${_addressFocusNode.hasFocus}');
//                                 print('***onFieldSubmitted as been called***');
//                               },
//                               validator: (value) {
//                                 if (value!.isEmpty) {
//                                   return 'Please provide a value.';
//                                 }
//                                 return null;
//                               },
//                               onSaved: (value) {
//                                 if (value != null) {
//                                   _purchasedProduct = Product(
//                                     title: loadedProduct.title,
//                                     price: loadedProduct.price,
//                                     description: loadedProduct.description,
//                                     imageUrl0: loadedProduct.imageUrl0,
//                                     id: loadedProduct.id,
//                                     isFavorite: loadedProduct.isFavorite,
//                                     sku: loadedProduct.sku,
//                                     status: loadedProduct.status,
//                                     type: loadedProduct.type,
//                                     size: loadedProduct.size,
//                                     shippingName: _purchasedProduct.shippingName,
//                                     shippingAddress: value,
//                                     shippingCity: _purchasedProduct.shippingCity,
//                                     shippingState: _purchasedProduct.shippingState,
//                                     shippingZip: _purchasedProduct.shippingZip,
//                                     shippingPhone: _purchasedProduct.shippingPhone,
//                                     shippingEmail: _purchasedProduct.shippingEmail,
//                                     poster: loadedProduct.poster,
//                                     postertimeStamp: loadedProduct.postertimeStamp,
//                                     imageUrl2: '',
//                                     imageUrl1: '',
//                                     buyer: this._user!.email.toString() + ' ::> ' + this._user!.uid.toString(),
//                                     buyertimeStamp: DateTime.now().toIso8601String(),
//                                     piToken: _purchasedProduct.piToken,
//                                   );
//                                 }
//                               },
//                             ),
//                           ),
//
//                           TextFormField(
//                             initialValue: _initValues['shippingCity'],
//                             decoration: InputDecoration(hintText: 'City'),
//                             textInputAction: TextInputAction.next,
//                             // onFieldSubmitted: (_) {
//                             //   FocusScope.of(context).requestFocus(_stateFocusNode);
//                             // },
//                             validator: (value) {
//                               if (value!.isEmpty) {
//                                 return 'Please provide a city';
//                               }
//                               return null;
//                             },
//                             onSaved: (value) {
//                               if (value != null) {
//                                 _purchasedProduct = Product(
//                                   title: loadedProduct.title,
//                                   price: loadedProduct.price,
//                                   description: loadedProduct.description,
//                                   imageUrl0: loadedProduct.imageUrl0,
//                                   id: loadedProduct.id,
//                                   isFavorite: loadedProduct.isFavorite,
//                                   sku: loadedProduct.sku,
//                                   status: loadedProduct.status,
//                                   type: loadedProduct.type,
//                                   size: loadedProduct.size,
//                                   shippingName: _purchasedProduct.shippingName,
//                                   shippingAddress: _purchasedProduct.shippingAddress,
//                                   shippingCity: value,
//                                   shippingState: _purchasedProduct.shippingState,
//                                   shippingZip: _purchasedProduct.shippingZip,
//                                   shippingPhone: _purchasedProduct.shippingPhone,
//                                   shippingEmail: _purchasedProduct.shippingEmail,
//                                   poster: loadedProduct.poster,
//                                   postertimeStamp: loadedProduct.postertimeStamp,
//                                   imageUrl2: '',
//                                   imageUrl1: '',
//                                   buyer: this._user!.email.toString() + ' ::> ' + this._user!.uid.toString(),
//                                   buyertimeStamp: DateTime.now().toIso8601String(),
//                                   piToken: _purchasedProduct.piToken,
//                                 );
//                               }
//                             },
//                           ),
//                           // Row(
//                           //   crossAxisAlignment: CrossAxisAlignment.center,
//                           //   children: <Widget>[
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: <Widget>[
//                               Container(
//                                 height: 50,
//                                 width: 70,
//                                 child: DropdownButton<String>(
//                                   hint: Align(
//                                     alignment: Alignment.centerRight,
//                                     child: Text("State", style: TextStyle(color: Colors.black)),
//                                   ),
//                                   value: currentState,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       currentState = value;
//                                       // value = value;
//                                       if (value != null) {
//                                         _purchasedProduct = Product(
//                                           title: loadedProduct.title,
//                                           price: loadedProduct.price,
//                                           description: loadedProduct.description,
//                                           imageUrl0: loadedProduct.imageUrl0,
//                                           id: loadedProduct.id,
//                                           isFavorite: loadedProduct.isFavorite,
//                                           sku: loadedProduct.sku,
//                                           status: loadedProduct.status,
//                                           type: loadedProduct.type,
//                                           size: loadedProduct.size,
//                                           shippingName: _purchasedProduct.shippingName,
//                                           shippingAddress: _purchasedProduct.shippingAddress,
//                                           shippingCity: _purchasedProduct.shippingCity,
//                                           shippingState: value,
//                                           shippingZip: _purchasedProduct.shippingZip,
//                                           shippingPhone: _purchasedProduct.shippingPhone,
//                                           shippingEmail: _purchasedProduct.shippingEmail,
//                                           poster: loadedProduct.poster,
//                                           postertimeStamp: loadedProduct.postertimeStamp,
//                                           imageUrl2: '',
//                                           imageUrl1: '',
//                                           buyer: this._user!.email.toString() + ' ::> ' + this._user!.uid.toString(),
//                                           buyertimeStamp: DateTime.now().toIso8601String(),
//                                           piToken: _purchasedProduct.piToken,
//                                         );
//                                       }
//                                     });
//                                     print('Selected State: $currentState');
//                                     FocusScope.of(context).requestFocus(_zipFocusNode);
//                                   },
//                                   items: _statesList.map<DropdownMenuItem<String>>((value) {
//                                     return DropdownMenuItem(child: Text(value), value: value);
//                                   }).toList(),
//                                 ),
//                               ),
//                               Container(
//                                 height: 65,
//                                 width: 150,
//                                 child: TextFormField(
//                                   textAlign: TextAlign.center,
//                                   initialValue: _initValues['shippingZip'],
//                                   decoration: InputDecoration(hintText: 'Zip Code'),
//                                   textInputAction: TextInputAction.next,
//                                   keyboardType: TextInputType.phone,
//                                   maxLength: 5,
//                                   // onFieldSubmitted: (_) {
//                                   //   FocusScope.of(context).requestFocus(_phoneFocusNode);
//                                   // },
//                                   validator: (value) {
//                                     if (value!.isEmpty) {
//                                       return 'Please provide a valid Zip';
//                                     }
//                                     return null;
//                                   },
//                                   onSaved: (value) {
//                                     if (value != null) {
//                                       _purchasedProduct = Product(
//                                         title: loadedProduct.title,
//                                         price: loadedProduct.price,
//                                         description: loadedProduct.description,
//                                         imageUrl0: loadedProduct.imageUrl0,
//                                         id: loadedProduct.id,
//                                         isFavorite: loadedProduct.isFavorite,
//                                         sku: loadedProduct.sku,
//                                         status: loadedProduct.status,
//                                         type: loadedProduct.type,
//                                         size: loadedProduct.size,
//                                         shippingName: _purchasedProduct.shippingName,
//                                         shippingAddress: _purchasedProduct.shippingAddress,
//                                         shippingCity: _purchasedProduct.shippingCity,
//                                         shippingState: _purchasedProduct.shippingState,
//                                         shippingZip: value,
//                                         shippingPhone: _purchasedProduct.shippingPhone,
//                                         shippingEmail: _purchasedProduct.shippingEmail,
//                                         poster: loadedProduct.poster,
//                                         postertimeStamp: loadedProduct.postertimeStamp,
//                                         imageUrl2: '',
//                                         imageUrl1: '',
//                                         buyer: this._user!.email.toString() + ' ::> ' + this._user!.uid.toString(),
//                                         buyertimeStamp: DateTime.now().toIso8601String(),
//                                         piToken: _purchasedProduct.piToken,
//                                       );
//                                     }
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                           TextFormField(
//                             initialValue: _initValues['shippingPhone'],
//                             decoration: InputDecoration(hintText: 'Phone Number   (###) ###-####'),
//                             keyboardType: TextInputType.phone,
//                             textInputAction: TextInputAction.next,
//                             inputFormatters: [PhoneInputFormatter(defaultCountryCode: 'US')],
//                             validator: (value) {
//                               if (value!.isEmpty) {
//                                 return 'Please provide a valid Phone Number';
//                               }
//                               return null;
//                             },
//                             onSaved: (value) {
//                               if (value != null) {
//                                 _purchasedProduct = Product(
//                                   title: loadedProduct.title,
//                                   price: loadedProduct.price,
//                                   description: loadedProduct.description,
//                                   imageUrl0: loadedProduct.imageUrl0,
//                                   id: loadedProduct.id,
//                                   isFavorite: loadedProduct.isFavorite,
//                                   sku: loadedProduct.sku,
//                                   status: loadedProduct.status,
//                                   type: loadedProduct.type,
//                                   size: loadedProduct.size,
//                                   shippingName: _purchasedProduct.shippingName,
//                                   shippingAddress: _purchasedProduct.shippingAddress,
//                                   shippingCity: _purchasedProduct.shippingCity,
//                                   shippingState: _purchasedProduct.shippingState,
//                                   shippingZip: _purchasedProduct.shippingZip,
//                                   shippingPhone: value,
//                                   shippingEmail: _purchasedProduct.shippingEmail,
//                                   poster: loadedProduct.poster,
//                                   postertimeStamp: loadedProduct.postertimeStamp,
//                                   imageUrl2: '',
//                                   imageUrl1: '',
//                                   buyer: this._user!.email.toString() + ' ::> ' + this._user!.uid.toString(),
//                                   buyertimeStamp: DateTime.now().toIso8601String(),
//                                   piToken: _purchasedProduct.piToken,
//                                 );
//                               }
//                             },
//                           ),
//                           TextFormField(
//                             ///change for signup provided email
//                             //   enabled: false,
//                             //   initialValue: _initValues[_user!.email],
//                             //   decoration: InputDecoration(hintText: '${_user!.email}'),
//                             ///change for signup provided email
//
//                             ///change for user provided email - [Part A]
//                             initialValue: _initValues['shippingEmail'],
//                             decoration: InputDecoration(
//                               hintText: 'shipping@vndy.com',
//                               hintStyle: TextStyle(color: Colors.grey),
//                             ),
//
//                             ///change for user provided email - [Part A]
//                             textInputAction: TextInputAction.next,
//                             keyboardType: TextInputType.emailAddress,
//
//                             ///change for user provided email - [Part B]
//                             validator: (value) {
//                               if (value!.isEmpty) {
//                                 return 'Please provide a valid Email address';
//                               }
//                               return null;
//                             },
//
//                             ///change for user provided email
//                             onSaved: (value) {
//                               ///change for signup provided email
//                               // value = _user!.email;
//                               ///change for signup provided email
//                               if (value != null) {
//                                 _purchasedProduct = Product(
//                                   title: loadedProduct.title,
//                                   price: loadedProduct.price,
//                                   description: loadedProduct.description,
//                                   imageUrl0: loadedProduct.imageUrl0,
//                                   id: loadedProduct.id,
//                                   isFavorite: loadedProduct.isFavorite,
//                                   sku: loadedProduct.sku,
//                                   status: loadedProduct.status,
//                                   type: loadedProduct.type,
//                                   size: loadedProduct.size,
//                                   shippingName: _purchasedProduct.shippingName,
//                                   shippingAddress: _purchasedProduct.shippingAddress,
//                                   shippingCity: _purchasedProduct.shippingCity,
//                                   shippingState: _purchasedProduct.shippingState,
//                                   shippingZip: _purchasedProduct.shippingZip,
//                                   shippingPhone: _purchasedProduct.shippingPhone,
//                                   shippingEmail: value,
//                                   poster: loadedProduct.poster,
//                                   postertimeStamp: loadedProduct.postertimeStamp,
//                                   imageUrl2: '',
//                                   imageUrl1: '',
//                                   buyer: this._user!.email.toString() + ' ::> ' + this._user!.uid.toString(),
//                                   buyertimeStamp: DateTime.now().toIso8601String(),
//                                   piToken: _purchasedProduct.piToken,
//                                 );
//                               }
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 20.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Text(
//                             // '${loadedProduct.title}',
//                             'Subtotal:',
//                             softWrap: true,
//                             style: TextStyle(
//                               fontSize: 14.0,
//                               //fontWeight: FontWeight.w900,
//                               //letterSpacing: 2.5,
//                             ),
//                           ),
//                           Text('\$${loadedProduct.price.toStringAsFixed(2)}', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 20.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Text(
//                             // '${loadedProduct.title}',
//                             'Estimated Shipping & Handling:',
//                             softWrap: true,
//                             style: TextStyle(
//                               fontSize: 14.0,
//                               //fontWeight: FontWeight.w900,
//                               //letterSpacing: 2.5,
//                             ),
//                           ),
//                           Text(
//                             //'\$${_shipping.toStringAsFixed(2)}',
//                             '\$${Resources.SHIPPING.toStringAsFixed(2)}',
//                             style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 20.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Text(
//                             // '${loadedProduct.title}',
//                             'Estimated Tax:',
//                             softWrap: true,
//                             style: TextStyle(
//                               fontSize: 14.0,
//                               //fontWeight: FontWeight.w900,
//                               //letterSpacing: 2.5,
//                             ),
//                           ),
//                           Text('\$${_tax.toStringAsFixed(2)}', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 20.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Text(
//                             // '${loadedProduct.title}',
//                             'Total:',
//                             softWrap: true,
//                             style: TextStyle(
//                               fontSize: 16.0,
//                               fontWeight: FontWeight.w900,
//                               //letterSpacing: 2.5,
//                             ),
//                           ),
//                           Text('\$${_total.toStringAsFixed(2)}', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 40),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         bottomNavigationBar: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             boxShadow: [BoxShadow(color: Colors.black)],
//           ),
//           child: Padding(
//             padding: EdgeInsets.all(15.0),
//             child: TextButton(
//               style: TextButton.styleFrom(
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 minimumSize: Size(0, 48),
//                 textStyle: TextStyle(fontFamily: GoogleFonts.bebasNeue().fontFamily, fontSize: 18.0, fontWeight: FontWeight.w700, color: Colors.white, wordSpacing: 2.0, letterSpacing: 1.5),
//                 backgroundColor: Colors.black,
//               ),
//               child: Text('Submit Payment'),
//               onPressed: () {
//                 print("purchase tag => ${_generatePurchasetag(8)}");
//
//                 _saveForm();
//                 // var current_total = _total * 100;
//                 // print("current total: ${current_total.toString()}");
//
//                 //var amount = loadedProduct.price.toString() + '00';
//                 //var amount = _total;
//
//                 if (_form.currentState!.validate()) {
//                   //_payment(amount);
//                   _total = _total * 100;
//                   _transfer_total = _transfer_total * 100;
//                   _feeFinal = _feeFinal * 100;
//
//                   //makePayment(_total.toStringAsFixed(0), _transfer_total.toStringAsFixed(0));
//                   print('form is validated!!!');
//
//                   makePayment(_total.toStringAsFixed(0), _feeFinal.toStringAsFixed(0));
//                 }
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> makePayment(String _total, String _feeFinal) async {
//     try {
//       // paymentIntentData = await createPaymentIntent(_total, 'USD');
//
//       paymentIntentData = await createPaymentIntent(
//         _total,
//         'USD',
//         _purchasedProduct.shippingAddress,
//         _purchasedProduct.shippingCity,
//         _purchasedProduct.shippingState,
//         _purchasedProduct.shippingZip,
//         _purchasedProduct.shippingName,
//         _purchasedProduct.shippingPhone,
//       );
//
//       print('***PAYMENT INTENT DATA REPLY*** ===> ${paymentIntentData.toString()}');
//
//       // create some billingDetails
//       final billingDetails = stripe.BillingDetails(
//         name: _purchasedProduct.shippingName,
//         email: _purchasedProduct.shippingEmail,
//         phone: _purchasedProduct.shippingPhone,
//         address: stripe.Address(
//           city: _purchasedProduct.shippingCity,
//           country: 'US',
//           line1: _purchasedProduct.shippingAddress,
//           line2: '',
//           state: _purchasedProduct.shippingState,
//           postalCode: _purchasedProduct.shippingZip,
//         ),
//       ); // mocked data for tests
//
//       print('<:: Billing Details ::>');
//       print('<:: Name: ${billingDetails.name} ::>');
//       print('<:: email: ${billingDetails.email} ::>');
//       print('<:: phone: ${billingDetails.phone} ::>');
//
//       //split payments
//
//       await stripe.Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: stripe.SetupPaymentSheetParameters(
//           paymentIntentClientSecret: paymentIntentData['client_secret'],
//           //extra params
//           //applePay: true,
//           //googlePay: true,
//           //change for production
//           //testEnv: true,
//           billingDetails: billingDetails,
//           //merchantCountryCode: 'US',
//           merchantDisplayName: 'VNDY Test',
//           //customer params
//           customerId: 'customerID123',
//           style: ThemeMode.light,
//         ),
//       );
//
//       ///now finally display payment sheet
//
//       displayPaymentSheet(_feeFinal);
//     } catch (e, s) {
//       print('exception:$e$s');
//     }
//   }
//
//   displayPaymentSheet(String fee) async {
//     try {
//       await stripe.Stripe.instance
//           .presentPaymentSheet()
//           .then((newValue) async {
//             print('**payment intent: ${paymentIntentData['id']}');
//
//             final _token = paymentIntentData['id'].toString();
//             await setPaymentIntentToken(_token, fee);
//
//             if (!mounted) return;
//
//             try {
//               print('🔁 moveProduct...');
//               await Provider.of<Products>(context, listen: false).moveProduct(_purchasedProduct);
//
//               print('🔁 movePurchased...');
//               await Provider.of<Products>(context, listen: false).movePurchased(_purchasedProduct);
//
//               print('❌ deleteProduct...');
//               await Provider.of<Products>(context, listen: false).deleteProduct(_purchasedProduct.id, _purchasedProduct.imageUrl0);
//
//               print('🔄 fetchAndSetProducts...');
//               await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
//
//               if (mounted) {
//                 Navigator.of(context).pop(true); // ✅ Only after all operations
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text("Payment Successful", textAlign: TextAlign.center),
//                     backgroundColor: Colors.green,
//                   ),
//                 );
//               }
//             } catch (error) {
//               print('❗ Error during checkout: $error');
//               if (mounted) {
//                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error during purchase. Try again."), backgroundColor: Colors.red));
//               }
//             }
//           })
//           .onError((error, stackTrace) {
//             print('Exception/DISPLAYPAYMENTSHEET==> $error');
//           });
//     } on stripe.StripeException catch (e) {
//       print('StripeException: $e');
//       if (mounted) {
//         showDialog(
//           context: context,
//           builder: (_) => AlertDialog(content: Text("Payment Cancelled")),
//         );
//       }
//     } catch (e) {
//       print('Exception: $e');
//     }
//   }
//
//   //added line 1020 & 1021
//   //  Future<Map<String, dynamic>>
//   //createPaymentIntent(String amount, String currency) async {
//   createPaymentIntent(String amount, String currency, String address, String city, String state, String zip, String name, String phone) async {
//     try {
//       Map<String, dynamic> body = {
//         'amount': amount,
//         'currency': currency,
//         'payment_method_types[]': 'card',
//         'shipping[name]': name,
//         'shipping[address][line1]': address,
//         'shipping[address][city]': city,
//         'shipping[address][state]': state,
//         'shipping[address][postal_code]': zip,
//         'shipping[phone]': phone,
//       };
//
//       print('body ===> ${body}');
//       var response = await http.post(
//         Uri.parse('https://api.stripe.com/v1/payment_intents'),
//         body: body,
//         headers: {'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}', 'Content-Type': 'application/x-www-form-urlencoded'},
//       );
//       print('***Create Intent response ===> ${response.body.toString()}');
//
//       return jsonDecode(response.body);
//     } catch (err) {
//       print('err charging user: ${err.toString()}');
//     }
//   }
//
//   confirmPaymentIntent(String paymentIntent) async {
//     try {
//       print('***Now in confirmPaymentIntent***');
//       Map<String, dynamic> body = {'id': paymentIntent};
//       //print('body ===> ${body}');
//
//       var response = await http.get(
//         Uri.parse('https://api.stripe.com/v1/payment_intents/$paymentIntent'),
//         headers: {'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}', 'Content-Type': 'application/x-www-form-urlencoded'},
//       );
//       print('***confirm payment intent response ===> ${response.body.toString()}');
//
//       return jsonDecode(response.body);
//     } catch (err) {
//       print('err charging user: ${err.toString()}');
//     }
//   }
//
//   createTransferIntent(String amount, String currency, String destination, String charges) async {
//     try {
//       print('***Now in createTransferIntent***');
//       Map<String, dynamic> body = {'amount': amount, 'currency': currency, 'destination': destination, 'transfer_group': 'VNDY_Group', 'source_transaction': charges};
//       print('body ===> ${body}');
//
//       var response = await http.post(
//         Uri.parse('https://api.stripe.com/v1/transfers'),
//         body: body,
//         headers: {'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}', 'Content-Type': 'application/x-www-form-urlencoded'},
//       );
//       print('***Create Transfer response ===> ${response.body.toString()}');
//       return jsonDecode(response.body);
//     } catch (err) {
//       print('err charging user: ${err.toString()}');
//     }
//   }
//
//   setPaymentIntentToken(String piToken, String fee) async {
//     print('***Now in set Payment Intent Token ');
//     setState(() {
//       _purchasedProduct = Product(
//         title: _purchasedProduct.title,
//         price: _purchasedProduct.price,
//         description: _purchasedProduct.description,
//         imageUrl0: _purchasedProduct.imageUrl0,
//         id: _purchasedProduct.id,
//         isFavorite: _purchasedProduct.isFavorite,
//         sku: _purchasedProduct.sku,
//         status: _purchasedProduct.status,
//         type: _purchasedProduct.type,
//         size: _purchasedProduct.size,
//         shippingName: _purchasedProduct.shippingName,
//         shippingAddress: _purchasedProduct.shippingAddress,
//         shippingCity: _purchasedProduct.shippingCity,
//         shippingState: _purchasedProduct.shippingState,
//         shippingZip: _purchasedProduct.shippingZip,
//         shippingPhone: _purchasedProduct.shippingPhone,
//         shippingEmail: _purchasedProduct.shippingEmail,
//         poster: _purchasedProduct.poster,
//         postertimeStamp: _purchasedProduct.postertimeStamp,
//         imageUrl2: '',
//         imageUrl1: '',
//         buyer: this._user!.email.toString() + ' ::> ' + this._user!.uid.toString(),
//         buyertimeStamp: DateTime.now().toIso8601String(),
//         piToken: piToken,
//       );
//     });
//     print(':: piToken is saved ::> ' + piToken);
//
//     String _source_transaction = paymentIntentData['id'].toString();
//     print('!!!!!! SOURCE TRANSACTION $_source_transaction !!!!!!!');
//
//     confirmIntentData = await confirmPaymentIntent(piToken);
//     String _charges = confirmIntentData['charges']['data'][0]['id'].toString();
//     print('!!!*** _charges 2 ***!!!: $_charges');
//
//     transferIntentData = await createTransferIntent(fee, 'USD', Resources.STRIPE_CONNECT, _charges);
//     print('Resources.STRIPE_CONNECT::> ${Resources.STRIPE_CONNECT}');
//     print('***TRANSFER INTENT DATA REPLY*** ===> ${paymentIntentData.toString()}');
//   }
//
//   setShipAddress(String shippingAddress) async {
//     print("Now in setShipAddress::> $shippingAddress");
//   }
// }

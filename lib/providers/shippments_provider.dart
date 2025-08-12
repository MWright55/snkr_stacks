// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:snkr_stacks/providers/product.dart';
// import 'package:snkr_stacks/providers/shippment.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:snkr_stacks/models/http_exception.dart';
// import 'package:snkr_stacks/providers/resources.dart' as Resources;
// import 'getToken.dart';
//
// class Shippments with ChangeNotifier {
//   final firestoreInstance = FirebaseFirestore.instance;
//
//   List<Shippment> _items = [];
//
//   List<Shippment> get items {
//     return [..._items];
//   }
//
//   Shippment findById(String id) {
//     return _items.firstWhere((prod) => prod.id == id);
//   }
//
//   Future<void> fetchAndSetOrders() async {
//     String? token = await getToken();
//     print("**now in fetchAndSetOrders()in shippments_providers**");
//     try {
//       final _url = '${Resources.ORDERS_URL}?auth=$token';
//       //final response = await http.get(Uri.parse(Resources.ORDERS_URL));
//       final response = await http.get(Uri.parse(_url));
//       final extractedData = json.decode(response.body) as Map<String, dynamic>;
//       final List<Shippment> loadedProducts = [];
//       extractedData.forEach((prodId, prodData) {
//         loadedProducts.insert(
//           0,
//           Shippment(
//             id: prodId,
//             title: prodData['title'],
//             description: prodData['description'],
//             price: prodData['price'],
//             imageUrl0: prodData['imageUrl0'],
//             imageUrl1: prodData['imageUrl1'],
//             imageUrl2: prodData['imageUrl2'],
//             sku: prodData['sku'],
//             status: prodData['status'],
//             type: prodData['type'],
//             size: prodData['size'],
//             shippingName: prodData['shippingName'],
//             shippingAddress: prodData['shippingAddress'],
//             shippingCity: prodData['shippingCity'],
//             shippingState: prodData['shippingState'],
//             shippingZip: prodData['shippingZip'],
//             shippingPhone: prodData['shippingPhone'],
//             shippingEmail: prodData['shippingEmail'],
//             postertimeStamp: '',
//             poster: '',
//             buyertimeStamp: '',
//             buyer: '',
//             piToken: prodData['piToken'],
//           ),
//         );
//       });
//
//       _items = loadedProducts;
//       notifyListeners();
//     } catch (error) {
//       //throw (error);
//     }
//   }
//
//   Future<void> deleteShippment(String id, String imageUrl0) async {
//     String? token = await getToken();
//     final url = 'https://shoppr-dcf99-51801.firebaseio.com/orders/$id.json?auth=$token';
//     final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
//
//     //Reference storageReference = FirebaseStorage.instance.refFromURL(imageUrl0);
//
//     Shippment? existingProduct = _items[existingProductIndex];
//     _items.removeAt(existingProductIndex);
//     notifyListeners();
//     final response = await http.delete(Uri.parse(url));
//     if (response.statusCode >= 400) {
//       _items.insert(existingProductIndex, existingProduct);
//       notifyListeners();
//       throw HttpException('Could not delete product.');
//     }
//
//     ///08/05/24 -> removed to preserve link in storage or use in email responese (image)
//     //await storageReference.delete();
//     existingProduct = null;
//   }
//
//   Future<void> moveShippment(Product product) async {
//     //const url = 'https://shoppr-dcf99-51801.firebaseio.com/orders.json';
//     String? token = await getToken();
//     try {
//       final _url = '${Resources.ORDERS_URL}?auth=$token';
//       final response = await http.post(
//         //Uri.parse(Resources.ORDERS_URL),
//         Uri.parse(_url),
//         body: json.encode({
//           'title': product.title,
//           'description': product.description,
//           'imageUrl0': product.imageUrl0,
//           'imageUrl1': product.imageUrl1,
//           'imageUrl2': product.imageUrl2,
//           'price': product.price,
//           'isFavorite': product.isFavorite,
//           'sku': product.sku,
//           'status': product.status,
//           'type': product.type,
//           'size': product.size,
//           'shippingName': product.shippingName,
//           'shippingAddress': product.shippingAddress,
//           'shippingCity': product.shippingCity,
//           'shippingState': product.shippingState,
//           'shippingZip': product.shippingZip,
//           'shippingPhone': product.shippingPhone,
//           'shippingEmail': product.shippingEmail,
//           'poster': product.poster,
//           'postertimeStamp': product.postertimeStamp,
//           'buyer': product.buyer,
//           'buyertimeStamp': product.buyertimeStamp,
//           'piToken': product.piToken,
//         }),
//       );
//
//       final newProduct = Shippment(
//         title: product.title,
//         description: product.description,
//         price: product.price,
//         imageUrl0: product.imageUrl0,
//         imageUrl1: product.imageUrl1,
//         imageUrl2: product.imageUrl2,
//         id: json.decode(response.body)['name'],
//         sku: product.sku,
//         status: product.status,
//         type: product.type,
//         size: product.size,
//         shippingName: product.shippingName,
//         shippingAddress: product.shippingAddress,
//         shippingCity: product.shippingCity,
//         shippingState: product.shippingState,
//         shippingZip: product.shippingZip,
//         shippingPhone: product.shippingPhone,
//         shippingEmail: product.shippingEmail,
//         postertimeStamp: product.postertimeStamp,
//         poster: product.poster,
//         buyertimeStamp: product.buyertimeStamp,
//         buyer: product.buyer,
//         piToken: product.piToken,
//       );
//       _items.add(newProduct);
//       notifyListeners();
//     } catch (error) {
//       print(error);
//       throw error;
//     }
//   } //End moveProduct
//
//   Future<void> archiveShippment(Product product) async {
//     String? token = await getToken();
//     try {
//       final _url = '${Resources.ARCHIVED_URL}?auth=$token';
//       final response = await http.post(
//         //Uri.parse(Resources.ARCHIVED_URL),
//         Uri.parse(_url),
//         body: json.encode({
//           'title': product.title,
//           'description': product.description,
//           'imageUrl0': product.imageUrl0,
//           'imageUrl1': product.imageUrl1,
//           'imageUrl2': product.imageUrl2,
//           'price': product.price,
//           'sku': product.sku,
//           'status': product.status,
//           'type': product.type,
//           'size': product.size,
//           'shippingName': product.shippingName,
//           'shippingAddress': product.shippingAddress,
//           'shippingCity': product.shippingCity,
//           'shippingState': product.shippingState,
//           'shippingZip': product.shippingZip,
//           'shippingPhone': product.shippingPhone,
//           'shippingEmail': product.shippingEmail,
//           'postertimeStamp': product.postertimeStamp,
//           'poster': product.poster,
//           'buyer': product.buyer,
//           'buyertimeStamp': product.buyertimeStamp,
//           'piToken': product.piToken,
//         }),
//       );
//
//       final newProduct = Shippment(
//         title: product.title,
//         description: product.description,
//         price: product.price,
//         imageUrl0: product.imageUrl0,
//         imageUrl1: product.imageUrl1,
//         imageUrl2: product.imageUrl2,
//         id: json.decode(response.body)['name'],
//         sku: product.sku,
//         status: product.status,
//         type: product.type,
//         size: product.size,
//         shippingName: product.shippingName,
//         shippingAddress: product.shippingAddress,
//         shippingCity: product.shippingCity,
//         shippingState: product.shippingState,
//         shippingZip: product.shippingZip,
//         shippingPhone: product.shippingPhone,
//         shippingEmail: product.shippingEmail,
//         postertimeStamp: product.postertimeStamp,
//         poster: product.poster,
//         buyer: product.buyer,
//         buyertimeStamp: product.buyertimeStamp,
//         piToken: product.piToken,
//       );
//       _items.add(newProduct);
//       notifyListeners();
//     } catch (error) {
//       print(error);
//       throw error;
//     }
//   } //End moveProduct
// }

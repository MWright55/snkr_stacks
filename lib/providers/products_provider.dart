import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snkr_stacks/providers/product.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:snkr_stacks/models/http_exception.dart';
import 'package:snkr_stacks/providers/resources.dart' as Resources;
import 'getToken.dart';

class Products with ChangeNotifier {
  final firestoreInstance = FirebaseFirestore.instance;

  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  Product? findById(String id) {
    try {
      return _items.firstWhere((prod) => prod.id == id);
    } catch (e) {
      return null; // ✅ Safely return null if not found
    }
  }

  ///Old
  // Future<void> fetchAndSetOrders() async {
  //   String? token = await getToken();
  //   print("**now in fetchAndSetOrders()in products_providers**");
  //   try {
  //     final _url = '${Resources.ORDERS_URL}?auth=$token';
  //     //final response = await http.get(Uri.parse(Resources.ORDERS_URL));
  //     final response = await http.get(Uri.parse(_url));
  //     final extractedData = json.decode(response.body) as Map<String, dynamic>;
  //     final List<Product> loadedProducts = [];
  //     extractedData.forEach((prodId, prodData) {
  //       loadedProducts.insert(
  //         0,
  //         Product(
  //           id: prodId,
  //           title: prodData['title'],
  //           description: prodData['description'],
  //           price: prodData['price'],
  //           imageUrl0: prodData['imageUrl0'],
  //           imageUrl1: prodData['imageUrl1'],
  //           imageUrl2: prodData['imageUrl2'],
  //           sku: prodData['sku'],
  //           status: prodData['status'],
  //           type: prodData['type'],
  //           size: prodData['size'],
  //           shippingPhone: '',
  //           shippingState: '',
  //           buyer: '',
  //           poster: '',
  //           shippingCity: '',
  //           shippingEmail: '',
  //           shippingName: '',
  //           shippingZip: '',
  //           shippingAddress: '',
  //           postertimeStamp: prodData['timeStamp'],
  //           buyertimeStamp: '',
  //           piToken: '',
  //         ),
  //       );
  //     });
  //     _items = loadedProducts;
  //     print('🟡 Notifying listeners[fetchAndSetOrders]...');
  //     notifyListeners();
  //     print('✅ Listeners notified[fetchAndSetOrders].');
  //   } catch (error) {
  //     //throw (error);
  //   }
  // }

  ///New
  // Future<void> fetchAndSetOrders() async {
  //   print("📦 now in fetchAndSetOrders()");
  //
  //   try {
  //     final snapshot = await FirebaseDatabase.instance.ref('orders').get();
  //
  //     if (!snapshot.exists) {
  //       print('⚠️ No orders found in database.');
  //       _items = [];
  //       notifyListeners();
  //       return;
  //     }
  //
  //     final extractedData = snapshot.value as Map<dynamic, dynamic>;
  //     print('📄 extractedData length: ${extractedData.length}');
  //
  //     final List<Product> loadedProducts = [];
  //
  //     extractedData.forEach((prodId, prodData) {
  //       loadedProducts.insert(
  //         0,
  //         Product(
  //           id: prodId.toString(),
  //           title: prodData['title'] ?? '',
  //           description: prodData['description'] ?? '',
  //           price: prodData['price'] ?? 0.0,
  //           imageUrls: (prodData['imageUrls'] as List<dynamic>?)?.map((url) => url.toString()).toList() ?? [],
  //           sku: prodData['sku'] ?? '',
  //           status: prodData['status'] ?? '',
  //           type: prodData['type'] ?? '',
  //           size: prodData['size'] ?? '',
  //           shippingPhone: '',
  //           shippingState: '',
  //           buyer: '',
  //           poster: '',
  //           shippingCity: '',
  //           shippingEmail: '',
  //           shippingName: '',
  //           shippingZip: '',
  //           shippingAddress: '',
  //           postertimeStamp: prodData['timeStamp'] ?? '',
  //           buyertimeStamp: '',
  //           piToken: '',
  //         ),
  //       );
  //     });
  //
  //     _items = loadedProducts;
  //     print('🟡 Notifying listeners [fetchAndSetOrders]...');
  //     notifyListeners();
  //     print('✅ Listeners notified [fetchAndSetOrders].');
  //   } catch (error) {
  //     print('❌ Error in fetchAndSetOrders: $error');
  //     _items = [];
  //     notifyListeners();
  //   }
  // }

  // Future<void> fetchAndSetProducts() async {
  //   String? token = await getToken();
  //   print("**now in fetchAndSetProducts()**");
  //   try {
  //     final _url = '${Resources.PRODUCTS_URL}?auth=$token';
  //     final response = await http.get(Uri.parse(_url));
  //     final extractedData = json.decode(response.body) as Map<String, dynamic>;
  //
  //     print('::extractedData.length in products_provider ${extractedData.length}');
  //
  //     final List<Product> loadedProducts = [];
  //     extractedData.forEach((prodId, prodData) {
  //       loadedProducts.insert(
  //         0,
  //         Product(
  //           id: prodId,
  //           title: prodData['title'],
  //           description: prodData['description'],
  //           price: prodData['price'],
  //           //isFavorite: prodData['isFavorite'],
  //           imageUrl0: prodData['imageUrl0'],
  //           imageUrl1: prodData['imageUrl1'],
  //           imageUrl2: prodData['imageUrl2'],
  //           sku: prodData['sku'],
  //           status: prodData['status'],
  //           type: prodData['type'],
  //           size: prodData['size'],
  //           shippingPhone: '',
  //           shippingState: '',
  //           buyer: '',
  //           poster: '',
  //           shippingCity: '',
  //           shippingEmail: '',
  //           shippingName: '',
  //           shippingZip: '',
  //           shippingAddress: '',
  //           postertimeStamp: '',
  //           buyertimeStamp: '',
  //           piToken: '',
  //         ),
  //       );
  //     });
  //     _items = loadedProducts;
  //     print('🟡 Notifying listeners[fetchAndSetProducts]...');
  //     notifyListeners();
  //     print('✅ Listeners notified[fetchAndSetProducts].');
  //     print('_items in products_provider ::::> ${_items.length}');
  //   } catch (error) {
  //     //throw (error);
  //   }
  //
  //   var allProducts = FirebaseFirestore.instance.collection('products');
  //
  //   print('****alpha****');
  //   print(allProducts);
  // }

  ///New
  // Future<void> fetchAndSetProducts() async {
  //   print("**now in fetchAndSetProducts()**");
  //
  //   try {
  //     final snapshot = await FirebaseDatabase.instance.ref('products').get();
  //     print('🔥 Raw Firebase snapshot: ${snapshot.value}');
  //
  //     if (!snapshot.exists) {
  //       print('⚠️ No products found in database.');
  //       _items = [];
  //       notifyListeners();
  //       return;
  //     }
  //
  //     final extractedData = json.decode(response.body) as Map<String, dynamic>;
  //     print('::extractedData.length in products_provider ${extractedData.length}');
  //
  //     final List<Product> loadedProducts = [];
  //
  //     extractedData.forEach((prodId, prodData) {
  //       loadedProducts.insert(
  //         0,
  //         Product(
  //           id: prodId.toString(),
  //           title: prodData['title'] ?? '',
  //           description: prodData['description'] ?? '',
  //           //price: prodData['price'] ?? 0.0,
  //           price: (prodData['price'] as num).toDouble(),
  //           imageUrls: (prodData['imageUrls'] as List<dynamic>?)?.map((url) => url.toString()).toList() ?? [],
  //           sku: prodData['sku'] ?? '',
  //           status: prodData['status'] ?? '',
  //           type: prodData['type'] ?? '',
  //           size: prodData['size'] ?? '',
  //           shippingPhone: prodData['shippingPhone'] ?? '',
  //           shippingState: prodData['shippingState'] ?? '',
  //           buyer: prodData['buyer'] ?? '',
  //           poster: prodData['poster'] ?? '',
  //           shippingCity: prodData['shippingCity'] ?? '',
  //           shippingEmail: prodData['shippingEmail'] ?? '',
  //           shippingName: prodData['shippingName'] ?? '',
  //           shippingZip: prodData['shippingZip'] ?? '',
  //           shippingAddress: prodData['shippingAddress'] ?? '',
  //           postertimeStamp: prodData['postertimeStamp'] ?? '',
  //           buyertimeStamp: prodData['buyertimeStamp'] ?? '',
  //           piToken: prodData['piToken'] ?? '',
  //           videoUrl: prodData['videoUrl'],
  //           pageUrl: prodData['pageUrl'],
  //           variants: [],
  //           // isFavorite: null, // nullable field
  //         ),
  //       );
  //     });
  //
  //     _items = loadedProducts;
  //     print('🟡 Notifying listeners[fetchAndSetProducts]...');
  //     notifyListeners();
  //     print('✅ Listeners notified[fetchAndSetProducts].');
  //     print('_items in products_provider ::::> ${_items.length}');
  //   } catch (error) {
  //     print('❌ Error in fetchAndSetProducts: $error');
  //     _items = [];
  //     notifyListeners();
  //   }
  // }

  Future<void> fetchAndSetProducts() async {
    final dbRef = FirebaseDatabase.instance.ref().child('products');

    try {
      // 🔥 1️⃣ Pull the snapshot from Firebase
      final snapshot = await dbRef.get();

      if (!snapshot.exists) {
        print('⚠️ No products found in database.');
        return;
      }

      // 🔥 2️⃣ Cast snapshot to Map
      final extractedData = Map<String, dynamic>.from(snapshot.value as Map);
      print('📦 Raw Firebase snapshot: $extractedData');

      final List<Product> loadedProducts = [];

      // 🔥 3️⃣ Loop through every product entry
      extractedData.forEach((prodId, prodData) {
        final Map<String, dynamic> data = Map<String, dynamic>.from(prodData);

        // ✅ Parse imageUrls safely
        final List<String> imageUrls = (data['imageUrls'] is List) ? List<String>.from(data['imageUrls']) : [];

        // ✅ Parse variants safely (critical for Buy Now)
        final List<Map<String, dynamic>> variants = (data['variants'] is List) ? List<Map<String, dynamic>>.from((data['variants'] as List).map((variant) => Map<String, dynamic>.from(variant))) : [];

        // ✅ Build Product object
        loadedProducts.add(
          Product(
            id: data['id'] ?? prodId,
            title: data['title'] ?? '',
            price: (data['price'] is int) ? (data['price'] as int).toDouble() : (data['price'] ?? 0.0),
            description: data['description'] ?? '',
            imageUrls: imageUrls,
            variants: variants,
            // ✅ this is the fix for Buy Now
            status: data['status'] ?? '',
            sku: prodData['sku'] ?? '',
            type: data['type'] ?? '',
            size: data['size'] ?? '',
            shippingPhone: prodData['shippingPhone'] ?? '',
            shippingState: prodData['shippingState'] ?? '',
            buyer: prodData['buyer'] ?? '',
            poster: prodData['poster'] ?? '',
            shippingCity: prodData['shippingCity'] ?? '',
            shippingEmail: prodData['shippingEmail'] ?? '',
            shippingName: prodData['shippingName'] ?? '',
            shippingZip: prodData['shippingZip'] ?? '',
            shippingAddress: prodData['shippingAddress'] ?? '',
            postertimeStamp: prodData['postertimeStamp'] ?? '',
            buyertimeStamp: prodData['buyertimeStamp'] ?? '',
            piToken: prodData['piToken'] ?? '',
            videoUrl: prodData['videoUrl'],
            pageUrl: prodData['pageUrl'],
            // isFavorite: null, // nullable field
          ),
        );
      });

      // 🔥 4️⃣ Update provider state
      _items = loadedProducts;
      notifyListeners();

      print('✅ Products loaded: ${loadedProducts.length}');
    } catch (error) {
      print('❌ Error in fetchAndSetProducts: $error');
      throw error;
    }
  }

  ///Old
  // Future<void> addProduct(Product product) async {
  //   String? token = await getToken();
  //   try {
  //     final _url = '${Resources.PRODUCTS_URL}?auth=$token';
  //     final response = await http.post(
  //       //Uri.parse(Resources.PRODUCTS_URL),
  //       Uri.parse(_url),
  //       body: json.encode({
  //         'title': product.title,
  //         'description': product.description,
  //         'imageUrl0': product.imageUrl0,
  //         'imageUrl1': product.imageUrl1,
  //         'imageUrl2': product.imageUrl2,
  //         'price': product.price,
  //         'sku': product.sku,
  //         'status': product.status,
  //         'type': product.type,
  //         'size': product.size,
  //         'postertimeStamp': product.postertimeStamp,
  //         'poster': product.poster,
  //         'piToken': product.piToken,
  //       }),
  //     );
  //     final newProduct = Product(
  //       title: product.title,
  //       description: product.description,
  //       price: product.price,
  //       imageUrl0: product.imageUrl0,
  //       imageUrl1: product.imageUrl1,
  //       imageUrl2: product.imageUrl2,
  //       id: json.decode(response.body)['name'],
  //       sku: product.sku,
  //       status: product.status,
  //       type: product.type,
  //       size: product.size,
  //       shippingPhone: '',
  //       shippingState: '',
  //       buyer: '',
  //       poster: '',
  //       shippingCity: '',
  //       shippingEmail: '',
  //       shippingName: '',
  //       shippingZip: '',
  //       shippingAddress: '',
  //       postertimeStamp: product.postertimeStamp,
  //       buyertimeStamp: '',
  //       piToken: '',
  //     );
  //     _items.insert(0, newProduct); //add to start of list
  //     print('🟡 Notifying listeners[addProduct]...');
  //     notifyListeners();
  //     print('✅ Listeners notified[addProduct].');
  //   } catch (error) {
  //     print(error);
  //     throw error;
  //   }
  // } //End addProduct

  ///New
  // Future<void> addProduct(Product product) async {
  //   try {
  //     final ref = FirebaseDatabase.instance.ref('products').push();
  //
  //     await ref.set({
  //       'title': product.title,
  //       'description': product.description,
  //       'imageUrl0': product.imageUrl0,
  //       'imageUrl1': product.imageUrl1,
  //       'imageUrl2': product.imageUrl2,
  //       'price': product.price,
  //       'sku': product.sku,
  //       'status': product.status,
  //       'type': product.type,
  //       'size': product.size,
  //       'postertimeStamp': product.postertimeStamp,
  //       'poster': product.poster,
  //       'piToken': product.piToken,
  //     });
  //
  //     final newProduct = Product(
  //       id: ref.key!,
  //       title: product.title,
  //       description: product.description,
  //       price: product.price,
  //       imageUrl0: product.imageUrl0,
  //       imageUrl1: product.imageUrl1,
  //       imageUrl2: product.imageUrl2,
  //       sku: product.sku,
  //       status: product.status,
  //       type: product.type,
  //       size: product.size,
  //       shippingPhone: '',
  //       shippingState: '',
  //       buyer: '',
  //       poster: product.poster,
  //       shippingCity: '',
  //       shippingEmail: '',
  //       shippingName: '',
  //       shippingZip: '',
  //       shippingAddress: '',
  //       postertimeStamp: product.postertimeStamp,
  //       buyertimeStamp: '',
  //       piToken: product.piToken,
  //     );
  //
  //     _items.insert(0, newProduct);
  //     print('🟡 Notifying listeners [addProduct]...');
  //     notifyListeners();
  //     print('✅ Listeners notified [addProduct].');
  //   } catch (error) {
  //     print('❌ Error in addProduct: $error');
  //     throw error;
  //   }
  // }

  //
  // Future<void> updateProduct(String id, Product newProduct) async {
  //   String? token = await getToken();
  //   final prodIndex = _items.indexWhere((prod) => prod.id == id);
  //   if (prodIndex >= 0) {
  //     final url = 'https://shoppr-dcf99-51801.firebaseio.com/products/$id.json?auth=$token';
  //
  //     await http.patch(
  //       Uri.parse(url),
  //       body: json.encode({
  //         'title': newProduct.title,
  //         'description': newProduct.description,
  //         'imageUrl0': newProduct.imageUrl0,
  //         'imageUrl1': newProduct.imageUrl1,
  //         'imageUrl2': newProduct.imageUrl2,
  //         'price': newProduct.price,
  //         'sku': newProduct.sku,
  //         'status': newProduct.status,
  //         'type': newProduct.type,
  //         'size': newProduct.size,
  //         'postertimeStamp': newProduct.postertimeStamp,
  //         'poster': newProduct.poster,
  //         'piToken': newProduct.piToken,
  //       }),
  //     );
  //
  //     _items[prodIndex] = newProduct;
  //     print('🟡 Notifying listeners[updateProduct]...');
  //     notifyListeners();
  //     print('✅ Listeners notified[updateProduct].');
  //   } else {
  //     print('...');
  //   }
  // }

  ///New
  // Future<void> updateProduct(String id, Product newProduct) async {
  //   final prodIndex = _items.indexWhere((prod) => prod.id == id);
  //
  //   if (prodIndex >= 0) {
  //     try {
  //       final ref = FirebaseDatabase.instance.ref('products/$id');
  //
  //       await ref.update({
  //         'title': newProduct.title,
  //         'description': newProduct.description,
  //         'imageUrl0': newProduct.imageUrl0,
  //         'imageUrl1': newProduct.imageUrl1,
  //         'imageUrl2': newProduct.imageUrl2,
  //         'price': newProduct.price,
  //         'sku': newProduct.sku,
  //         'status': newProduct.status,
  //         'type': newProduct.type,
  //         'size': newProduct.size,
  //         'postertimeStamp': newProduct.postertimeStamp,
  //         'poster': newProduct.poster,
  //         'piToken': newProduct.piToken,
  //       });
  //
  //       _items[prodIndex] = newProduct;
  //
  //       print('🟡 Notifying listeners [updateProduct]...');
  //       notifyListeners();
  //       print('✅ Listeners notified [updateProduct].');
  //     } catch (error) {
  //       print('❌ Error updating product: $error');
  //       throw error;
  //     }
  //   } else {
  //     print('⚠️ Product with id [$id] not found in local list.');
  //   }
  // }

  ///Old
  // Future<void> deleteProduct(String id, String imageUrl0) async {
  //   String? token = await getToken();
  //   final url = 'https://shoppr-dcf99-51801.firebaseio.com/products/$id.json?auth=$token';
  //   final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
  //
  //   Reference storageReference = FirebaseStorage.instance.refFromURL(imageUrl0);
  //
  //   print('***StorageReference*** $storageReference');
  //   Product? existingProduct = _items[existingProductIndex];
  //   _items.removeAt(existingProductIndex);
  //   print('🟡 Notifying listeners[deleteProduct]...');
  //   notifyListeners();
  //   print('✅ Listeners notified[deleteProduct].');
  //   final response = await http.delete(Uri.parse(url));
  //   if (response.statusCode >= 400) {
  //     _items.insert(existingProductIndex, existingProduct);
  //     print('🟡 Notifying listeners[deleteProduct 400]...');
  //     notifyListeners();
  //     print('✅ Listeners notified[deleteProduct 400].');
  //     throw HttpException('Could not delete product.');
  //   }
  //
  //   print('***StorageReference*** $storageReference');
  // }

  ///New
  Future<void> deleteProduct(String id, String imageUrl0) async {
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);

    if (existingProductIndex < 0) {
      print('⚠️ Product with ID $id not found in local list.');
      return;
    }

    final Product existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    print('🟡 Notifying listeners [deleteProduct]...');
    notifyListeners();
    print('✅ Listeners notified [deleteProduct].');

    try {
      // 1. Delete from Realtime Database
      final dbRef = FirebaseDatabase.instance.ref('products/$id');
      await dbRef.remove();

      // 2. Delete image from Firebase Storage if it exists
      if (imageUrl0.isNotEmpty && imageUrl0.contains('firebasestorage.googleapis.com')) {
        try {
          final storageRef = FirebaseStorage.instance.refFromURL(imageUrl0);
          print('🗑️ Deleting from Storage: $storageRef');
          await storageRef.delete();
        } catch (e) {
          print('⚠️ Could not delete image from Firebase Storage: $e');
        }
      } else {
        print('ℹ️ Skipping image delete. Not a Firebase URL: $imageUrl0');
      }

      print('✅ Product and image deleted successfully.');
    } catch (error) {
      print('❌ Error deleting product: $error');
      _items.insert(existingProductIndex, existingProduct);
      print('🟡 Notifying listeners [deleteProduct rollback]...');
      notifyListeners();
      throw Exception('Could not delete product: $error');
    }
  }

  ///Old
  // Future<void> moveProduct(Product product) async {
  //   String? token = await getToken();
  //   print('Now in moveProduct in products_provider');
  //   try {
  //     final _url = '${Resources.ORDERS_URL}?auth=$token';
  //     final response = await http.post(
  //       Uri.parse(_url),
  //       //Uri.parse(Resources.ORDERS_URL),
  //       body: json.encode({
  //         'title': product.title,
  //         'description': product.description,
  //         'description': product.description,
  //         'imageUrl0': product.imageUrl0,
  //         'imageUrl1': product.imageUrl1,
  //         'imageUrl2': product.imageUrl2,
  //         'price': product.price,
  //         'sku': product.sku,
  //         'status': product.status,
  //         'type': product.type,
  //         'size': product.size,
  //         'shippingName': product.shippingName,
  //         'shippingAddress': product.shippingAddress,
  //         'shippingCity': product.shippingCity,
  //         'shippingState': product.shippingState,
  //         'shippingZip': product.shippingZip,
  //         'shippingPhone': product.shippingPhone,
  //         'shippingEmail': product.shippingEmail,
  //         'postertimeStamp': product.postertimeStamp,
  //         'poster': product.poster,
  //         'buyertimeStamp': product.buyertimeStamp,
  //         'buyer': product.buyer,
  //         'piToken': product.piToken,
  //       }),
  //     );
  //
  //     final newProduct = Product(
  //       title: product.title,
  //       description: product.description,
  //       price: product.price,
  //       imageUrl0: product.imageUrl0,
  //       imageUrl1: product.imageUrl1,
  //       imageUrl2: product.imageUrl2,
  //       id: json.decode(response.body)['name'],
  //       sku: product.sku,
  //       status: product.status,
  //       type: product.type,
  //       size: product.size,
  //       shippingName: product.shippingName,
  //       shippingAddress: product.shippingAddress,
  //       shippingCity: product.shippingCity,
  //       shippingState: product.shippingState,
  //       shippingZip: product.shippingZip,
  //       shippingPhone: product.shippingPhone,
  //       shippingEmail: product.shippingEmail,
  //       postertimeStamp: product.postertimeStamp,
  //       poster: product.poster,
  //       buyer: product.buyer,
  //       buyertimeStamp: product.buyertimeStamp,
  //       piToken: product.piToken,
  //     );
  //     _items.add(newProduct);
  //     print('🟡 Notifying listeners[moveProduct]...');
  //     notifyListeners();
  //     print('✅ Listeners notified[moveProduct].');
  //   } catch (error) {
  //     print(error);
  //     throw error;
  //   }
  //   print('✅ deleteProduct completed for id: ${product}');
  // } //End moveProduct

  ///New
  // Future<void> moveProduct(Product product) async {
  //   print('📦 Moving product to Orders...');
  //   try {
  //     final ref = FirebaseDatabase.instance.ref('orders').push();
  //     await ref.set({
  //       'title': product.title,
  //       'description': product.description,
  //       'imageUrl0': product.imageUrl0,
  //       'imageUrl1': product.imageUrl1,
  //       'imageUrl2': product.imageUrl2,
  //       'price': product.price,
  //       'sku': product.sku,
  //       'status': product.status,
  //       'type': product.type,
  //       'size': product.size,
  //       'shippingName': product.shippingName,
  //       'shippingAddress': product.shippingAddress,
  //       'shippingCity': product.shippingCity,
  //       'shippingState': product.shippingState,
  //       'shippingZip': product.shippingZip,
  //       'shippingPhone': product.shippingPhone,
  //       'shippingEmail': product.shippingEmail,
  //       'postertimeStamp': product.postertimeStamp,
  //       'poster': product.poster,
  //       'buyer': product.buyer,
  //       'buyertimeStamp': product.buyertimeStamp,
  //       'piToken': product.piToken,
  //     });
  //
  //     final newProduct = Product(
  //       id: ref.key!,
  //       title: product.title,
  //       description: product.description,
  //       price: product.price,
  //       imageUrl0: product.imageUrl0,
  //       imageUrl1: product.imageUrl1,
  //       imageUrl2: product.imageUrl2,
  //       sku: product.sku,
  //       status: product.status,
  //       type: product.type,
  //       size: product.size,
  //       shippingName: product.shippingName,
  //       shippingAddress: product.shippingAddress,
  //       shippingCity: product.shippingCity,
  //       shippingState: product.shippingState,
  //       shippingZip: product.shippingZip,
  //       shippingPhone: product.shippingPhone,
  //       shippingEmail: product.shippingEmail,
  //       postertimeStamp: product.postertimeStamp,
  //       poster: product.poster,
  //       buyer: product.buyer,
  //       buyertimeStamp: product.buyertimeStamp,
  //       piToken: product.piToken,
  //     );
  //
  //     _items.add(newProduct);
  //     notifyListeners();
  //     print('✅ Product moved to Orders and listeners updated.');
  //   } catch (error) {
  //     print('❌ Error in moveProduct: $error');
  //     throw error;
  //   }
  // }

  ///Old
  // Future<void> movePurchased(Product product) async {
  //   String? token = await getToken();
  //   print('Now in movePurchased in products_provider');
  //
  //   try {
  //     final _url = '${Resources.PURCHASED_URL}?auth=$token';
  //     final response = await http.post(
  //       Uri.parse(_url),
  //       //Uri.parse(Resources.PURCHASED_URL),
  //       body: json.encode({
  //         'title': product.title,
  //         'description': product.description,
  //         'imageUrl0': product.imageUrl0,
  //         'imageUrl1': product.imageUrl1,
  //         'imageUrl2': product.imageUrl2,
  //         'price': product.price,
  //         'sku': product.sku,
  //         'status': product.status,
  //         'type': product.type,
  //         'size': product.size,
  //         'shippingName': product.shippingName,
  //         'shippingAddress': product.shippingAddress,
  //         'shippingCity': product.shippingCity,
  //         'shippingState': product.shippingState,
  //         'shippingZip': product.shippingZip,
  //         'shippingPhone': product.shippingPhone,
  //         'shippingEmail': product.shippingEmail,
  //         'postertimeStamp': product.postertimeStamp,
  //         'poster': product.poster,
  //         'buyer': product.buyer,
  //         'buyertimeStamp': product.buyertimeStamp,
  //         'piToken': product.piToken,
  //       }),
  //     );
  //
  //     final newProduct = Product(
  //       title: product.title,
  //       description: product.description,
  //       price: product.price,
  //       imageUrl0: product.imageUrl0,
  //       imageUrl1: product.imageUrl1,
  //       imageUrl2: product.imageUrl2,
  //       id: json.decode(response.body)['name'],
  //       sku: product.sku,
  //       status: product.status,
  //       type: product.type,
  //       size: product.size,
  //       shippingName: product.shippingName,
  //       shippingAddress: product.shippingAddress,
  //       shippingCity: product.shippingCity,
  //       shippingState: product.shippingState,
  //       shippingZip: product.shippingZip,
  //       shippingPhone: product.shippingPhone,
  //       shippingEmail: product.shippingEmail,
  //       postertimeStamp: product.postertimeStamp,
  //       poster: product.poster,
  //       buyer: product.buyer,
  //       buyertimeStamp: product.buyertimeStamp,
  //       piToken: product.piToken,
  //     );
  //     _items.add(newProduct);
  //
  //     print('🟡 Notifying listeners[movePurchased]...');
  //     notifyListeners();
  //     print('✅ Listeners notified[movePurchased].');
  //   } catch (error) {
  //     print(error);
  //     throw error;
  //   }
  // } //End moveProduct

  ///New
  // Future<void> movePurchased(Product product) async {
  //   print('🚚 Moving product to Purchased...');
  //   try {
  //     final ref = FirebaseDatabase.instance.ref('purchased').push();
  //     await ref.set({
  //       'title': product.title,
  //       'description': product.description,
  //       'imageUrl0': product.imageUrl0,
  //       'imageUrl1': product.imageUrl1,
  //       'imageUrl2': product.imageUrl2,
  //       'price': product.price,
  //       'sku': product.sku,
  //       'status': product.status,
  //       'type': product.type,
  //       'size': product.size,
  //       'shippingName': product.shippingName,
  //       'shippingAddress': product.shippingAddress,
  //       'shippingCity': product.shippingCity,
  //       'shippingState': product.shippingState,
  //       'shippingZip': product.shippingZip,
  //       'shippingPhone': product.shippingPhone,
  //       'shippingEmail': product.shippingEmail,
  //       'postertimeStamp': product.postertimeStamp,
  //       'poster': product.poster,
  //       'buyer': product.buyer,
  //       'buyertimeStamp': product.buyertimeStamp,
  //       'piToken': product.piToken,
  //     });
  //
  //     final newProduct = Product(
  //       id: ref.key!,
  //       title: product.title,
  //       description: product.description,
  //       price: product.price,
  //       imageUrl0: product.imageUrl0,
  //       imageUrl1: product.imageUrl1,
  //       imageUrl2: product.imageUrl2,
  //       sku: product.sku,
  //       status: product.status,
  //       type: product.type,
  //       size: product.size,
  //       shippingName: product.shippingName,
  //       shippingAddress: product.shippingAddress,
  //       shippingCity: product.shippingCity,
  //       shippingState: product.shippingState,
  //       shippingZip: product.shippingZip,
  //       shippingPhone: product.shippingPhone,
  //       shippingEmail: product.shippingEmail,
  //       postertimeStamp: product.postertimeStamp,
  //       poster: product.poster,
  //       buyer: product.buyer,
  //       buyertimeStamp: product.buyertimeStamp,
  //       piToken: product.piToken,
  //     );
  //
  //     _items.add(newProduct);
  //     notifyListeners();
  //     print('✅ Product moved to Purchased and listeners updated.');
  //   } catch (error) {
  //     print('❌ Error in movePurchased: $error');
  //     throw error;
  //   }
  // }

  ///Old
  // Future<void> archivePurchased(Product product) async {
  //   String? token = await getToken();
  //   try {
  //     final _url = '${Resources.ARCHIVED_URL}?auth=$token';
  //     final response = await http.post(
  //       Uri.parse(_url),
  //       body: json.encode({
  //         'title': product.title,
  //         'description': product.description,
  //         'imageUrl0': product.imageUrl0,
  //         'imageUrl1': product.imageUrl1,
  //         'imageUrl2': product.imageUrl2,
  //         'price': product.price,
  //         'sku': product.sku,
  //         'status': product.status,
  //         'type': product.type,
  //         'size': product.size,
  //         'shippingName': product.shippingName,
  //         'shippingAddress': product.shippingAddress,
  //         'shippingCity': product.shippingCity,
  //         'shippingState': product.shippingState,
  //         'shippingZip': product.shippingZip,
  //         'shippingPhone': product.shippingPhone,
  //         'shippingEmail': product.shippingEmail,
  //         'postertimeStamp': product.postertimeStamp,
  //         'poster': product.poster,
  //         'buyer': product.buyer,
  //         'buyertimeStamp': product.buyertimeStamp,
  //         'piToken': product.piToken,
  //       }),
  //     );
  //
  //     final newProduct = Product(
  //       title: product.title,
  //       description: product.description,
  //       price: product.price,
  //       imageUrl0: product.imageUrl0,
  //       imageUrl1: product.imageUrl1,
  //       imageUrl2: product.imageUrl2,
  //       id: json.decode(response.body)['name'],
  //       sku: product.sku,
  //       status: product.status,
  //       type: product.type,
  //       size: product.size,
  //       shippingName: product.shippingName,
  //       shippingAddress: product.shippingAddress,
  //       shippingCity: product.shippingCity,
  //       shippingState: product.shippingState,
  //       shippingZip: product.shippingZip,
  //       shippingPhone: product.shippingPhone,
  //       shippingEmail: product.shippingEmail,
  //       postertimeStamp: product.postertimeStamp,
  //       poster: product.poster,
  //       buyer: product.buyer,
  //       buyertimeStamp: product.buyertimeStamp,
  //       piToken: product.piToken,
  //     );
  //     _items.add(newProduct);
  //     print('🟡 Notifying listeners (archivedPurchase)...');
  //     notifyListeners();
  //     print('✅ Listeners notified (archivedPurchase).');
  //   } catch (error) {
  //     print(error);
  //     throw error;
  //   }
  // } //End moveProduct

  ///New
  //   Future<void> archivePurchased(Product product) async {
  //     print('📦 Archiving purchased product...');
  //     try {
  //       final ref = FirebaseDatabase.instance.ref('archived').push();
  //       await ref.set({
  //         'title': product.title,
  //         'description': product.description,
  //         'imageUrl0': product.imageUrl0,
  //         'imageUrl1': product.imageUrl1,
  //         'imageUrl2': product.imageUrl2,
  //         'price': product.price,
  //         'sku': product.sku,
  //         'status': product.status,
  //         'type': product.type,
  //         'size': product.size,
  //         'shippingName': product.shippingName,
  //         'shippingAddress': product.shippingAddress,
  //         'shippingCity': product.shippingCity,
  //         'shippingState': product.shippingState,
  //         'shippingZip': product.shippingZip,
  //         'shippingPhone': product.shippingPhone,
  //         'shippingEmail': product.shippingEmail,
  //         'postertimeStamp': product.postertimeStamp,
  //         'poster': product.poster,
  //         'buyer': product.buyer,
  //         'buyertimeStamp': product.buyertimeStamp,
  //         'piToken': product.piToken,
  //       });
  //
  //       final newProduct = Product(
  //         id: ref.key!,
  //         title: product.title,
  //         description: product.description,
  //         price: product.price,
  //         imageUrl0: product.imageUrl0,
  //         imageUrl1: product.imageUrl1,
  //         imageUrl2: product.imageUrl2,
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
  //
  //       _items.add(newProduct);
  //       notifyListeners();
  //       print('✅ Product archived and listeners updated.');
  //     } catch (error) {
  //       print('❌ Error in archivePurchased: $error');
  //       throw error;
  //     }
  //   }
  // }
}

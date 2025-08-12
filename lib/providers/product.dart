// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// // class Product with ChangeNotifier {
// //   final String id;
// //   final String title;
// //   final String description;
// //   final double price;
// //   late final List<String> imageUrls;
// //   bool isFavorite;
// //   final String sku;
// //   final String status;
// //   final String type;
// //   final String size;
// //   final String shippingName;
// //   late final String shippingAddress;
// //   final String shippingCity;
// //   final String shippingState;
// //   final String shippingZip;
// //   final String shippingPhone;
// //   final String shippingEmail;
// //   final String postertimeStamp;
// //   final String poster;
// //   final String buyer;
// //   final String buyertimeStamp;
// //   final String piToken;
// //   final String? videoUrl;
// //
// //   Product({
// //     required this.id,
// //     required this.title,
// //     required this.description,
// //     required this.price,
// //     required final List<String> imageUrls,
// //     this.isFavorite = false,
// //     required this.sku,
// //     required this.status,
// //     required this.type,
// //     required this.size,
// //     required this.shippingName,
// //     required this.shippingAddress,
// //     required this.shippingCity,
// //     required this.shippingState,
// //     required this.shippingZip,
// //     required this.shippingPhone,
// //     required this.shippingEmail,
// //     required this.postertimeStamp,
// //     required this.poster,
// //     required this.buyer,
// //     required this.buyertimeStamp,
// //     required this.piToken,
// //     this.videoUrl,
// //   });
// // }
//
// class Product with ChangeNotifier {
//   final String id;
//   final String title;
//   final String description;
//   final double price;
//   final List<String> imageUrls;
//   bool isFavorite;
//   final String sku;
//   final String status;
//   final String type;
//   final String size;
//   final String shippingName;
//   final String shippingAddress;
//   final String shippingCity;
//   final String shippingState;
//   final String shippingZip;
//   final String shippingPhone;
//   final String shippingEmail;
//   final String postertimeStamp;
//   final String poster;
//   final String buyer;
//   final String buyertimeStamp;
//   final String piToken;
//   final String? videoUrl;
//   final String? pageUrl;
//   final List<Map<String, dynamic>> variants; // Added variants field
//
//   Product({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.price,
//     required this.imageUrls,
//     this.isFavorite = false,
//     required this.sku,
//     required this.status,
//     required this.type,
//     required this.size,
//     required this.shippingName,
//     required this.shippingAddress,
//     required this.shippingCity,
//     required this.shippingState,
//     required this.shippingZip,
//     required this.shippingPhone,
//     required this.shippingEmail,
//     required this.postertimeStamp,
//     required this.poster,
//     required this.buyer,
//     required this.buyertimeStamp,
//     required this.piToken,
//     required this.variants, // Initialize variants
//     this.videoUrl,
//     this.pageUrl,
//   });
// }

import 'package:flutter/cupertino.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String description;
  final List<String> imageUrls;
  final List<Map<String, dynamic>> variants; // ✅ NEW FIELD for Shopify
  //final bool isFavorite;
  final String sku;
  final String status;
  final String type;
  final String size;
  final String poster;
  final String postertimeStamp;
  final String buyer;
  final String buyertimeStamp;
  final String piToken;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.imageUrls,
    this.variants = const [], // ✅ default empty list for safety
    //required this.isFavorite,
    required this.sku,
    required this.status,
    required this.type,
    required this.size,
    required this.poster,
    required this.postertimeStamp,
    required this.buyer,
    required this.buyertimeStamp,
    required this.piToken,
    required shippingPhone,
    required shippingState,
    required shippingEmail,
    required shippingCity,
    required shippingName,
    required shippingZip,
    required shippingAddress,
    required videoUrl,
    required pageUrl,
  });

  // ✅ CONVERT JSON (Firebase or Shopify) → Product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      variants: List<Map<String, dynamic>>.from(json['variants'] ?? []),
      //isFavorite: json['isFavorite'] ?? false,
      sku: json['sku'] ?? '',
      status: json['status'] ?? '',
      type: json['type'] ?? '',
      size: json['size'] ?? '',
      poster: json['poster'] ?? '',
      postertimeStamp: json['postertimeStamp'] ?? '',
      buyer: json['buyer'] ?? '',
      buyertimeStamp: json['buyertimeStamp'] ?? '',
      piToken: json['piToken'] ?? '',
      shippingPhone: json['shippingPhone'] ?? '',
      shippingState: json['shippingState'] ?? '',
      shippingEmail: json['shippingEmail'] ?? '',
      shippingCity: json['shippingCity'] ?? '',
      shippingName: json['shippingName'] ?? '',
      shippingZip: json['shippingZip'] ?? '',
      shippingAddress: json['shippingAddress'] ?? '',
      videoUrl: json['videoUrl'], // Optional field
      pageUrl: json['pageUrl'], // Optional field
    );
  }

  // ✅ CONVERT Product → JSON (for saving to Firebase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'imageUrls': imageUrls,
      'variants': variants, // ✅ saves Shopify variants back to DB
      //'isFavorite': isFavorite,
      'sku': sku,
      'status': status,
      'type': type,
      'size': size,
      'poster': poster,
      'postertimeStamp': postertimeStamp,
      'buyer': buyer,
      'buyertimeStamp': buyertimeStamp,
      'piToken': piToken,
    };
  }
}

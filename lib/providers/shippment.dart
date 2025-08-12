import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Shippment with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl0;
  final String imageUrl1;
  final String imageUrl2;
  final String sku;
  final String status;
  final String type;
  final String size;
  final String shippingName;
  final String shippingAddress;
  final String shippingCity;
  final String shippingState;
  final String shippingZip;
  final String shippingPhone;
  final String shippingEmail;
  final String postertimeStamp;
  final String poster;
  final String buyer;
  final String buyertimeStamp;
  final String piToken;
  Shippment({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl0,
    required this.imageUrl1,
    required this.imageUrl2,
    required this.sku,
    required this.status,
    required this.type,
    required this.size,
    required this.shippingName,
    required this.shippingAddress,
    required this.shippingCity,
    required this.shippingState,
    required this.shippingZip,
    required this.shippingPhone,
    required this.shippingEmail,
    required this.postertimeStamp,
    required this.poster,
    required this.buyer,
    required this.buyertimeStamp,
    required this.piToken,
  });
}

import 'package:flutter/foundation.dart';

class OrderItem {
  final String id;
  final double amount;
  final DateTime dateTime;

  OrderItem({required this.id, required this.amount, required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(double total) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        dateTime: DateTime.now(),
      ),
    );
  }

  notifyListeners();
}

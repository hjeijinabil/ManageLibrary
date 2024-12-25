import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  List<String> _cartItems = [];

  List<String> get cartItems => _cartItems;

  void addItem(String item) {
    _cartItems.add(item);
    notifyListeners(); 
  }

  int get itemCount => _cartItems.length;
}

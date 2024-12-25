import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'CartProvider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: cart.cartItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(cart.cartItems[index]),
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/core/services/cart_service.dart';
import 'package:flutter_application_1/core/models/cart_item.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final itemsNotifier = CartService.instance.itemsNotifier;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder<List<CartItem>>(
          valueListenable: itemsNotifier,
          builder: (context, cartItems, _) {
            final total = CartService.instance.total;
            final totalItems = CartService.instance.totalItems;

            if (cartItems.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                    const SizedBox(height: 12),
                    const Text('Your cart is empty'),
                    const SizedBox(height: 12),
                    // Re-export the cleaned cart page implementation so imports of `cart_page.dart`
                    // continue to work while the original file was corrupted earlier.
                    export 'cart_page_clean.dart';
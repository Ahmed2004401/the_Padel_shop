import 'package:flutter_application_1/core/models/product.dart';

/// Simple CartItem model that holds a product and a quantity.
class CartItem {
  final Product product;
  final int quantity;

  CartItem({required this.product, required this.quantity});

  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

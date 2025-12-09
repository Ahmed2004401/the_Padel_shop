import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/core/models/cart_item.dart';
import 'package:flutter_application_1/core/models/product.dart';

/// Simple in-memory cart service (singleton) using ValueNotifier for UI updates.
class CartService {
	CartService._internal();

	static final CartService instance = CartService._internal();

	final ValueNotifier<List<CartItem>> itemsNotifier = ValueNotifier<List<CartItem>>([]);

	List<CartItem> get items => itemsNotifier.value;

	double get total => items.fold(0.0, (s, it) => s + it.product.price * it.quantity);

	int get totalItems => items.fold(0, (n, it) => n + it.quantity);

	void add(Product product, {int quantity = 1}) {
		final updated = List<CartItem>.from(items);
		final idx = updated.indexWhere((i) => i.product.id == product.id);
		if (idx >= 0) {
			updated[idx] = updated[idx].copyWith(quantity: updated[idx].quantity + quantity);
		} else {
			updated.add(CartItem(product: product, quantity: quantity));
		}
		itemsNotifier.value = updated;
	}

	void remove(String productId) {
		itemsNotifier.value = items.where((i) => i.product.id != productId).toList();
	}

	void setQuantity(String productId, int quantity) {
		final updated = List<CartItem>.from(items);
		final idx = updated.indexWhere((i) => i.product.id == productId);
		if (idx >= 0) {
			if (quantity <= 0) {
				updated.removeAt(idx);
			} else {
				updated[idx] = updated[idx].copyWith(quantity: quantity);
			}
		}
		itemsNotifier.value = updated;
	}

	void clear() => itemsNotifier.value = [];
}


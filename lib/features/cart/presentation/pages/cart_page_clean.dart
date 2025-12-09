import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/core/services/cart_service.dart';
import 'package:flutter_application_1/core/models/cart_item.dart';

class CartPageClean extends StatelessWidget {
  const CartPageClean({super.key});

  @override
  Widget build(BuildContext context) {
    final itemsNotifier = CartService.instance.itemsNotifier;

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
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
                    ElevatedButton(onPressed: () => context.go('/home'), child: const Text('Shop now')),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: cartItems.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return ListTile(
                        leading: SizedBox(width: 56, child: Image.network(item.product.imageUrl, fit: BoxFit.cover)),
                        title: Text(item.product.name),
                        subtitle: Text('\$${item.product.price.toStringAsFixed(2)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                final newQty = item.quantity - 1;
                                if (newQty <= 0) {
                                  CartService.instance.remove(item.product.id);
                                } else {
                                  CartService.instance.setQuantity(item.product.id, newQty);
                                }
                              },
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () => CartService.instance.setQuantity(item.product.id, item.quantity + 1),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => CartService.instance.remove(item.product.id),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Total ($totalItems items)', style: Theme.of(context).textTheme.titleMedium),
                  Text('\$${total.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleMedium),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => showDialog<void>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Checkout'),
                          content: const Text('Checkout is not implemented yet.'),
                          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
                        ),
                      ),
                      child: const Text('Proceed to Checkout'),
                    ),
                  )
                ])
              ],
            );
          },
        ),
      ),
    );
  }
}

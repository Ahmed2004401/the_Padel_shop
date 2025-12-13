import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/models/product.dart';
import 'package:flutter_application_1/core/services/cart_service.dart';

/// Widget to display a product card with quick add-to-cart support.
class ProductCard extends ConsumerWidget {
  final Product product;
  final VoidCallback? onTap;
            // Product info
            Expanded(
    super.key,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    this.onTap,
  });
                  mainAxisSize: MainAxisSize.min,
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inStock = product.stock > 0;
    final isPremium = product.rating >= 4.0;
    final hasDiscount = false; // hook actual discount logic when available

                      style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
                    const SizedBox(height: 2),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
                      style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
            Stack(
              children: [
                    const SizedBox(height: 4),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Container(
                          size: 12,
                width: double.infinity,
                color: Colors.grey[200],
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                          style: const TextStyle(fontSize: 10),
                    return Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[400],
                          style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey[600],
                    );
                  },
                ),
              ),
                    const Spacer(),
                    const SizedBox(height: 4),
                // Top-left badges (discount / out of stock)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                  top: 8,
                  left: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hasDiscount)
                            const Text('\$', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                              style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue[700],
                          child: const Text(
                            '20% OFF',
                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                              style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue[700],
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Out of Stock',
                                    width: 32,
                                    height: 32,
                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                                      padding: EdgeInsets.zero,
                          ),
                        ),
                    ],
                  ),
                ),
                // Top-right premium badge
                if (isPremium)
                  Positioned(
                                      icon: const Icon(Icons.add_shopping_cart, size: 18),
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.purple[700]!, Colors.blue[700]!]),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                      child: const Text(
                        'PREMIUM',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                      ),
                    ),
                  ),
              ],
            ),
            // Product info
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Name
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    // Category
                    Text(
                      product.category,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 8),
                    // Rating and reviews
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${product.rating}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${product.reviews})',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Price and actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price: dollars + cents split
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('\$', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                            Text(
                              product.price.toStringAsFixed(0),
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                            Text(
                              '.${(product.price % 1 * 100).toStringAsFixed(0).padLeft(2, '0')}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            inStock
                                ? IconButton(
                                    tooltip: 'Add to cart',
                                    onPressed: () {
                                      // Use CartService singleton to manage cart
                                      CartService.instance.add(product);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Added to cart')),
                                      );
                                    },
                                    icon: const Icon(Icons.add_shopping_cart),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

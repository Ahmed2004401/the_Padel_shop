import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/models/product.dart';
import 'package:flutter_application_1/core/services/cart_service.dart';

/// Enhanced product card with compact information and premium badge
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
<<<<<<< HEAD
    final isPremium = product.rating >= 4.0;
    final hasDiscount = false; // hook actual discount logic when available

                      style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        return results
        borderRadius: BorderRadius.circular(12),
    final hasDiscount = false; // Add discount logic when needed
    final isPremium = product.rating >= 4.0; // Premium/featured products

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image with badges
            Stack(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.sports_tennis,
                            color: Colors.grey[400],
                            size: 64,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Top-left badges
                Positioned(
          children: [
            // Product image with badges
            Stack(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.sports_tennis,
                            color: Colors.grey[400],
                            size: 64,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Top-left badges
                Positioned(
>>>>>>> 1fce4de683ccbf48141a68fd2a4369be6f5ecaa5
                  top: 8,
                  left: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hasDiscount)
                  top: 8,
                  left: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hasDiscount)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red[700],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '20% OFF',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (!inStock)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[700],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Out of Stock',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Premium badge (top-right)
                if (isPremium)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.purple[700]!, Colors.blue[700]!],
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: const Text(
                        'PREMIUM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Product info
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand (if available)
                    if (product.brand != null)
                      Text(
                        product.brand!.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 2),
                    // Product name
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.3,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Rating
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < product.rating.floor()
                                ? Icons.star
                                : (index < product.rating
                                    ? Icons.star_half
                                    : Icons.star_border),
                            size: 14,
                            color: Colors.orange[700],
                          );
                        }),
                        const SizedBox(width: 4),
                        Text(
                          '${product.reviews}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Price section
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          '\$',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          product.price.toStringAsFixed(0),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            height: 1,
                          ),
                        ),
                        Text(
                          '.${(product.price % 1 * 100).toStringAsFixed(0).padLeft(2, '0')}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Delivery info
                    if (inStock)
                      Text(
                        'FREE delivery Tomorrow',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[700],
                        ),
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red[700],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '20% OFF',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (!inStock)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[700],
>>>>>>> 1fce4de683ccbf48141a68fd2a4369be6f5ecaa5
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Out of Stock',
<<<<<<< HEAD
                                    width: 32,
                                    height: 32,
                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                                      padding: EdgeInsets.zero,
=======
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
>>>>>>> 1fce4de683ccbf48141a68fd2a4369be6f5ecaa5
                          ),
                        ),
                    ],
                  ),
                ),
<<<<<<< HEAD
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
=======
                // Premium badge (top-right)
                if (isPremium)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.purple[700]!, Colors.blue[700]!],
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: const Text(
                        'PREMIUM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
>>>>>>> 1fce4de683ccbf48141a68fd2a4369be6f5ecaa5
                      ),
                    ),
                  ),
              ],
            ),
            // Product info
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand (if available)
                    if (product.brand != null)
                      Text(
                        product.brand!.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 2),
                    // Product name
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.3,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Rating
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < product.rating.floor()
                                ? Icons.star
                                : (index < product.rating
                                    ? Icons.star_half
                                    : Icons.star_border),
                            size: 14,
                            color: Colors.orange[700],
                          );
                        }),
                        const SizedBox(width: 4),
                        Text(
                          '${product.reviews}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Price section
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          '\$',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          product.price.toStringAsFixed(0),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            height: 1,
                          ),
                        ),
                        Text(
                          '.${(product.price % 1 * 100).toStringAsFixed(0).padLeft(2, '0')}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
<<<<<<< HEAD
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
=======
                    const SizedBox(height: 4),
                    // Delivery info
                    if (inStock)
                      Text(
                        'FREE delivery Tomorrow',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[700],
>>>>>>> 1fce4de683ccbf48141a68fd2a4369be6f5ecaa5
                        ),
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

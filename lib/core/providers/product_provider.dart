import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';

/// Temporary in-memory product data (mock database).
/// Replace with Firestore queries in production.
final _mockProducts = [
  Product(
    id: '1',
    name: 'Professional Carbon Paddle',
    description: 'High-quality carbon padel racket for professionals',
    price: 199.99,
    imageUrl: 'https://via.placeholder.com/300?text=Paddle+1',
    category: 'Paddles',
    brand: 'ProLine',
    rating: 4.8,
    reviews: 128,
    stock: 15,
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
  ),
  Product(
    id: '2',
    name: 'Professional Ball Set',
    description: 'Premium padel balls - set of 12',
    price: 49.99,
    imageUrl: 'https://via.placeholder.com/300?text=Balls',
    category: 'Balls',
    brand: 'MatchPro',
    rating: 4.5,
    reviews: 89,
    stock: 45,
    createdAt: DateTime.now().subtract(const Duration(days: 20)),
  ),
  Product(
    id: '3',
    name: 'Padel Court Shoes',
    description: 'Professional padel shoes with excellent grip',
    price: 129.99,
    imageUrl: 'https://via.placeholder.com/300?text=Shoes',
    category: 'Shoes',
    brand: 'GripX',
    rating: 4.6,
    reviews: 76,
    stock: 30,
    createdAt: DateTime.now().subtract(const Duration(days: 15)),
  ),
  Product(
    id: '4',
    name: 'Beginner Paddle',
    description: 'Great starter padel racket for beginners',
    price: 79.99,
    imageUrl: 'https://via.placeholder.com/300?text=Paddle+2',
    category: 'Paddles',
    brand: 'StarterCo',
    rating: 4.2,
    reviews: 203,
    stock: 50,
    createdAt: DateTime.now().subtract(const Duration(days: 25)),
  ),
  Product(
    id: '5',
    name: 'Padel Backpack',
    description: 'Durable padel equipment backpack',
    price: 89.99,
    imageUrl: 'https://via.placeholder.com/300?text=Backpack',
    category: 'Accessories',
    brand: 'BagMaster',
    rating: 4.4,
    reviews: 45,
    stock: 20,
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
  ),
  Product(
    id: '6',
    name: 'Padel Grip Tape',
    description: 'Premium grip tape for padel rackets',
    price: 19.99,
    imageUrl: 'https://via.placeholder.com/300?text=Grip',
    category: 'Accessories',
    brand: 'GripX',
    rating: 4.7,
    reviews: 312,
    stock: 100,
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
  ),
];

/// Provider for all products.
final productsProvider = FutureProvider<List<Product>>((ref) async {
  // Simulate network delay
  await Future.delayed(const Duration(milliseconds: 500));
  return _mockProducts;
});

/// Provider for filtered products by category.
final productsByCategoryProvider =
    FutureProvider.family<List<Product>, String>((ref, category) async {
  final products = await ref.watch(productsProvider.future);
  return products.where((p) => p.category == category).toList();
});

/// Provider for brands (unique) by category.
final brandsProvider = FutureProvider.family<List<String>, String>((ref, category) async {
  final products = await ref.watch(productsProvider.future);
  final brands = products
      .where((p) => p.category == category)
      .map((p) => p.brand)
      .whereType<String>()
      .toSet()
      .toList();
  return brands;
});

/// Provider for products filtered by category and optionally brand.
final productsByCategoryAndBrandProvider =
    FutureProvider.family<List<Product>, Map<String, String?>>((ref, params) async {
  final category = params['category'] ?? '';
  final brand = params['brand'];
  final products = await ref.watch(productsProvider.future);
  var filtered = products.where((p) => p.category == category);
  if (brand != null && brand.isNotEmpty) {
    filtered = filtered.where((p) => p.brand == brand);
  }
  return filtered.toList();
});

// UI selection state is managed locally in the HomeScreen for now.

/// Provider for a single product by ID.
final productByIdProvider =
    FutureProvider.family<Product?, String>((ref, productId) async {
  final products = await ref.watch(productsProvider.future);
  try {
    return products.firstWhere((p) => p.id == productId);
  } catch (_) {
    return null;
  }
});

/// Provider for product categories (unique).
final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final products = await ref.watch(productsProvider.future);
  final categories = products.map((p) => p.category).toSet().toList();
  return categories;
});

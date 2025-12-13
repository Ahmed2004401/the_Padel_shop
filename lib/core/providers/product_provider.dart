import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

/// Provider for all products from Firestore.
final productsProvider = FutureProvider<List<Product>>((ref) async {
  final firestore = FirebaseFirestore.instance;
  final snapshot = await firestore.collection('products').get();
  
  return snapshot.docs
      .map((doc) => Product.fromMap(doc.data()))
      .toList();
});

/// Provider for filtered products by category from Firestore.
final productsByCategoryProvider =
    FutureProvider.family<List<Product>, String>((ref, category) async {
  final firestore = FirebaseFirestore.instance;
  final snapshot = await firestore
      .collection('products')
      .where('category', isEqualTo: category)
      .get();
  
  return snapshot.docs
      .map((doc) => Product.fromMap(doc.data()))
      .toList();
});

/// Provider for brands by category from Firestore.
final brandsProvider = FutureProvider.family<List<String>, String>((ref, category) async {
  final firestore = FirebaseFirestore.instance;
  final snapshot = await firestore
      .collection('products')
      .where('category', isEqualTo: category)
      .get();
  
  final brands = snapshot.docs
      .map((doc) => doc.data()['brand'] as String?)
      .whereType<String>()
      .toSet()
      .toList()
      ..sort();
  
  return brands;
});

/// Provider for filtered products by category and optionally brand from Firestore.
final productsByCategoryAndBrandProvider =
    FutureProvider.family<List<Product>, Map<String, String?>>((ref, params) async {
  final category = params['category'] ?? '';
  final brand = params['brand'];
  final firestore = FirebaseFirestore.instance;
  
  Query query = firestore
      .collection('products')
      .where('category', isEqualTo: category);
  
  if (brand != null && brand.isNotEmpty) {
    query = query.where('brand', isEqualTo: brand);
  }
  
  final snapshot = await query.get();
  
  return snapshot.docs
      .map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>))
      .toList();
});

// UI selection state is managed locally in the HomeScreen for now.

/// Provider for a single product by ID from Firestore.
final productByIdProvider =
    FutureProvider.family<Product?, String>((ref, productId) async {
  final firestore = FirebaseFirestore.instance;
  final doc = await firestore.collection('products').doc(productId).get();
  
  if (!doc.exists) return null;
  
  return Product.fromMap(doc.data() as Map<String, dynamic>);
});

/// Provider for product categories from Firestore.
final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final firestore = FirebaseFirestore.instance;
  final snapshot = await firestore.collection('categories').get();
  
  return snapshot.docs
      .map((doc) => doc.id)
      .toList()
      ..sort();
});

/// Product model for the padel equipment store.
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final String? brand;
  final double rating;
  final int reviews;
  final int stock;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.brand,
    required this.rating,
    required this.reviews,
    required this.stock,
    required this.createdAt,
  });

  /// Convert Product to Firestore document.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'brand': brand,
      'rating': rating,
      'reviews': reviews,
      'stock': stock,
      'createdAt': createdAt,
    };
  }

  /// Create Product from Firestore document.
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      price: (map['price'] as num).toDouble(),
      imageUrl: map['imageUrl'] as String,
      category: map['category'] as String,
      brand: map['brand'] as String?,
      rating: (map['rating'] as num).toDouble(),
      reviews: map['reviews'] as int,
      stock: map['stock'] as int,
      createdAt: (map['createdAt'] as dynamic).toDate(),
    );
  }

  /// Create a copy with modified fields.
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    String? brand,
    double? rating,
    int? reviews,
    int? stock,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      stock: stock ?? this.stock,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

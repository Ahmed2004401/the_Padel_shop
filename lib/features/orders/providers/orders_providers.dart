// lib/features/orders/providers/orders_providers.dart
import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/models/order.dart';

class OrdersQueryParams {
  final OrderStatus? status;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? search;

  const OrdersQueryParams({this.status, this.startDate, this.endDate, this.search});
}

class OrdersRepository {
  final fs.FirebaseFirestore _db;

  OrdersRepository({fs.FirebaseFirestore? firestore}) : _db = firestore ?? fs.FirebaseFirestore.instance;

  Future<List<Order>> fetchOrders({
    required String userId,
    OrdersQueryParams? params,
    int limit = 20,
  }) async {
    try {
      // Temporary fix: Remove orderBy to avoid index requirement
      // TODO: Create composite index (userId asc, createdAt desc) in Firestore Console
      fs.Query q = _db.collection('orders').where('userId', isEqualTo: userId).limit(limit);
      
      // We'll sort in memory instead
      final snapshot = await q.get();
      var orders = snapshot.docs.map((doc) => _orderFromDoc(doc)).toList();
      
      // Sort in memory by createdAt descending
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      // Apply additional filtering after getting the data
      if (params != null) {
        if (params.status != null) {
          orders = orders.where((order) => order.status.toString().split('.').last == params.status.toString().split('.').last).toList();
        }
        if (params.startDate != null) {
          orders = orders.where((order) => order.createdAt.isAfter(params.startDate!) || order.createdAt.isAtSameMomentAs(params.startDate!)).toList();
        }
        if (params.endDate != null) {
          orders = orders.where((order) => order.createdAt.isBefore(params.endDate!) || order.createdAt.isAtSameMomentAs(params.endDate!)).toList();
        }
        if (params.search != null && params.search!.isNotEmpty) {
          final searchLower = params.search!.toLowerCase();
          orders = orders.where((order) => 
            order.id.toLowerCase().contains(searchLower) ||
            order.items.any((item) => item.name.toLowerCase().contains(searchLower))
          ).toList();
        }
      }
      
      return orders;
    } catch (e) {
      rethrow;
    }
  }

  Order _orderFromDoc(fs.DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final itemsData = (data['items'] as List?) ?? [];

    final items = itemsData.map((it) {
      final map = Map<String, dynamic>.from(it as Map);
      return OrderItem(
        productId: map['productId']?.toString() ?? '',
        name: map['name']?.toString() ?? '',
        imageUrl: map['imageUrl']?.toString() ?? 'assets/ultra padel.jpg',
        brand: map['brand']?.toString(),
        qty: (map['qty'] is int) ? map['qty'] as int : int.tryParse(map['qty']?.toString() ?? '1') ?? 1,
        price: (map['price'] is num) ? (map['price'] as num).toDouble() : double.tryParse(map['price']?.toString() ?? '0') ?? 0,
      );
    }).toList();

    OrderStatus parseStatus(String? s) {
      if (s == null) return OrderStatus.processing;
      switch (s.toLowerCase()) {
        case 'processing':
          return OrderStatus.processing;
        case 'shipped':
          return OrderStatus.shipped;
        case 'delivered':
          return OrderStatus.delivered;
        case 'cancelled':
          return OrderStatus.cancelled;
        default:
          return OrderStatus.processing;
      }
    }

    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      if (v is fs.Timestamp) return v.toDate();
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      try {
        return DateTime.parse(v.toString());
      } catch (_) {
        return null;
      }
    }

    final status = parseStatus(data['status']?.toString());

    return Order(
      id: doc.id,
      userId: data['userId']?.toString() ?? '',
      items: items,
      status: status,
      createdAt: parseDate(data['createdAt']) ?? DateTime.now(),
      shippedAt: parseDate(data['shippedAt']),
      deliveredAt: parseDate(data['deliveredAt']),
      total: (data['total'] is num) ? (data['total'] as num).toDouble() : double.tryParse(data['total']?.toString() ?? '0') ?? 0,
      tracking: null,
    );
  }
}

final ordersRepositoryProvider = Provider<OrdersRepository>((ref) => OrdersRepository());

final ordersParamsProvider = Provider<OrdersQueryParams>((ref) => const OrdersQueryParams());

final ordersProvider = FutureProvider.family<List<Order>, String>((ref, userId) async {
  final repo = ref.read(ordersRepositoryProvider);
  final params = ref.watch(ordersParamsProvider);
  return await repo.fetchOrders(userId: userId, params: params);
});

// lib/features/orders/providers/orders_providers.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/models/order.dart';

class OrdersQueryParams {
  final OrderStatus? status;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? search;

  const OrdersQueryParams({this.status, this.startDate, this.endDate, this.search});
}

class OrdersState {
  final List<Order> orders;
  final bool isLoading;
  final bool isError;
  final bool hasMore;

  const OrdersState({
    required this.orders,
    required this.isLoading,
    required this.isError,
    required this.hasMore,
  });

  OrdersState copyWith({
    List<Order>? orders,
    bool? isLoading,
    bool? isError,
    bool? hasMore,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      class FetchResult {
        final List<Order> orders;
        final DocumentSnapshot? lastDoc;

        FetchResult({required this.orders, this.lastDoc});
      }

      class OrdersRepository {
        final FirebaseFirestore _db;

        OrdersRepository({FirebaseFirestore? firestore}) : _db = firestore ?? FirebaseFirestore.instance;

        Future<FetchResult> fetchOrders({
          required String userId,
          OrdersQueryParams? params,
          int limit = 20,
          DocumentSnapshot? cursor,
        }) async {
          try {
            Query q = _db.collection('orders').where('userId', isEqualTo: userId).orderBy('createdAt', descending: true).limit(limit);

            if (params != null) {
              if (params.status != null) q = q.where('status', isEqualTo: params.status.toString().split('.').last);
              if (params.startDate != null) q = q.where('createdAt', isGreaterThanOrEqualTo: params.startDate);
              if (params.endDate != null) q = q.where('createdAt', isLessThanOrEqualTo: params.endDate);
            }

            if (cursor != null) q = q.startAfterDocument(cursor);

            final snapshot = await q.get();

            final orders = snapshot.docs.map((doc) => _orderFromDoc(doc)).toList();
            final lastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
            return FetchResult(orders: orders, lastDoc: lastDoc);
          } catch (e) {
            rethrow;
          }
        }

        Order _orderFromDoc(DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
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

          final status = parseStatus(data['status']?.toString());

          DateTime? parseDate(dynamic v) {
            if (v == null) return null;
            if (v is Timestamp) return v.toDate();
            if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
            try {
              return DateTime.parse(v.toString());
            } catch (_) {
              return null;
            }
          }

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
      deliveredAt: parseDate(data['deliveredAt']),
      total: (data['total'] is num) ? (data['total'] as num).toDouble() : double.tryParse(data['total']?.toString() ?? '0') ?? 0,
      tracking: null,
    );
  }
}

final ordersRepositoryProvider = Provider<OrdersRepository>((ref) => OrdersRepository());

final ordersParamsProvider = StateProvider<OrdersQueryParams>((ref) => const OrdersQueryParams());

final ordersProvider = StateNotifierProvider.family<OrdersNotifier, OrdersState, String>((ref, userId) {
  final repo = ref.watch(ordersRepositoryProvider);
  final params = ref.watch(ordersParamsProvider);
  return OrdersNotifier(repo: repo, userId: userId, initialParams: params);
});

class OrdersNotifier extends StateNotifier<OrdersState> {
  final OrdersRepository repo;
  final String userId;
  OrdersQueryParams? _params;
  DocumentSnapshot? _lastDoc;

  OrdersNotifier({
    required this.repo,
    required this.userId,
    OrdersQueryParams? initialParams,
  }) : super(const OrdersState(orders: [], isLoading: true, isError: false, hasMore: true)) {
    _params = initialParams;
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    try {
      final result = await repo.fetchOrders(userId: userId, params: _params);
      _lastDoc = result.lastDoc;
      state = OrdersState(orders: result.orders, isLoading: false, isError: false, hasMore: result.orders.length >= 20);
    } catch (_) {
      state = state.copyWith(isLoading: false, isError: true);
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    _cursor = null;
    await _loadInitial();
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) return;
    state = state.copyWith(isLoading: true);
    try {
      final result = await repo.fetchOrders(userId: userId, params: _params, cursor: _lastDoc);
      _lastDoc = result.lastDoc;
      state = OrdersState(
        orders: [...state.orders, ...result.orders],
        isLoading: false,
        isError: false,
        hasMore: result.orders.length >= 20,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false, isError: true);
    }
  }

  void updateParams(OrdersQueryParams params) {
    _params = params;
    refresh();
  }
}

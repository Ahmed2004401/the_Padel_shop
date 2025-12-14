// lib/features/orders/providers/orders_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order.dart';

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
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

// Placeholder repository for demo; replace with Firestore integration later.
class OrdersRepository {
  Future<List<Order>> fetchOrders({
    required String userId,
    OrdersQueryParams? params,
    int limit = 20,
    String? cursor,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.generate(6, (i) {
      final status = [OrderStatus.processing, OrderStatus.shipped, OrderStatus.delivered][i % 3];
      return Order(
        id: 'ORDER-${1000 + i}',
        userId: userId,
        status: status,
        createdAt: DateTime.now().subtract(Duration(days: i * 2)),
        shippedAt: status.index >= OrderStatus.shipped.index ? DateTime.now().subtract(Duration(days: i * 2 - 1)) : null,
        deliveredAt: status == OrderStatus.delivered ? DateTime.now().subtract(Duration(days: i * 2 - 2)) : null,
        total: 49.99 + i * 10,
        items: [
          OrderItem(
            productId: 'p$i',
            name: 'Sample Product $i',
            imageUrl: 'assets/ultra padel.jpg',
            qty: 1 + (i % 2),
            price: 49.99 + i * 10,
          ),
        ],
      );
    });
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
  String? _cursor;

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
      final list = await repo.fetchOrders(userId: userId, params: _params);
      state = OrdersState(orders: list, isLoading: false, isError: false, hasMore: list.length >= 20);
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
      final list = await repo.fetchOrders(userId: userId, params: _params, cursor: _cursor);
      state = OrdersState(
        orders: [...state.orders, ...list],
        isLoading: false,
        isError: false,
        hasMore: list.length >= 20,
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

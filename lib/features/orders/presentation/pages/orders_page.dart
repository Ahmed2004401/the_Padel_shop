import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/models/order.dart';
import 'package:flutter_application_1/features/orders/providers/orders_providers.dart';
import 'package:flutter_application_1/features/orders/presentation/widgets/order_card.dart';
import 'package:flutter_application_1/features/orders/presentation/pages/order_detail_page.dart';
import 'package:flutter_application_1/core/providers/auth_provider.dart';

class OrdersPage extends ConsumerStatefulWidget {
  const OrdersPage({super.key});

  @override
  ConsumerState<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends ConsumerState<OrdersPage> {
  final _scrollController = ScrollController();
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.9) {
        ref.read(ordersProvider(widget.userId).notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _applyFilter(OrderStatus? status) {
    final params = OrdersQueryParams(status: status, search: _searchCtrl.text.trim().isEmpty ? null : _searchCtrl.text.trim());
    ref.read(ordersParamsProvider.notifier).state = params;
    ref.read(ordersProvider(widget.userId).notifier).updateParams(params);
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          return const Scaffold(
            body: Center(child: Text('Please sign in to view your orders')),
          );
        }

        final ordersState = ref.watch(ordersProvider(user.uid));
        return Scaffold(
          appBar: AppBar(
            title: const Text('Your Orders'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => ref.read(ordersProvider(user.uid).notifier).refresh(),
              )
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        decoration: const InputDecoration(
                          hintText: 'Search by order id or product',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        onSubmitted: (_) => _applyFilter(null),
                      ),
                    ),
                    const SizedBox(width: 8),
                    PopupMenuButton<OrderStatus?>(
                      initialValue: null,
                      onSelected: _applyFilter,
                      itemBuilder: (context) => <PopupMenuEntry<OrderStatus?>>[
                        const PopupMenuItem(value: null, child: Text('All')),
                        const PopupMenuItem(value: OrderStatus.processing, child: Text('Processing')),
                        const PopupMenuItem(value: OrderStatus.shipped, child: Text('Shipped')),
                        const PopupMenuItem(value: OrderStatus.delivered, child: Text('Delivered')),
                        const PopupMenuItem(value: OrderStatus.cancelled, child: Text('Cancelled')),
                      ],
                      child: const OutlinedButton(child: Text('Filter'), onPressed: null),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => ref.read(ordersProvider(user.uid).notifier).refresh(),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: ordersState.orders.length + (ordersState.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= ordersState.orders.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final order = ordersState.orders[index];
                      return OrderCard(
                        order: order,
                        onTrack: () {
                          // future: open tracking
                        },
                        onDetails: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => OrderDetailPage(order: order),
                          ));
                        },
                      );
                    },
                  ),
                ),
              ),
              if (ordersState.isError)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text('Failed to load orders', style: TextStyle(color: Colors.red[700])),
                ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, st) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }
}

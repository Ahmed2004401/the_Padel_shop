import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/models/order.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback? onTrack;
  final VoidCallback? onDetails;

  const OrderCard({
    super.key,
    required this.order,
    this.onTrack,
    this.onDetails,
  });

  Color _statusColor(OrderStatus s) {
    switch (s) {
      case OrderStatus.processing:
        return Colors.blue[700]!;
      case OrderStatus.shipped:
        return Colors.purple[700]!;
      case OrderStatus.delivered:
        return Colors.green[700]!;
      case OrderStatus.cancelled:
        return Colors.red[700]!;
    }
  }

  String _statusLabel(OrderStatus s) {
    switch (s) {
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstItem = order.items.isNotEmpty ? order.items.first : null;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: firstItem == null
                  ? Icon(Icons.inventory_2, color: Colors.grey[400])
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(firstItem.imageUrl, fit: BoxFit.cover),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('#${order.id}', style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    'Placed on ${order.createdAt.toLocal().toString().split(' ').first}',
                    style: TextStyle(color: Colors.grey[700], fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _statusColor(order.status).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: _statusColor(order.status)),
                        ),
                        child: Text(
                          _statusLabel(order.status),
                          style: TextStyle(color: _statusColor(order.status), fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${order.items.length} items', style: TextStyle(color: Colors.grey[700], fontSize: 12)),
                      const Spacer(),
                      Text('\$${order.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                OutlinedButton(onPressed: onTrack, child: const Text('Track')),
                const SizedBox(height: 6),
                ElevatedButton(onPressed: onDetails, child: const Text('Details')),
              ],
            )
          ],
        ),
      ),
    );
  }
}

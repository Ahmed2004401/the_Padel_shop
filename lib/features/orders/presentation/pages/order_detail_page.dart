import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/models/order.dart';

class OrderDetailPage extends StatelessWidget {
  final Order order;
  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('#${order.id}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              const Text('Status: ', style: TextStyle(fontWeight: FontWeight.w600)),
              Text(order.status.name),
              const Spacer(),
              Text('Total: \$${order.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          const Text('Items', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...order.items.map((it) {
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(it.imageUrl, width: 48, height: 48, fit: BoxFit.cover),
              ),
              title: Text(it.name),
              subtitle: Text('Qty: ${it.qty}'),
              trailing: Text('\$${(it.price * it.qty).toStringAsFixed(2)}'),
            );
          }),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          const Text('Shipment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (order.tracking == null)
            Text('Tracking not available', style: TextStyle(color: Colors.grey[700]))
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Carrier: ${order.tracking!.carrier}'),
                Text('Tracking #: ${order.tracking!.trackingNumber}'),
                const SizedBox(height: 8),
                ...order.tracking!.events.map((e) => ListTile(
                      leading: const Icon(Icons.local_shipping),
                      title: Text(e.label),
                      subtitle: Text('${e.timestamp} ${e.location ?? ''}'),
                    )),
              ],
            ),
          const SizedBox(height: 32),
          Row(
            children: [
              OutlinedButton(onPressed: () {}, child: const Text('Invoice PDF')),
              const SizedBox(width: 8),
              OutlinedButton(onPressed: () {}, child: const Text('Contact support')),
              const Spacer(),
              ElevatedButton(onPressed: () {}, child: const Text('Reorder')),
            ],
          )
        ],
      ),
    );
  }
}

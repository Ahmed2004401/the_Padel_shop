import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/features/orders/presentation/widgets/order_card.dart';
import 'package:flutter_application_1/core/models/order.dart';

void main() {
  testWidgets('OrderCard displays order info', (tester) async {
    final order = Order(
      id: 'ORDER-123',
      userId: 'u1',
      items: [
        OrderItem(
          productId: 'p1',
          name: 'Test Product',
          imageUrl: 'assets/ultra padel.jpg',
          qty: 1,
          price: 20.0,
        ),
      ],
      status: OrderStatus.processing,
      createdAt: DateTime.now(),
      total: 20.0,
    );

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: OrderCard(order: order))));
    await tester.pumpAndSettle();

    expect(find.text('#ORDER-123'), findsOneWidget);
    expect(find.text('1 items'), findsOneWidget);
    expect(find.text('\$20.00'), findsOneWidget);
    expect(find.text('Processing'), findsOneWidget);
  });
}

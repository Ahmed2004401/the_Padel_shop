// lib/features/orders/models/order.dart
import 'package:flutter/foundation.dart';

enum OrderStatus { processing, shipped, delivered, cancelled }

class OrderItem {
  final String productId;
  final String name;
  final String imageUrl;
  final String? brand;
  final int qty;
  final double price;

  const OrderItem({
    required this.productId,
    required this.name,
    required this.imageUrl,
    this.brand,
    required this.qty,
    required this.price,
  });
}

class TrackingEvent {
  final String label;
  final DateTime timestamp;
  final String? location;

  const TrackingEvent({
    required this.label,
    required this.timestamp,
    this.location,
  });
}

class TrackingInfo {
  final String carrier;
  final String trackingNumber;
  final List<TrackingEvent> events;

  const TrackingInfo({
    required this.carrier,
    required this.trackingNumber,
    required this.events,
  });
}

class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? shippedAt;
  final DateTime? deliveredAt;
  final double total;
  final TrackingInfo? tracking;

  const Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.status,
    required this.createdAt,
    this.shippedAt,
    this.deliveredAt,
    required this.total,
    this.tracking,
  });
}

# Orders Feature Design (Non-Conflicting Reference)

Purpose: This document describes the proposed Orders UX, data, routes, and components. It’s a standalone reference for implementation and is safe to commit without touching existing Dart files.

## UX Overview
- List: OrdersPage with search, status chips (All/Processing/Shipped/Delivered/Cancelled), date range.
- Card: OrderCard shows order id, date, status badge, items count, total, actions (Track, Details).
- Detail: OrderDetailPage with items list, shipment timeline, payment breakdown, addresses, actions (Invoice, Contact, Reorder).
- States: Loading skeletons, empty view with CTA, offline banner.

## Data Models
- Order: id, userId, items[List<OrderItem>], status, createdAt, total, tracking?
- OrderItem: productId, name, imageUrl, qty, price
- TrackingInfo: carrier, trackingNumber, events[List<TrackingEvent>]

## Providers (Riverpod)
- ordersProvider(userId, {status?, dateRange?, search?}): paginated Firestore query
- orderDetailProvider(orderId)

## Routes (GoRouter)
- /orders → OrdersPage
- /orders/:id → OrderDetailPage

## Components
- OrdersPage, OrdersFiltersBar, OrdersList, OrderCard
- OrderDetailPage, OrderTimeline
- Skeletons: OrderCardSkeleton, OrderDetailSkeleton
- Dialogs: CancelConfirmDialog, SupportBottomSheet

## Edge Cases
- Offline cache, retry
- Cancel only when Processing
- Reorder handles out-of-stock items gracefully

Notes: This file is documentation only and won’t conflict with Dart sources.

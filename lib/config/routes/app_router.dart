// lib/config/routes/app_router.dart
import 'package:go_router/go_router.dart';
import '../../core/widgets/auth_guard.dart';
import '../../core/models/product.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/cart/presentation/pages/cart_page_clean.dart';
import '../../features/product/presentation/pages/product_detail_page.dart';
import '../../features/cart/presentation/pages/checkout_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/orders/presentation/pages/orders_page.dart';
import '../../features/orders/presentation/pages/order_detail_page.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const AuthGuard(
        homeScreen: HomeScreen(),
      ),
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartPageClean(),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final product = state.extra as Product;
        return ProductDetailPage(product: product);
      },
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutPage(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      path: '/orders',
      builder: (context, state) {
        // The OrdersPage reads the actual userId from the app state in real usage.
        return OrdersPage(userId: 'current');
      },
    ),
    GoRoute(
      path: '/orders/:id',
      builder: (context, state) {
        final order = state.extra as dynamic; // expects Order passed in extra
        return OrderDetailPage(order: order);
      },
    ),
  ],
);

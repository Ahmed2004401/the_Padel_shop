// lib/config/routes/app_router.dart
import 'package:go_router/go_router.dart';
import '../../core/widgets/auth_guard.dart';
import '../../core/widgets/splash_screen.dart';
import '../../core/models/product.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/cart/presentation/pages/cart_page_clean.dart';
import '../../features/product/presentation/pages/product_detail_page.dart';
import '../../features/cart/presentation/pages/checkout_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/orders/presentation/pages/orders_page.dart';
import '../../features/orders/presentation/pages/order_detail_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
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
        // OrdersPage will read the current user from the auth provider.
        return const OrdersPage();
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
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

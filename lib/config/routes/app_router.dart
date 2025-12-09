// lib/config/routes/app_router.dart
import 'package:go_router/go_router.dart';
import '../../core/widgets/auth_guard.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/cart/presentation/pages/cart_page_clean.dart';

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
  ],
);

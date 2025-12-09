// lib/app.dart
import 'package:flutter/material.dart';
import 'config/theme/app_theme.dart';
import 'config/routes/app_router.dart';

class PadelShopApp extends StatelessWidget {
  const PadelShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Padel Shop',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}

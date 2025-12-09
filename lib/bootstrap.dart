// lib/bootstrap.dart
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Handle Firebase initialization errors
    debugPrint('Firebase initialization error: $e');
  }

  final widget = await builder();

  // runApp must be called in the same zone as ensureInitialized
  runApp(ProviderScope(child: widget));
}

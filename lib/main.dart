import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:emergency_response/core/constants/app_strings.dart';
import 'package:emergency_response/core/router/app_router.dart';
import 'package:emergency_response/core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: EmergencyResponseApp(),
    ),
  );
}

class EmergencyResponseApp extends StatelessWidget {
  const EmergencyResponseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      theme: AppTheme.light,
      darkTheme: AppTheme.light, // Simplified for this demo
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}

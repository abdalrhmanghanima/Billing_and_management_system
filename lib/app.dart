import 'package:flutter/material.dart';
import 'package:billing_and_sales_management/features/splash_screen.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';

class BillingSalesApp extends StatelessWidget {
  const BillingSalesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Billing & Sales Management',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}

import 'package:billing_and_sales_management/data/auth/providers/auth_providers.dart';
import 'package:billing_and_sales_management/domain/auth/repositories/auth_repository.dart';
import 'package:billing_and_sales_management/features/splash_screen.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BillingSalesApp extends StatelessWidget {
  const BillingSalesApp({super.key, this.authRepository});

  final AuthRepository? authRepository;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        if (authRepository != null)
          authRepositoryProvider.overrideWithValue(authRepository!),
      ],
      child: MaterialApp(
        title: 'Billing & Sales Management',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.light,
        home: const SplashScreen(),
      ),
    );
  }
}

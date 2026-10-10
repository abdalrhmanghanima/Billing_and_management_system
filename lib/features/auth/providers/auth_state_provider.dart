import 'package:billing_and_sales_management/data/auth/providers/auth_providers.dart';
import 'package:billing_and_sales_management/domain/auth/entities/auth_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateProvider = StreamProvider<AuthUser?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

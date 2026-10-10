import 'package:billing_and_sales_management/domain/auth/entities/auth_user.dart';
import 'package:billing_and_sales_management/features/auth/providers/login_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginProvider = AsyncNotifierProvider<LoginNotifier, AuthUser?>(
  LoginNotifier.new,
);

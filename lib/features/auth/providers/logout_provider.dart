import 'package:billing_and_sales_management/features/auth/providers/logout_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final logoutProvider = AsyncNotifierProvider<LogoutNotifier, void>(
  LogoutNotifier.new,
);

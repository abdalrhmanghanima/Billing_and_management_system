import 'package:billing_and_sales_management/features/auth/providers/login_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void invalidateUserScopedData(Ref ref) {
  ref.invalidate(loginProvider);
}

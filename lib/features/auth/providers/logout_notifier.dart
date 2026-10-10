import 'package:billing_and_sales_management/data/auth/providers/auth_providers.dart';
import 'package:billing_and_sales_management/domain/auth/usecases/logout.dart';
import 'package:billing_and_sales_management/features/auth/providers/user_data_invalidation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final logoutUseCaseProvider = Provider<Logout>((ref) {
  return Logout(ref.watch(authRepositoryProvider));
});

class LogoutNotifier extends AsyncNotifier<void> {
  Future<void>? pendingLogout;

  @override
  Future<void> build() async {}

  Future<void> logout() {
    return pendingLogout ??= performLogout().whenComplete(() {
      pendingLogout = null;
    });
  }

  Future<void> performLogout() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() {
      return ref.read(logoutUseCaseProvider).call();
    });

    if (state.hasError) {
      return;
    }

    invalidateUserScopedData(ref);

    state = const AsyncData<void>(null);
  }
}

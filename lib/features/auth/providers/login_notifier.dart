import 'package:billing_and_sales_management/data/auth/providers/auth_providers.dart';
import 'package:billing_and_sales_management/domain/auth/entities/auth_user.dart';
import 'package:billing_and_sales_management/domain/auth/usecases/login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginNotifier extends AsyncNotifier<AuthUser?> {
  @override
  Future<AuthUser?> build() async {
    return null;
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return ref.read(loginUseCaseProvider).call(email, password);
    });
  }
}

final loginUseCaseProvider = Provider<Login>((ref) {
  return Login(ref.watch(authRepositoryProvider));
});

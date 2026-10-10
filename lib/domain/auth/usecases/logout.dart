import 'package:billing_and_sales_management/domain/auth/repositories/auth_repository.dart';

class Logout {
  const Logout(this.repository);

  final AuthRepository repository;

  Future<void> call() {
    return repository.signOut();
  }
}

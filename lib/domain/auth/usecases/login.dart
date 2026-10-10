import 'package:billing_and_sales_management/domain/auth/entities/auth_user.dart';
import 'package:billing_and_sales_management/domain/auth/repositories/auth_repository.dart';

class Login {
  const Login(this.repository);

  final AuthRepository repository;

  Future<AuthUser> call(String email, String password) {
    return repository.signInWithEmailAndPassword(email.trim(), password);
  }
}

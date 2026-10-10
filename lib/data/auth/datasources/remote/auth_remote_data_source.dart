import 'package:billing_and_sales_management/domain/auth/entities/auth_user.dart';

abstract interface class AuthRemoteDataSource {
  Stream<AuthUser?> get authStateChanges;

  AuthUser? get currentUser;

  Future<AuthUser> signIn(String email, String password);

  Future<void> signOut();
}

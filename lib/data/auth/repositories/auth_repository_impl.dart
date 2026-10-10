import 'package:billing_and_sales_management/data/auth/datasources/remote/auth_remote_data_source.dart';
import 'package:billing_and_sales_management/domain/auth/entities/auth_user.dart';
import 'package:billing_and_sales_management/domain/auth/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dataSource);

  final AuthRemoteDataSource _dataSource;

  @override
  Stream<AuthUser?> get authStateChanges => _dataSource.authStateChanges;

  @override
  AuthUser? get currentUser => _dataSource.currentUser;

  @override
  Future<AuthUser> signInWithEmailAndPassword(String email, String password) {
    return _dataSource.signIn(email, password);
  }

  @override
  Future<void> signOut() => _dataSource.signOut();
}

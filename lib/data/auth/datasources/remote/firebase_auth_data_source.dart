import 'package:billing_and_sales_management/core/errors/auth_exception.dart';
import 'package:billing_and_sales_management/data/auth/datasources/remote/auth_remote_data_source.dart';
import 'package:billing_and_sales_management/data/auth/models/auth_user_model.dart';
import 'package:billing_and_sales_management/domain/auth/entities/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthDataSource implements AuthRemoteDataSource {
  FirebaseAuthDataSource(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  @override
  Stream<AuthUser?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map(_mapUser);
  }

  @override
  AuthUser? get currentUser => _mapUser(_firebaseAuth.currentUser);

  @override
  Future<AuthUser> signIn(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const AuthException(AuthExceptionCodes.unknown);
      }
      return AuthUserModel.fromFirebase(user);
    } on FirebaseAuthException catch (e) {
      throw AuthException(mapFirebaseAuthErrorCode(e.code));
    }
  }

  @override
  Future<void> signOut() => _firebaseAuth.signOut();

  AuthUser? _mapUser(User? user) {
    return user == null ? null : AuthUserModel.fromFirebase(user);
  }

  static String mapFirebaseAuthErrorCode(String code) {
    switch (code) {
      case 'invalid-email':
        return AuthExceptionCodes.invalidEmail;
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
      case 'missing-password':
        return AuthExceptionCodes.invalidCredentials;
      case 'user-disabled':
        return AuthExceptionCodes.userDisabled;
      case 'network-request-failed':
        return AuthExceptionCodes.networkRequestFailed;
      case 'too-many-requests':
        return AuthExceptionCodes.tooManyRequests;
      default:
        return AuthExceptionCodes.unknown;
    }
  }
}

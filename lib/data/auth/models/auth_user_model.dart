import 'package:billing_and_sales_management/domain/auth/entities/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class AuthUserModel extends AuthUser {
  const AuthUserModel({required super.uid, required super.email});

  factory AuthUserModel.fromFirebase(fb.User user) {
    return AuthUserModel(uid: user.uid, email: user.email ?? '');
  }
}

import 'package:billing_and_sales_management/app.dart';
import 'package:billing_and_sales_management/core/theme/theme_storage.dart';
import 'package:billing_and_sales_management/firebase_options.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await ThemeStorage.instance.init();

  runApp(const BillingSalesApp());
}

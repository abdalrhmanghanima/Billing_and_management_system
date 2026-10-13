import 'package:billing_and_sales_management/core/translate/app_translate.dart';
import 'package:billing_and_sales_management/data/auth/providers/auth_providers.dart';
import 'package:billing_and_sales_management/domain/auth/repositories/auth_repository.dart';
import 'package:billing_and_sales_management/features/splash_screen.dart';
import 'package:billing_and_sales_management/features/theme/providers/theme_mode_provider.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BillingSalesApp extends StatelessWidget {
  const BillingSalesApp({super.key, this.authRepository});

  final AuthRepository? authRepository;

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      path: 'assets/languages',
      supportedLocales: const [Locale('en'), Locale('ar')],
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      useOnlyLangCode: true,
      child: ProviderScope(
        overrides: [
          if (authRepository != null)
            authRepositoryProvider.overrideWithValue(authRepository!),
        ],
        child: const _BillingSalesAppView(),
      ),
    );
  }
}

class _BillingSalesAppView extends ConsumerWidget {
  const _BillingSalesAppView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: AppTranslate.appName.tr(),
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      home: const SplashScreen(),
    );
  }
}

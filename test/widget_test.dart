import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:billing_and_sales_management/app.dart';
import 'package:billing_and_sales_management/features/auth/screens/login_screen.dart';
import 'package:billing_and_sales_management/features/splash_screen.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';

void main() {
  setUpAll(() async {
    const files = ['Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold'];
    final loader = FontLoader(AppTextStyles.fontFamily);
    for (final name in files) {
      final bytes = await File(
        'assets/fonts/PlusJakartaSans-$name.ttf',
      ).readAsBytes();
      loader.addFont(
        Future<ByteData>.value(
          ByteData.view(bytes.buffer, bytes.offsetInBytes, bytes.lengthInBytes),
        ),
      );
    }
    await loader.load();
  });

  group('SplashScreen', () {
    testWidgets('renders brand, logo and loader, then opens login', (
      tester,
    ) async {
      await tester.pumpWidget(const BillingSalesApp());

      expect(find.byType(SplashScreen), findsOneWidget);
      expect(find.text('Billing & Sales\nManagement'), findsOneWidget);
      expect(
        find.text('Manage your business easily and efficiently'),
        findsOneWidget,
      );
      expect(find.byType(Image), findsOneWidget);
      expect(find.text('Welcome Back'), findsNothing);

      await tester.pump(const Duration(milliseconds: 2600));
      await tester.pumpAndSettle(const Duration(milliseconds: 50));

      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(SplashScreen), findsNothing);
    });

    testWidgets('keeps splash content inside every target frame', (
      tester,
    ) async {
      const frames = [
        Size(375, 812),
        Size(390, 844),
        Size(393, 852),
        Size(430, 932),
      ];

      addTearDown(tester.view.reset);

      for (final frame in frames) {
        tester.view.physicalSize = frame;
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(const BillingSalesApp());
        expect(find.byType(SplashScreen), findsOneWidget);
        expect(tester.takeException(), isNull);

        await tester.pump(const Duration(milliseconds: 2600));
        await tester.pumpAndSettle(const Duration(milliseconds: 50));

        expect(find.byType(LoginScreen), findsOneWidget);
        expect(find.byType(SplashScreen), findsNothing);
        expect(tester.takeException(), isNull);

        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();
      }
    });
  });

  group('LoginScreen', () {
    testWidgets('renders the design structure', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Sign in to continue'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Enter your email'), findsOneWidget);
      expect(find.text('Enter password'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.widgetWithText(CustomButton, 'Sign In'), findsOneWidget);
      expect(find.text("Don't have an account?"), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('shows field validation from the design', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      await tester.tap(find.widgetWithText(CustomButton, 'Sign In'));
      await tester.pump();
      expect(find.text('Email is required'), findsOneWidget);

      await tester.enterText(
        find.byType(TextFormField).first,
        'ahmed@business.com',
      );
      await tester.tap(find.widgetWithText(CustomButton, 'Sign In'));
      await tester.pump();
      expect(find.text('Email is required'), findsNothing);
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('signs in locally and shows the success toast', (tester) async {
      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      await tester.enterText(
        find.byType(TextFormField).first,
        'ahmed@business.com',
      );
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.widgetWithText(CustomButton, 'Sign In'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));

      expect(find.text('Welcome back, Ahmed!'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 3000));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Welcome back, Ahmed!'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('keeps the form usable on every target frame', (tester) async {
      const frames = [
        Size(375, 812),
        Size(390, 844),
        Size(393, 852),
        Size(430, 932),
      ];

      for (final frame in frames) {
        tester.view.physicalSize = frame;
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
        await tester.pump();

        expect(find.widgetWithText(CustomButton, 'Sign In'), findsOneWidget);
        expect(tester.takeException(), isNull);
      }

      tester.view.reset();
    });
  });

  group('ResponsiveService', () {
    test('scales relative to the 390 design frame', () {
      expect(ResponsiveService.computeScale(shortSide: 390), 1.0);

      final small = ResponsiveService.computeScale(shortSide: 375);
      expect(small, inInclusiveRange(0.85, 1.0));

      final large = ResponsiveService.computeScale(shortSide: 430);
      expect(large, inInclusiveRange(1.0, 1.15));

      expect(ResponsiveService.computeScale(shortSide: 1000), 1.15);
      expect(ResponsiveService.computeScale(shortSide: 200), 0.85);
    });
  });

  group('theme tokens', () {
    test('light and dark use the reference palette', () {
      final light = AppTheme.light();
      final dark = AppTheme.dark();

      expect(light.colorScheme.primary, AppColors.primary);
      expect(light.colorScheme.tertiary, AppColors.coral);
      expect(light.textTheme.bodyLarge?.fontFamily, AppTextStyles.fontFamily);

      expect(dark.colorScheme.brightness, Brightness.dark);
      expect(
        dark.scaffoldBackgroundColor,
        isNot(light.scaffoldBackgroundColor),
      );
    });

    test('inputs and buttons follow the design metrics', () {
      final theme = AppTheme.light();

      final input = theme.inputDecorationTheme;
      expect(input.filled, isTrue);
      expect(
        input.border,
        isA<OutlineInputBorder>().having(
          (b) => b.borderRadius,
          'borderRadius',
          BorderRadius.circular(AppDimensions.inputRadius),
        ),
      );

      final button = theme.elevatedButtonTheme.style;
      expect(button, isNotNull);
      final minSize = button!.minimumSize?.resolve(const <WidgetState>{});
      expect(minSize, const Size(0, AppDimensions.inputHeight));
    });
  });
}

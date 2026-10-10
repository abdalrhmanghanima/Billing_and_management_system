import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:billing_and_sales_management/core/app_assets.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';
import 'package:billing_and_sales_management/features/auth/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1250),
  );

  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _pulse.repeat(reverse: true);

    _navigationTimer = Timer(const Duration(milliseconds: 2400), _openLogin);
  }

  void _openLogin() {
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (context) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.splashOuter,
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0, -0.4),
              radius: 1.6,
              colors: const [
                AppColors.splashInner,
                AppColors.primaryDark,
                AppColors.splashOuter,
              ],
              stops: const [0, 0.6, 1],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              const CustomPaint(painter: _SplashWavePainter()),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 60.h, 24.w, 40.h),
                  child: Center(child: _buildCenterContent()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLogoBadge(),
        SizedBox(height: AppSpacing.xl.h),
        CustomText(
          text: 'Billing & Sales\nManagement',
          style: AppTextStyles.heroTitle,
          color: AppColors.white,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSpacing.sm.h),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 240.w),
          child: CustomText(
            text: 'Manage your business easily and efficiently',
            style: AppTextStyles.bodySmall.copyWith(
              height: AppTextStyles.heightRelaxed,
            ),
            color: AppColors.white.withValues(alpha: 0.8),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildLogoBadge() {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        final t = _pulse.value;

        return Transform.scale(
          scale: 1 + 0.04 * t,
          child: Container(
            width: 108.r,
            height: 108.r,
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color.lerp(
                    AppColors.black.withValues(alpha: 0.35),
                    AppColors.cyanBrand.withValues(alpha: 0.4),
                    t,
                  )!,
                  offset: Offset(0, 12 + 6 * t),
                  blurRadius: 35 + 10 * t,
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: Image.asset(AppAssets.appLogo, fit: BoxFit.contain),
    );
  }
}

class _SplashWavePainter extends CustomPainter {
  const _SplashWavePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final spacing = 20.w;
    final radius = 1.r;

    final paint = Paint()..color = AppColors.cyanBrand.withValues(alpha: 0.15);

    var y = spacing / 2;

    while (y < size.height) {
      var x = spacing / 2;

      while (x < size.width) {
        canvas.drawCircle(Offset(x, y), radius, paint);

        x += spacing;
      }

      y += spacing;
    }
  }

  @override
  bool shouldRepaint(_SplashWavePainter oldDelegate) => false;
}

import 'package:flutter/material.dart';
import 'package:billing_and_sales_management/responsive/core/breakpoints.dart';

/// Builds a different widget tree per screen width class.
///
/// ```dart
/// ResponsiveBuilder(
///   mobile: (context) => const MobileView(),
///   tablet: (context) => const TabletView(),
///   desktop: (context) => const DesktopView(),
/// )
/// ```
///
/// [tablet] and [desktop] are optional:
/// * width >= 1024 -> [desktop] ?? [tablet] ?? [mobile]
/// * width 600-1023 -> [tablet] ?? [mobile]
/// * width < 600 -> [mobile]
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  final Widget Function(BuildContext context) mobile;
  final Widget Function(BuildContext context)? tablet;
  final Widget Function(BuildContext context)? desktop;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width >= AppBreakpoints.tabletMaxWidth) {
      return (desktop ?? tablet ?? mobile)(context);
    }
    if (width >= AppBreakpoints.mobileMaxWidth) {
      return (tablet ?? mobile)(context);
    }
    return mobile(context);
  }
}

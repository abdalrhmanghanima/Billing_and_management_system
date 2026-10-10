import 'package:flutter/material.dart';
import 'package:billing_and_sales_management/responsive/core/responsive_extensions.dart';

/// Spacing tokens extracted from the reference design
/// (`--spacing-*` in `css/variables.css`) plus the page paddings used by the
/// design's screens.
///
/// All values are design units of the reference mobile frame (390 x 844).
/// Scale them with `.w` / `.h` / `.r` where a responsive value is needed.
class AppSpacing {
  AppSpacing._();

  static const double s3xs = 2;
  static const double s2xs = 4;
  static const double xs = 6;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double s2xl = 32;
  static const double s3xl = 40;

  // Gaps used repeatedly by the design's screens.
  static const double cardGap = 10;
  static const double cardPaddingVertical = 14;
  static const double fieldLabelGap = xs;
  static const double formGroupGap = base;
  static const double sectionGap = 20;

  // Page paddings (design: `14px 18px 24px` for screen content).
  static const double pageHorizontal = 18;
  static const double pageTop = 14;
  static const double pageBottom = 24;

  /// Default page padding in design units (design `14px 18px 24px`).
  static EdgeInsets get page => const EdgeInsets.fromLTRB(
    pageHorizontal,
    pageTop,
    pageHorizontal,
    pageBottom,
  );

  /// Same as [page] scaled for the current screen.
  static EdgeInsets get pageResponsive => EdgeInsets.fromLTRB(
    pageHorizontal.w,
    pageTop.h,
    pageHorizontal.w,
    pageBottom.h,
  );
}

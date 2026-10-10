import 'dart:math';

import 'package:flutter/material.dart';
import 'package:billing_and_sales_management/responsive/core/breakpoints.dart';
import 'package:billing_and_sales_management/responsive/core/responsive_extensions.dart';
import 'package:billing_and_sales_management/responsive/core/responsive_service.dart';
import 'package:billing_and_sales_management/responsive/theme/app_dimensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_spacing.dart';

/// Width/height, safe-area, phone-class and breakpoint helpers available on
/// every [BuildContext].
extension ResponsiveContextX on BuildContext {
  /// Width of the screen (from the ambient [MediaQuery]).
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Height of the screen (from the ambient [MediaQuery]).
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Orientation of the screen.
  Orientation get screenOrientation => MediaQuery.orientationOf(this);

  /// Device class derived from [screenWidth].
  DeviceType get deviceType => AppBreakpoints.deviceTypeFor(screenWidth);

  /// True below [AppBreakpoints.mobileMaxWidth] (< 600).
  bool get isMobile => deviceType == DeviceType.mobile;

  /// True for 600 - 1023.
  bool get isTablet => deviceType == DeviceType.tablet;

  /// True for >= 1024.
  bool get isDesktop => deviceType == DeviceType.desktop;

  /// True for >= 1440.
  bool get isLargeDesktop => screenWidth >= AppBreakpoints.largeDesktopMinWidth;

  /// True for tablet + desktop widths (where layouts may use extra space).
  bool get isLargeScreen => !isMobile;

  /// True when the screen is in landscape orientation.
  bool get isLandscape => screenOrientation == Orientation.landscape;

  // ---------------------------------------------------------------------------
  // Phone classes (the design targets 375 / 390 / 393 / 430 frames)
  // ---------------------------------------------------------------------------

  /// Compact phone (<= 375): iPhone SE, small Android devices.
  bool get isSmallPhone => screenWidth <= AppBreakpoints.smallPhoneMaxWidth;

  /// Normal phone (376 - 413): the design's 390 / 393 targets.
  bool get isNormalPhone => !isSmallPhone && !isLargePhone;

  /// Large phone (>= 414): Pro Max class devices, design target 430.
  bool get isLargePhone => screenWidth >= AppBreakpoints.largePhoneMinWidth;

  // ---------------------------------------------------------------------------
  // Scaling
  // ---------------------------------------------------------------------------

  /// Uniform design-to-device scale factor (`.w` / `.h` / `.r` divisor).
  double get screenScale => ResponsiveService.scale();

  /// Text scale factor of the design tokens (narrower band than [screenScale]).
  double get designTextScale => ResponsiveService.scaleText();

  /// Scale factor with accessibility text scaling applied on top.
  double get deviceTextScale =>
      designTextScale * MediaQuery.textScalerOf(this).scale(1.0);

  // ---------------------------------------------------------------------------
  // Safe areas
  // ---------------------------------------------------------------------------

  /// System insets (status bar, notch, home indicator, keyboard excluded).
  EdgeInsets get safeArea => MediaQuery.paddingOf(this);

  /// Top inset (status bar / notch / dynamic island).
  double get safeAreaTop => safeArea.top;

  /// Bottom inset (home indicator / gesture bar).
  double get safeAreaBottom => safeArea.bottom;

  /// Height of the on-screen keyboard.
  double get keyboardHeight => MediaQuery.viewInsetsOf(this).bottom;

  /// True while the keyboard is open.
  bool get isKeyboardVisible => keyboardHeight > 0;

  // ---------------------------------------------------------------------------
  // Responsive paddings & dimensions
  // ---------------------------------------------------------------------------

  /// Page padding of the reference design (`14 18 24`), scaled.
  EdgeInsets get pagePadding => AppSpacing.pageResponsive;

  /// Horizontal page padding (`18` design px), scaled.
  EdgeInsets get horizontalPadding =>
      EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal.w);

  /// Total height of the design's bottom navigation (72 design px including
  /// its 12 px bottom padding), enlarged by the home-indicator inset.
  double get bottomNavTotalHeight =>
      AppDimensions.bottomNavContentHeight.h +
      max(AppDimensions.bottomNavBottomPadding.h, safeAreaBottom);

  /// Extra space a scroll view needs at the bottom so content clears the
  /// bottom navigation.
  double get bottomNavClearance => bottomNavTotalHeight + AppSpacing.base.h;

  /// Content width cap used on tablets and desktops.
  double get screenContentMaxWidth => AppBreakpoints.screenContentMaxWidth;

  // ---------------------------------------------------------------------------
  // Columns
  // ---------------------------------------------------------------------------

  /// Number of card columns that fit into the current screen width.
  int cardColumnsFor({
    double minCardWidth = 340,
    double spacing = 16,
    int maxColumns = 3,
  }) {
    return AppBreakpoints.columnsFor(
      screenWidth,
      minCardWidth: minCardWidth,
      spacing: spacing,
      maxColumns: maxColumns,
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';

/// Responsive scaling service.
///
/// The reference design is a mobile frame of 390 x 844 (iPhone 15) where all
/// tokens are absolute design pixels. Every design unit is converted to a
/// device pixel with a single, uniform scale factor:
///
/// ```
/// scale = clamp(shortestScreenSide / 390, 0.85, 1.15)
/// ```
///
/// Using the shortest side keeps component proportions intact (a 48 px button
/// never becomes shorter than it is wide), works in both orientations and
/// reacts to the width of the device - which is what the design actually
/// responds to. The clamp keeps very small phones readable and stops tablets
/// and desktops from stretching the mobile design.
class ResponsiveService {
  ResponsiveService._();

  /// Reference design frame of the reference design (portrait).
  static const Size designSize = Size(390, 844);

  /// Lower bound of the uniform scale (small phones, e.g. 320 - 340 wide).
  static const double minScale = 0.85;

  /// Upper bound of the uniform scale (tablets, desktop, large windows).
  static const double maxScale = 1.15;

  /// Lower bound of the text scale so small text never becomes unreadable.
  static const double minTextScale = 0.9;

  /// Upper bound of the text scale.
  static const double maxTextScale = 1.1;

  static MediaQueryData get _mediaQueryData {
    final view = WidgetsBinding.instance.platformDispatcher.implicitView;
    if (view == null) {
      return MediaQueryData(size: designSize);
    }
    return MediaQueryData.fromView(view);
  }

  /// Full screen width (design-agnostic).
  static double fullScreenWidth({double ratio = 1}) =>
      _mediaQueryData.size.width * ratio;

  /// Full screen height (design-agnostic).
  static double fullScreenHeight({double ratio = 1}) =>
      _mediaQueryData.size.height * ratio;

  /// Screen width minus view paddings (safe areas).
  static double availableScreenWidth({double ratio = 1}) =>
      (_mediaQueryData.size.width - _mediaQueryData.viewPadding.horizontal) *
      ratio;

  /// Screen height minus view paddings (safe areas).
  static double availableScreenHeight({double ratio = 1}) =>
      (_mediaQueryData.size.height - _mediaQueryData.viewPadding.vertical) *
      ratio;

  /// Current orientation.
  static Orientation orientation() => _mediaQueryData.orientation;

  /// Top padding (status bar / notch).
  static double deviceTopPadding() => _mediaQueryData.padding.top;

  /// Bottom padding (home indicator / gesture bar).
  static double deviceBottomPadding() => _mediaQueryData.padding.bottom;

  /// Height of the on-screen keyboard.
  static double deviceKeyboardHeight() => _mediaQueryData.viewInsets.bottom;

  /// Current text scale factor from the accessibility settings.
  static double textScaleFactor() => _mediaQueryData.textScaler.scale(1.0);

  /// Device pixel ratio.
  static double devicePixelRatio() => _mediaQueryData.devicePixelRatio;

  /// Uniform scale factor used by `.w`, `.h`, `.r` and `.sp`.
  static double scale() => computeScale(
    shortSide: min(_mediaQueryData.size.width, _mediaQueryData.size.height),
    designShortSide: designSize.shortestSide,
  );

  /// Scale factor for horizontal design units (same uniform factor).
  static double scaleWidth() => scale();

  /// Scale factor for vertical design units (same uniform factor so component
  /// proportions stay identical to the design).
  static double scaleHeight() => scale();

  /// Scale factor for radii and spacing.
  static double scaleRadius() => scale();

  /// Scale factor for text - a narrower band than the layout scale so font
  /// sizes stay close to the design on very small and very large screens.
  static double scaleText() => computeScale(
    shortSide: min(_mediaQueryData.size.width, _mediaQueryData.size.height),
    designShortSide: designSize.shortestSide,
    min: minTextScale,
    max: maxTextScale,
  );

  /// Pure scale computation - exposed for tests and custom tooling.
  ///
  /// [shortSide] is the shortest side of the screen, [designShortSide] the
  /// shortest side of the reference frame (390).
  static double computeScale({
    required double shortSide,
    double designShortSide = 390,
    double min = minScale,
    double max = maxScale,
  }) {
    if (designShortSide <= 0 || shortSide <= 0) return 1;
    return (shortSide / designShortSide).clamp(min, max);
  }

  /// Scale factor of the current screen without clamping - useful for
  /// diagnostics and screenshots.
  static double rawScale() {
    final size = _mediaQueryData.size;
    if (size.shortestSide <= 0) return 1;
    return size.shortestSide / designSize.shortestSide;
  }
}

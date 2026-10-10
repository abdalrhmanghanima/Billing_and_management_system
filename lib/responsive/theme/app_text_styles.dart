import 'package:flutter/material.dart';

/// Typography tokens extracted from the reference design
/// (`--font-size-*`, `--font-weight-*`, `--line-height-*` in
/// `css/variables.css`).
///
/// Use these semantic styles instead of `TextStyle(...)` in screens so the
/// whole app stays on the design's type scale. Colors are intentionally left
/// `null` so every style follows the active [ThemeData].
class AppTextStyles {
  AppTextStyles._();

  /// Font family bundled in `pubspec.yaml` (design `--font-family`).
  static const String fontFamily = 'PlusJakartaSans';

  /// Design font sizes (`--font-size-*`).
  static const double size2xs = 10;
  static const double sizeXs = 11;
  static const double sizeSm = 13;
  static const double sizeBase = 14;
  static const double sizeMd = 15;
  static const double sizeLg = 17;
  static const double sizeXl = 20;
  static const double size2xl = 24;
  static const double size3xl = 28;
  static const double size4xl = 32;

  /// Design line heights (`--line-height-*`).
  static const double heightTight = 1.15;
  static const double heightSnug = 1.3;
  static const double heightNormal = 1.45;
  static const double heightRelaxed = 1.6;

  static TextStyle _base({
    required double fontSize,
    required FontWeight fontWeight,
    double? height,
    double? letterSpacing,
    TextDecoration decoration = TextDecoration.none,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  // ---------------------------------------------------------------------------
  // Material slot styles (mapped into ThemeData's TextTheme)
  // ---------------------------------------------------------------------------

  /// Largest display text (splash / marketing hero).
  static TextStyle get display => _base(
    fontSize: size4xl,
    fontWeight: FontWeight.w800,
    height: heightTight,
  );

  /// Page level headline (auth / onboarding titles).
  static TextStyle get headline => _base(
    fontSize: size2xl,
    fontWeight: FontWeight.w800,
    height: 1.25,
    letterSpacing: -0.3,
  );

  /// Section heading (dashboard title).
  static TextStyle get title =>
      _base(fontSize: sizeXl, fontWeight: FontWeight.w800, height: 1.25);

  /// Card / block title.
  static TextStyle get subtitle =>
      _base(fontSize: sizeLg, fontWeight: FontWeight.w700, height: 1.3);

  /// Default body text.
  static TextStyle get body => _base(
    fontSize: sizeBase,
    fontWeight: FontWeight.w400,
    height: heightNormal,
  );

  /// Slightly emphasized body text.
  static TextStyle get bodyMedium => _base(
    fontSize: sizeBase,
    fontWeight: FontWeight.w500,
    height: heightNormal,
  );

  /// Secondary / compact body text.
  static TextStyle get bodySmall => _base(
    fontSize: sizeSm,
    fontWeight: FontWeight.w400,
    height: heightNormal,
  );

  /// Field labels and compact UI labels.
  static TextStyle get label =>
      _base(fontSize: sizeSm, fontWeight: FontWeight.w600, height: heightSnug);

  /// Hints, timestamps and meta text.
  static TextStyle get caption =>
      _base(fontSize: sizeXs, fontWeight: FontWeight.w400, height: 1.4);

  /// Button labels.
  static TextStyle get button =>
      _base(fontSize: sizeBase, fontWeight: FontWeight.w600, height: 1.2);

  // ---------------------------------------------------------------------------
  // Semantic styles used across the design's screens
  // ---------------------------------------------------------------------------

  /// Splash / auth / onboarding hero title (24 / 800).
  static TextStyle get heroTitle => headline;

  /// Dashboard screen title (20 / 800).
  static TextStyle get pageTitle => title;

  /// Section header row title (15 / 700).
  static TextStyle get sectionTitle =>
      _base(fontSize: sizeMd, fontWeight: FontWeight.w700, height: heightSnug);

  /// App bar / bottom sheet title (15 / 700).
  static TextStyle get appBarTitle => sectionTitle;

  /// Entity & list tile title (14 / 600).
  static TextStyle get cardTitle => _base(
    fontSize: sizeBase,
    fontWeight: FontWeight.w600,
    height: heightSnug,
  );

  /// Regular paragraph text (14 / 400).
  static TextStyle get bodyText => body;

  /// Emphasized value text (14 / 600).
  static TextStyle get bodyStrong => _base(
    fontSize: sizeBase,
    fontWeight: FontWeight.w600,
    height: heightNormal,
  );

  /// Supporting paragraph (13 / 400).
  static TextStyle get secondaryText => bodySmall;

  /// Meta / subtitle text under a title (11 / 400).
  static TextStyle get metaText => caption;

  /// Stat label / uppercase micro label (10 / 500).
  static TextStyle get microLabel => _base(
    fontSize: size2xs,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.3,
  );

  /// Status badge text (10 / 700, letterspaced, uppercase by the caller).
  static TextStyle get badge => _base(
    fontSize: size2xs,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: 0.3,
  );

  /// Bottom navigation label (10 / 500).
  static TextStyle get navLabel =>
      _base(fontSize: size2xs, fontWeight: FontWeight.w500, height: 1.2);

  /// Selected bottom navigation label (10 / 700).
  static TextStyle get navLabelActive =>
      navLabel.copyWith(fontWeight: FontWeight.w700);

  /// Small button label (13 / 600).
  static TextStyle get buttonSmall =>
      _base(fontSize: sizeSm, fontWeight: FontWeight.w600, height: 1.2);

  /// Input text (14 / 400).
  static TextStyle get inputText => body;

  /// Field validation hint (11 / 500).
  static TextStyle get fieldError =>
      _base(fontSize: sizeXs, fontWeight: FontWeight.w500, height: 1.3);

  /// Stat value / amount (17 / 800).
  static TextStyle get amount =>
      _base(fontSize: sizeLg, fontWeight: FontWeight.w800, height: 1.2);

  /// Hero amount, e.g. total sales (28 / 800).
  static TextStyle get amountLarge => _base(
    fontSize: size3xl,
    fontWeight: FontWeight.w800,
    height: 1.15,
    letterSpacing: -0.5,
  );
}

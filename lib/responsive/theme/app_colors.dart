import 'package:flutter/material.dart';

/// Color tokens extracted from the reference design
/// (`Billing & Sales Management design/css/variables.css`).
///
/// This single file is the color source of truth for the whole application.
/// Never hardcode a color literal elsewhere - use these names or
/// `Theme.of(context).colorScheme`.
class AppColors {
  AppColors._();

  // Brand identity (from the official logo).
  static const Color primary = Color(0xFF0B678F);
  static const Color primaryDark = Color(0xFF084E6D);
  static const Color primaryDarker = Color(0xFF063C54);
  static const Color primaryLight = Color(0xFF167B9E);
  static const Color primaryLighter = Color(0xFF2394BB);
  static const Color primarySubtle = Color(0xFFE8F4F8);
  static const Color primaryTint = Color(0xFFF0F8FA);

  static const Color splashInner = Color(0xFF0E77A4);
  static const Color splashOuter = Color(0xFF053347);

  // Accent & highlight.
  static const Color cyanBrand = Color(0xFF29A9E1);
  static const Color cyanLight = Color(0xFFE6F6FD);
  static const Color cyanDark = Color(0xFF1982B0);
  static const Color coral = Color(0xFFF76D43);
  static const Color coralHover = Color(0xFFE45B31);
  static const Color coralSubtle = Color(0xFFFFF2ED);
  static const Color coralBorder = Color(0xFFFFD4C4);

  static const Color purple = Color(0xFF7E22CE);
  static const Color purpleSubtle = Color(0xFFF3E8FF);

  // Semantic feedback.
  static const Color success = Color(0xFF10B981);
  static const Color successBg = Color(0xFFECFDF5);
  static const Color successBorder = Color(0xFFA7F3D0);
  static const Color successText = Color(0xFF065F46);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningBg = Color(0xFFFFFBEB);
  static const Color warningBorder = Color(0xFFFDE68A);
  static const Color warningText = Color(0xFF92400E);

  static const Color error = Color(0xFFEF4444);
  static const Color errorBg = Color(0xFFFEF2F2);
  static const Color errorBorder = Color(0xFFFECACA);
  static const Color errorText = Color(0xFF991B1B);

  static const Color info = Color(0xFF0284C7);
  static const Color infoBg = Color(0xFFF0F9FF);
  static const Color infoBorder = Color(0xFFBAE6FD);

  // Neutral scale.
  static const Color neutral950 = Color(0xFF090D16);
  static const Color neutral900 = Color(0xFF0F172A);
  static const Color neutral800 = Color(0xFF1E293B);
  static const Color neutral700 = Color(0xFF334155);
  static const Color neutral600 = Color(0xFF475569);
  static const Color neutral500 = Color(0xFF64748B);
  static const Color neutral400 = Color(0xFF94A3B8);
  static const Color neutral300 = Color(0xFFCBD5E1);
  static const Color neutral200 = Color(0xFFE2E8F0);
  static const Color neutral150 = Color(0xFFEDF2F7);
  static const Color neutral100 = Color(0xFFF1F5F9);
  static const Color neutral50 = Color(0xFFF8FAFC);

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;

  // ---------------------------------------------------------------------
  // Semantic roles - the names used by the widgets and the theme.
  // ---------------------------------------------------------------------

  /// Default page background (`--neutral-50`).
  static const Color background = neutral50;

  /// Raised surfaces: bars, sheets, dialogs, cards.
  static const Color surface = white;

  /// Alias of [surface] (card fills are white as well).
  static const Color card = white;

  /// Foreground on top of [primary] / [coral].
  static const Color onPrimary = white;

  /// Primary text (`--neutral-900`).
  static const Color textPrimary = neutral900;

  /// Secondary text (`--neutral-600`).
  static const Color textSecondary = neutral600;

  /// Muted / hint text (`--neutral-500`).
  static const Color textMuted = neutral500;

  /// Disabled text (`--neutral-400`).
  static const Color textDisabled = neutral400;

  /// Borders, dividers and outlines (`--neutral-200`).
  static const Color border = neutral200;

  /// Disabled surface (`--neutral-300`).
  static const Color disabled = neutral300;

  // ---------------------------------------------------------------------
  // Dark palette (used by AppTheme.dark)
  // ---------------------------------------------------------------------

  /// Dark page background (design canvas `#0B1520`).
  static const Color darkBackground = Color(0xFF0B1520);

  /// Dark raised surfaces.
  static const Color darkSurface = neutral900;

  /// Dark card backgrounds.
  static const Color darkCard = neutral800;

  /// Dark borders and dividers.
  static const Color darkBorder = neutral700;

  /// Dark primary text.
  static const Color darkTextPrimary = neutral100;

  /// Dark secondary text.
  static const Color darkTextSecondary = neutral300;

  /// Dark muted text.
  static const Color darkTextMuted = neutral400;
}

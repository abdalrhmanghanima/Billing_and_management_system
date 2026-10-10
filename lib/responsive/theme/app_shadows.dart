import 'package:flutter/material.dart';

/// Elevation tokens extracted from the reference design
/// (`--shadow-*` in `css/variables.css`).
///
/// The design uses very subtle, brand-tinted elevations. Scale the blur /
/// offset with `.r` where appropriate.
class AppShadows {
  AppShadows._();

  /// `--shadow-xs`: resting cards.
  static const List<BoxShadow> xs = [
    BoxShadow(color: Color(0x0A0F172A), offset: Offset(0, 1), blurRadius: 2),
  ];

  /// `--shadow-sm`: hovered cards.
  static const List<BoxShadow> sm = [
    BoxShadow(color: Color(0x0D0F172A), offset: Offset(0, 2), blurRadius: 4),
    BoxShadow(color: Color(0x080F172A), offset: Offset(0, 1), blurRadius: 2),
  ];

  /// `--shadow-md`: brand-tinted medium elevation.
  static const List<BoxShadow> md = [
    BoxShadow(color: Color(0x140B678F), offset: Offset(0, 4), blurRadius: 12),
    BoxShadow(color: Color(0x0A0F172A), offset: Offset(0, 2), blurRadius: 4),
  ];

  /// `--shadow-lg`: floating panels.
  static const List<BoxShadow> lg = [
    BoxShadow(color: Color(0x1F0B678F), offset: Offset(0, 10), blurRadius: 25),
    BoxShadow(color: Color(0x0D0F172A), offset: Offset(0, 4), blurRadius: 10),
  ];

  /// `--shadow-xl`: modals / highest elevation.
  static const List<BoxShadow> xl = [
    BoxShadow(color: Color(0x29084E6D), offset: Offset(0, 20), blurRadius: 35),
    BoxShadow(color: Color(0x0F0F172A), offset: Offset(0, 8), blurRadius: 16),
  ];

  /// `--shadow-bottom-nav`.
  static const List<BoxShadow> bottomNav = [
    BoxShadow(color: Color(0x0D0F172A), offset: Offset(0, -4), blurRadius: 20),
    BoxShadow(color: Color(0x050F172A), offset: Offset(0, -1), blurRadius: 3),
  ];

  /// `--shadow-fab` (elevated central action button).
  static const List<BoxShadow> fab = [
    BoxShadow(color: Color(0x590B678F), offset: Offset(0, 8), blurRadius: 20),
    BoxShadow(color: Color(0x330B678F), offset: Offset(0, 3), blurRadius: 6),
  ];

  /// Primary button shadow (`.btn-primary`).
  static const List<BoxShadow> primaryButton = [
    BoxShadow(color: Color(0x400B678F), offset: Offset(0, 4), blurRadius: 12),
  ];

  /// Coral button shadow (`.btn-coral`).
  static const List<BoxShadow> coralButton = [
    BoxShadow(color: Color(0x4CF76D43), offset: Offset(0, 4), blurRadius: 14),
  ];

  /// Dialog / bottom sheet shadow.
  static const List<BoxShadow> modal = [
    BoxShadow(color: Color(0x33000000), offset: Offset(0, 10), blurRadius: 30),
  ];

  /// Splash logo badge glow.
  static const List<BoxShadow> logo = [
    BoxShadow(color: Color(0x59000000), offset: Offset(0, 12), blurRadius: 35),
  ];

  /// Scalable version of [xs] for cards.
  static List<BoxShadow> card({double elevation = 0}) {
    switch (elevation) {
      case <= 0:
        return xs;
      case 1:
        return sm;
      case 2:
        return md;
      default:
        return lg;
    }
  }

  /// Neutral scrim used behind modals (design backdrop `rgba(15,23,42,.55)`).
  static const Color scrim = Color(0x8C0F172A);
}

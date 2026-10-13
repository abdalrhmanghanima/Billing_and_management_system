import 'package:flutter/material.dart';
import 'package:billing_and_sales_management/responsive/theme/app_colors.dart';

/// Semantic role tokens resolved per brightness.
///
/// Widgets should read these through `context.palette` instead of the static
/// light-only values in [AppColors], so every surface responds correctly to
/// the active theme mode.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.subtleSurface,
    required this.insetSurface,
    required this.border,
    required this.subtleBorder,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textStrong,
    required this.textDisabled,
    required this.disabled,
    required this.accentText,
    required this.primarySubtle,
    required this.cyanLight,
    required this.cyanText,
    required this.coralSubtle,
    required this.coralBorder,
    required this.coralText,
    required this.purpleSubtle,
    required this.purpleText,
    required this.successBg,
    required this.successBorder,
    required this.successText,
    required this.warningBg,
    required this.warningBorder,
    required this.warningText,
    required this.errorBg,
    required this.errorBorder,
    required this.errorText,
    required this.infoBg,
    required this.infoBorder,
    required this.inputFill,
    required this.iconMuted,
    required this.overlayHover,
    required this.handleColor,
    required this.navShadowColor,
    required this.skeletonColors,
  });

  final Color background;
  final Color surface;
  final Color subtleSurface;
  final Color insetSurface;
  final Color border;
  final Color subtleBorder;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textStrong;
  final Color textDisabled;
  final Color disabled;

  /// Interactive accent text (links, selected options, outline buttons).
  final Color accentText;
  final Color primarySubtle;
  final Color cyanLight;
  final Color cyanText;
  final Color coralSubtle;
  final Color coralBorder;
  final Color coralText;
  final Color purpleSubtle;
  final Color purpleText;
  final Color successBg;
  final Color successBorder;
  final Color successText;
  final Color warningBg;
  final Color warningBorder;
  final Color warningText;
  final Color errorBg;
  final Color errorBorder;
  final Color errorText;
  final Color infoBg;
  final Color infoBorder;
  final Color inputFill;
  final Color iconMuted;
  final Color overlayHover;
  final Color handleColor;
  final Color navShadowColor;
  final List<Color> skeletonColors;

  static const AppPalette light = AppPalette(
    background: AppColors.background,
    surface: AppColors.surface,
    subtleSurface: AppColors.neutral100,
    insetSurface: AppColors.neutral50,
    border: AppColors.border,
    subtleBorder: AppColors.neutral150,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    textMuted: AppColors.textMuted,
    textStrong: AppColors.neutral700,
    textDisabled: AppColors.textDisabled,
    disabled: AppColors.disabled,
    accentText: AppColors.primary,
    primarySubtle: AppColors.primarySubtle,
    cyanLight: AppColors.cyanLight,
    cyanText: AppColors.cyanDark,
    coralSubtle: AppColors.coralSubtle,
    coralBorder: AppColors.coralBorder,
    coralText: AppColors.coral,
    purpleSubtle: AppColors.purpleSubtle,
    purpleText: AppColors.purple,
    successBg: AppColors.successBg,
    successBorder: AppColors.successBorder,
    successText: AppColors.successText,
    warningBg: AppColors.warningBg,
    warningBorder: AppColors.warningBorder,
    warningText: AppColors.warningText,
    errorBg: AppColors.errorBg,
    errorBorder: AppColors.errorBorder,
    errorText: AppColors.errorText,
    infoBg: AppColors.infoBg,
    infoBorder: AppColors.infoBorder,
    inputFill: AppColors.white,
    iconMuted: AppColors.neutral400,
    overlayHover: AppColors.neutral100,
    handleColor: AppColors.neutral300,
    navShadowColor: Color(0x140F172A),
    skeletonColors: [
      AppColors.neutral200,
      AppColors.neutral100,
      AppColors.neutral200,
    ],
  );

  static const AppPalette dark = AppPalette(
    background: AppColors.darkBackground,
    surface: AppColors.darkSurface,
    subtleSurface: AppColors.darkSubtleSurface,
    insetSurface: AppColors.darkInset,
    border: AppColors.darkBorder,
    subtleBorder: AppColors.darkSubtleBorder,
    textPrimary: AppColors.darkTextPrimary,
    textSecondary: AppColors.darkTextSecondary,
    textMuted: AppColors.darkTextMuted,
    textStrong: AppColors.darkTextStrong,
    textDisabled: AppColors.darkTextDisabled,
    disabled: AppColors.darkDisabled,
    accentText: AppColors.darkAccentText,
    primarySubtle: AppColors.darkPrimarySubtle,
    cyanLight: AppColors.darkCyanLight,
    cyanText: AppColors.darkCyanText,
    coralSubtle: AppColors.darkCoralSubtle,
    coralBorder: AppColors.darkCoralBorder,
    coralText: AppColors.coral,
    purpleSubtle: AppColors.darkPurpleSubtle,
    purpleText: AppColors.darkPurpleText,
    successBg: AppColors.darkSuccessBg,
    successBorder: AppColors.darkSuccessBorder,
    successText: AppColors.darkSuccessText,
    warningBg: AppColors.darkWarningBg,
    warningBorder: AppColors.darkWarningBorder,
    warningText: AppColors.darkWarningText,
    errorBg: AppColors.darkErrorBg,
    errorBorder: AppColors.darkErrorBorder,
    errorText: AppColors.darkErrorText,
    infoBg: AppColors.darkInfoBg,
    infoBorder: AppColors.darkInfoBorder,
    inputFill: AppColors.darkInset,
    iconMuted: AppColors.darkTextMuted,
    overlayHover: AppColors.darkHover,
    handleColor: AppColors.darkHandle,
    navShadowColor: Color(0x66000000),
    skeletonColors: [
      AppColors.darkHoverHigh,
      AppColors.darkHover,
      AppColors.darkHoverHigh,
    ],
  );

  @override
  AppPalette copyWith({
    Color? background,
    Color? surface,
    Color? subtleSurface,
    Color? insetSurface,
    Color? border,
    Color? subtleBorder,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? textStrong,
    Color? textDisabled,
    Color? disabled,
    Color? accentText,
    Color? primarySubtle,
    Color? cyanLight,
    Color? cyanText,
    Color? coralSubtle,
    Color? coralBorder,
    Color? coralText,
    Color? purpleSubtle,
    Color? purpleText,
    Color? successBg,
    Color? successBorder,
    Color? successText,
    Color? warningBg,
    Color? warningBorder,
    Color? warningText,
    Color? errorBg,
    Color? errorBorder,
    Color? errorText,
    Color? infoBg,
    Color? infoBorder,
    Color? inputFill,
    Color? iconMuted,
    Color? overlayHover,
    Color? handleColor,
    Color? navShadowColor,
    List<Color>? skeletonColors,
  }) {
    return AppPalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      subtleSurface: subtleSurface ?? this.subtleSurface,
      insetSurface: insetSurface ?? this.insetSurface,
      border: border ?? this.border,
      subtleBorder: subtleBorder ?? this.subtleBorder,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      textStrong: textStrong ?? this.textStrong,
      textDisabled: textDisabled ?? this.textDisabled,
      disabled: disabled ?? this.disabled,
      accentText: accentText ?? this.accentText,
      primarySubtle: primarySubtle ?? this.primarySubtle,
      cyanLight: cyanLight ?? this.cyanLight,
      cyanText: cyanText ?? this.cyanText,
      coralSubtle: coralSubtle ?? this.coralSubtle,
      coralBorder: coralBorder ?? this.coralBorder,
      coralText: coralText ?? this.coralText,
      purpleSubtle: purpleSubtle ?? this.purpleSubtle,
      purpleText: purpleText ?? this.purpleText,
      successBg: successBg ?? this.successBg,
      successBorder: successBorder ?? this.successBorder,
      successText: successText ?? this.successText,
      warningBg: warningBg ?? this.warningBg,
      warningBorder: warningBorder ?? this.warningBorder,
      warningText: warningText ?? this.warningText,
      errorBg: errorBg ?? this.errorBg,
      errorBorder: errorBorder ?? this.errorBorder,
      errorText: errorText ?? this.errorText,
      infoBg: infoBg ?? this.infoBg,
      infoBorder: infoBorder ?? this.infoBorder,
      inputFill: inputFill ?? this.inputFill,
      iconMuted: iconMuted ?? this.iconMuted,
      overlayHover: overlayHover ?? this.overlayHover,
      handleColor: handleColor ?? this.handleColor,
      navShadowColor: navShadowColor ?? this.navShadowColor,
      skeletonColors: skeletonColors ?? this.skeletonColors,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    final maxLen = skeletonColors.length > other.skeletonColors.length
        ? skeletonColors.length
        : other.skeletonColors.length;
    final colors = List<Color>.generate(maxLen, (i) {
      final a = skeletonColors[i % skeletonColors.length];
      final b = other.skeletonColors[i % other.skeletonColors.length];
      return Color.lerp(a, b, t)!;
    });

    return AppPalette(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      subtleSurface: Color.lerp(subtleSurface, other.subtleSurface, t)!,
      insetSurface: Color.lerp(insetSurface, other.insetSurface, t)!,
      border: Color.lerp(border, other.border, t)!,
      subtleBorder: Color.lerp(subtleBorder, other.subtleBorder, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textStrong: Color.lerp(textStrong, other.textStrong, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      accentText: Color.lerp(accentText, other.accentText, t)!,
      primarySubtle: Color.lerp(primarySubtle, other.primarySubtle, t)!,
      cyanLight: Color.lerp(cyanLight, other.cyanLight, t)!,
      cyanText: Color.lerp(cyanText, other.cyanText, t)!,
      coralSubtle: Color.lerp(coralSubtle, other.coralSubtle, t)!,
      coralBorder: Color.lerp(coralBorder, other.coralBorder, t)!,
      coralText: Color.lerp(coralText, other.coralText, t)!,
      purpleSubtle: Color.lerp(purpleSubtle, other.purpleSubtle, t)!,
      purpleText: Color.lerp(purpleText, other.purpleText, t)!,
      successBg: Color.lerp(successBg, other.successBg, t)!,
      successBorder: Color.lerp(successBorder, other.successBorder, t)!,
      successText: Color.lerp(successText, other.successText, t)!,
      warningBg: Color.lerp(warningBg, other.warningBg, t)!,
      warningBorder: Color.lerp(warningBorder, other.warningBorder, t)!,
      warningText: Color.lerp(warningText, other.warningText, t)!,
      errorBg: Color.lerp(errorBg, other.errorBg, t)!,
      errorBorder: Color.lerp(errorBorder, other.errorBorder, t)!,
      errorText: Color.lerp(errorText, other.errorText, t)!,
      infoBg: Color.lerp(infoBg, other.infoBg, t)!,
      infoBorder: Color.lerp(infoBorder, other.infoBorder, t)!,
      inputFill: Color.lerp(inputFill, other.inputFill, t)!,
      iconMuted: Color.lerp(iconMuted, other.iconMuted, t)!,
      overlayHover: Color.lerp(overlayHover, other.overlayHover, t)!,
      handleColor: Color.lerp(handleColor, other.handleColor, t)!,
      navShadowColor: Color.lerp(navShadowColor, other.navShadowColor, t)!,
      skeletonColors: colors,
    );
  }
}

extension AppPaletteExtension on BuildContext {
  AppPalette get palette =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.light;
}

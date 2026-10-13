import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:billing_and_sales_management/responsive/theme/app_colors.dart';
import 'package:billing_and_sales_management/responsive/theme/app_dimensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_palette.dart';
import 'package:billing_and_sales_management/responsive/theme/app_shadows.dart';
import 'package:billing_and_sales_management/responsive/theme/app_spacing.dart';
import 'package:billing_and_sales_management/responsive/theme/app_text_styles.dart';

/// Light and dark [ThemeData] built from the reference design tokens.
///
/// [AppColors], [AppTextStyles], [AppDimensions] and [AppShadows] hold the
/// raw values; this file only wires them into Flutter's theming system so no
/// screen ever has to define its own colors, radii or component styles.
class AppTheme {
  AppTheme._();

  /// Light theme (the design is a light, mobile-first UI).
  static ThemeData light() => _build(Brightness.light);

  /// Dark theme derived from the design's neutral scale.
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final background = isDark ? AppColors.darkBackground : AppColors.background;
    final surface = isDark ? AppColors.darkSurface : AppColors.surface;
    final card = isDark ? AppColors.darkCard : AppColors.card;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    final subtleBorder = isDark
        ? AppColors.darkSubtleBorder
        : AppColors.neutral200;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final textStrong = isDark ? AppColors.darkTextStrong : AppColors.neutral700;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.textMuted;

    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: brightness,
        ).copyWith(
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          primaryContainer: isDark
              ? AppColors.darkPrimarySubtle
              : AppColors.primarySubtle,
          onPrimaryContainer: isDark
              ? AppColors.darkAccentText
              : AppColors.primaryDark,
          secondary: AppColors.cyanBrand,
          onSecondary: AppColors.white,
          secondaryContainer: isDark
              ? AppColors.darkCyanLight
              : AppColors.cyanLight,
          onSecondaryContainer: isDark
              ? AppColors.darkCyanText
              : AppColors.cyanDark,
          tertiary: AppColors.coral,
          onTertiary: AppColors.white,
          tertiaryContainer: isDark
              ? AppColors.darkCoralSubtle
              : AppColors.coralSubtle,
          onTertiaryContainer: isDark ? AppColors.coral : AppColors.coralHover,
          error: AppColors.error,
          onError: AppColors.white,
          errorContainer: isDark ? AppColors.darkErrorBg : AppColors.errorBg,
          onErrorContainer: isDark
              ? AppColors.darkErrorText
              : AppColors.errorText,
          surface: surface,
          onSurface: textPrimary,
          onSurfaceVariant: textSecondary,
          surfaceContainerLowest: isDark
              ? AppColors.darkBackgroundDeep
              : AppColors.white,
          surfaceContainerLow: isDark ? AppColors.darkSurface : AppColors.white,
          surfaceContainer: isDark ? AppColors.darkCard : AppColors.white,
          surfaceContainerHigh: isDark
              ? AppColors.darkHover
              : AppColors.neutral100,
          surfaceContainerHighest: isDark
              ? AppColors.darkHoverHigh
              : AppColors.neutral100,
          outline: border,
          outlineVariant: isDark
              ? AppColors.darkSubtleBorder
              : AppColors.neutral150,
          shadow: AppColors.black,
          scrim: AppShadows.scrim,
          inverseSurface: isDark ? AppColors.neutral100 : AppColors.neutral900,
          onInverseSurface: isDark ? AppColors.neutral900 : AppColors.white,
          inversePrimary: AppColors.cyanBrand,
        );

    final textTheme = _textTheme(
      textPrimary,
      textStrong,
      textSecondary,
      textMuted,
    );

    final appBarTheme = _appBarTheme(textPrimary, background, isDark);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      fontFamily: AppTextStyles.fontFamily,
      textTheme: textTheme,
      scaffoldBackgroundColor: background,
      canvasColor: surface,
      primaryColor: AppColors.primary,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      dividerColor: border,
      extensions: [isDark ? AppPalette.dark : AppPalette.light],
      appBarTheme: appBarTheme,
      cardTheme: _cardTheme(card, border),
      dialogTheme: _dialogTheme(card, textPrimary, textSecondary),
      bottomSheetTheme: _bottomSheetTheme(surface),
      inputDecorationTheme: _inputDecoration(
        isDark: isDark,
        subtleBorder: subtleBorder,
        textMuted: textMuted,
        textSecondary: textSecondary,
        errorText: isDark ? AppColors.darkErrorText : AppColors.errorText,
      ),
      filledButtonTheme: FilledButtonThemeData(style: _filledButtonStyle()),
      elevatedButtonTheme: ElevatedButtonThemeData(style: _filledButtonStyle()),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: _outlineButtonStyle(isDark),
      ),
      textButtonTheme: TextButtonThemeData(style: _textButtonStyle(isDark)),
      navigationBarTheme: _navigationBarTheme(surface, textMuted, isDark),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? AppColors.darkHover : AppColors.neutral900,
        contentTextStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w500,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.s2xs,
        ),
        iconColor: textSecondary,
        textColor: textPrimary,
        titleTextStyle: AppTextStyles.cardTitle.copyWith(color: textPrimary),
        subtitleTextStyle: AppTextStyles.caption.copyWith(color: textMuted),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.white,
        selectedColor: isDark
            ? AppColors.darkPrimarySubtle
            : AppColors.primarySubtle,
        labelStyle: AppTextStyles.bodySmall.copyWith(color: textPrimary),
        side: BorderSide(color: subtleBorder),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        ),
      ),
      dividerTheme: DividerThemeData(color: border, thickness: 1, space: 1),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: isDark ? AppColors.darkAccentText : AppColors.primary,
        linearTrackColor: isDark ? AppColors.darkHover : AppColors.neutral100,
        circularTrackColor: isDark ? AppColors.darkHover : AppColors.neutral100,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        shape: CircleBorder(),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.primary,
        selectionColor: AppColors.primary.withValues(alpha: 0.2),
        selectionHandleColor: AppColors.primary,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Text theme
  // ---------------------------------------------------------------------------

  static TextTheme _textTheme(
    Color textPrimary,
    Color textStrong,
    Color textSecondary,
    Color textMuted,
  ) {
    return TextTheme(
      displayLarge: AppTextStyles.display.copyWith(color: textStrong),
      displayMedium: AppTextStyles.amountLarge.copyWith(color: textStrong),
      displaySmall: AppTextStyles.headline.copyWith(color: textStrong),
      headlineLarge: AppTextStyles.title.copyWith(color: textStrong),
      headlineMedium: AppTextStyles.title.copyWith(
        fontWeight: FontWeight.w700,
        color: textStrong,
      ),
      headlineSmall: AppTextStyles.subtitle.copyWith(color: textStrong),
      titleLarge: AppTextStyles.subtitle.copyWith(color: textStrong),
      titleMedium: AppTextStyles.sectionTitle.copyWith(color: textPrimary),
      titleSmall: AppTextStyles.cardTitle.copyWith(color: textPrimary),
      bodyLarge: AppTextStyles.body.copyWith(
        fontSize: AppTextStyles.sizeMd,
        color: textPrimary,
      ),
      bodyMedium: AppTextStyles.body.copyWith(color: textPrimary),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: textSecondary),
      labelLarge: AppTextStyles.button.copyWith(color: textPrimary),
      labelMedium: AppTextStyles.label.copyWith(color: textSecondary),
      labelSmall: AppTextStyles.microLabel.copyWith(color: textMuted),
    );
  }

  // ---------------------------------------------------------------------------
  // Component themes
  // ---------------------------------------------------------------------------

  static AppBarTheme _appBarTheme(
    Color textPrimary,
    Color background,
    bool isDark,
  ) {
    return AppBarTheme(
      backgroundColor: background,
      surfaceTintColor: Colors.transparent,
      foregroundColor: textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      toolbarHeight: AppDimensions.appBarHeight,
      titleTextStyle: AppTextStyles.appBarTitle.copyWith(color: textPrimary),
      iconTheme: IconThemeData(
        color: isDark ? AppColors.darkTextSecondary : AppColors.neutral700,
      ),
      systemOverlayStyle: isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
    );
  }

  static CardThemeData _cardTheme(Color card, Color border) {
    return CardThemeData(
      color: card,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        side: BorderSide(color: border),
      ),
    );
  }

  static DialogThemeData _dialogTheme(
    Color surface,
    Color textPrimary,
    Color textSecondary,
  ) {
    return DialogThemeData(
      backgroundColor: surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: AppTextStyles.subtitle.copyWith(color: textPrimary),
      contentTextStyle: AppTextStyles.body.copyWith(color: textSecondary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.dialogRadius),
      ),
    );
  }

  static BottomSheetThemeData _bottomSheetTheme(Color surface) {
    return BottomSheetThemeData(
      backgroundColor: surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      showDragHandle: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.sheetRadius),
        ),
      ),
    );
  }

  static InputDecorationTheme _inputDecoration({
    required bool isDark,
    required Color subtleBorder,
    required Color textMuted,
    required Color textSecondary,
    required Color errorText,
  }) {
    return InputDecorationTheme(
      filled: true,
      fillColor: isDark ? AppColors.darkInset : AppColors.white,
      isDense: false,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.inputHorizontalPadding,
        vertical: AppDimensions.inputContentVerticalPadding,
      ),
      hintStyle: AppTextStyles.body.copyWith(color: textMuted),
      labelStyle: AppTextStyles.label.copyWith(color: textSecondary),
      floatingLabelStyle: AppTextStyles.label.copyWith(
        color: isDark ? AppColors.darkAccentText : AppColors.primary,
      ),
      errorStyle: AppTextStyles.fieldError.copyWith(color: errorText),
      helperStyle: AppTextStyles.caption.copyWith(color: textMuted),
      prefixIconColor: isDark ? AppColors.darkTextMuted : AppColors.neutral400,
      suffixIconColor: isDark ? AppColors.darkTextMuted : AppColors.neutral400,
      errorMaxLines: 2,
      border: _inputBorder(subtleBorder, width: 1.5),
      enabledBorder: _inputBorder(subtleBorder, width: 1.5),
      focusedBorder: _inputBorder(
        isDark ? AppColors.darkAccentText : AppColors.primary,
        width: 1.5,
      ),
      errorBorder: _inputBorder(AppColors.error, width: 1.5),
      focusedErrorBorder: _inputBorder(AppColors.error, width: 1.5),
      disabledBorder: _inputBorder(subtleBorder, width: 1.5),
    );
  }

  static OutlineInputBorder _inputBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  static ButtonStyle _filledButtonStyle() {
    return ButtonStyle(
      backgroundColor: const WidgetStatePropertyAll(AppColors.primary),
      foregroundColor: const WidgetStatePropertyAll(AppColors.white),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      elevation: const WidgetStatePropertyAll(0),
      minimumSize: const WidgetStatePropertyAll(Size(0, 48)),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 20),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
        ),
      ),
      textStyle: WidgetStatePropertyAll(
        AppTextStyles.button.copyWith(color: AppColors.white),
      ),
    );
  }

  static ButtonStyle _outlineButtonStyle(bool isDark) {
    final accent = isDark ? AppColors.darkAccentText : AppColors.primary;

    return _filledButtonStyle().copyWith(
      backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
      foregroundColor: WidgetStatePropertyAll(accent),
      side: WidgetStatePropertyAll(BorderSide(color: accent, width: 1.5)),
      textStyle: WidgetStatePropertyAll(
        AppTextStyles.button.copyWith(color: accent),
      ),
    );
  }

  static ButtonStyle _textButtonStyle(bool isDark) {
    final accent = isDark ? AppColors.darkAccentText : AppColors.primary;

    return _filledButtonStyle().copyWith(
      backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
      foregroundColor: WidgetStatePropertyAll(accent),
      minimumSize: const WidgetStatePropertyAll(Size(0, 40)),
      textStyle: WidgetStatePropertyAll(
        AppTextStyles.button.copyWith(color: accent),
      ),
    );
  }

  static NavigationBarThemeData _navigationBarTheme(
    Color surface,
    Color textMuted,
    bool isDark,
  ) {
    return NavigationBarThemeData(
      backgroundColor: surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      height: AppDimensions.bottomNavHeight,
      indicatorColor: isDark
          ? AppColors.darkPrimarySubtle
          : AppColors.primarySubtle,
      labelTextStyle: WidgetStatePropertyAll(
        AppTextStyles.navLabel.copyWith(color: textMuted),
      ),
      iconTheme: WidgetStatePropertyAll(
        IconThemeData(color: textMuted, size: AppDimensions.navIconSize),
      ),
    );
  }
}

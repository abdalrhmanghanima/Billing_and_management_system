/// Component dimensions and corner radii extracted from the reference design
/// (`--radius-*`, `--input-height`, `--button-height`, ... in `css/variables.css`).
///
/// Values are design units of the reference mobile frame (390 x 844); scale
/// them with `.w` / `.h` / `.r` at the point of use.
class AppDimensions {
  AppDimensions._();

  // ---------------------------------------------------------------------------
  // Corner radii (design `--radius-*`)
  // ---------------------------------------------------------------------------

  static const double radiusXs = 4;
  static const double radiusSm = 6;
  static const double radiusMd = 10;
  static const double radiusLg = 14;
  static const double radiusXl = 18;
  static const double radius2xl = 24;
  static const double radiusFull = 9999;

  static const double cardRadius = radiusLg;
  static const double buttonRadius = radiusLg;
  static const double inputRadius = radiusLg;
  static const double dialogRadius = radiusXl;
  static const double sheetRadius = 28;
  static const double chipRadius = radiusFull;
  static const double searchRadius = radiusXl;
  static const double avatarRadius = radiusMd;
  static const double badgeRadius = radiusFull;

  // ---------------------------------------------------------------------------
  // Icon sizes
  // ---------------------------------------------------------------------------

  static const double iconXs = 13;
  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconLg = 24;
  static const double iconXl = 32;
  static const double navIconSize = 22;
  static const double stateIconSize = 36;

  // ---------------------------------------------------------------------------
  // Heights & fixed dimensions
  // ---------------------------------------------------------------------------

  static const double buttonHeight = 48;
  static const double buttonSmHeight = 38;
  static const double inputHeight = 48;
  static const double inputHorizontalPadding = 14;
  static const double inputContentVerticalPadding = 12;
  static const double inputPrefixWidth = 42;
  static const double inputSuffixWidth = 46;
  static const double textAreaMinHeight = 90;
  static const double appBarHeight = 56;
  static const double headerActionSize = 38;
  static const double iconButtonSize = 40;
  static const double searchHeight = 42;
  static const double filterButtonSize = 42;
  static const double bottomNavHeight = 72;
  static const double bottomNavContentHeight = 60;
  static const double bottomNavBottomPadding = 12;
  static const double centerFabSize = 52;
  static const double fabSize = 54;
  static const double avatarSize = 44;
  static const double emptyStateIconBox = 72;
  static const double stepperButtonSize = 38;
  static const double statusBarHeight = 44;
  static const double minTouchTarget = 48;
  static const double maxContentWidth = 560;

  // ---------------------------------------------------------------------------
  // Indicators
  // ---------------------------------------------------------------------------

  /// Spinner size inside buttons.
  static const double buttonLoadingSize = 20;

  /// Standalone loading indicator size.
  static const double loadingSize = 36;
}

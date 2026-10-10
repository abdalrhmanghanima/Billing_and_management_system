/// Centralized responsive breakpoints for the application.
///
/// Layouts react to the available width only - never to device models.
/// The reference design ships four mobile viewports: 375, 390, 393 and 430.
class AppBreakpoints {
  AppBreakpoints._();

  /// Widths at or below this value are compact phones (iPhone SE, small
  /// Android devices).
  static const double smallPhoneMaxWidth = 375;

  /// Widths at or above this value are large phones / phablets
  /// (design target 430).
  static const double largePhoneMinWidth = 414;

  /// Mobile: widths below this value keep the reference mobile design.
  static const double mobileMaxWidth = 600;

  /// Tablet: widths from [mobileMaxWidth] up to this value.
  static const double tabletMaxWidth = 1024;

  /// Desktop/web: widths of [tabletMaxWidth] and above.
  static const double desktopMinWidth = tabletMaxWidth;

  /// Large desktop: widths of this value and above.
  static const double largeDesktopMinWidth = 1440;

  /// Maximum width of the whole app frame (navigation + content) on very
  /// wide windows. Prevents the UI from stretching across a huge display.
  static const double appMaxWidth = 1440;

  /// Width of the persistent side navigation.
  static const double sideNavWidth = 240;

  /// Max width for search fields so they are not stretched.
  static const double searchMaxWidth = 640;

  /// Max width for form content.
  static const double formMaxWidth = 840;

  /// Minimum available width before form fields lay out in two columns.
  static const double formRowMinWidth = 520;

  /// Max width for menu-style content.
  static const double menuContentMaxWidth = 640;

  /// Max width for profile/details content.
  static const double detailsContentMaxWidth = 900;

  /// Max width for long documents.
  static const double documentMaxWidth = 1000;

  /// Max width of dialogs on large screens.
  static const double dialogMaxWidth = 460;

  /// Max width of bottom-sheet content on large screens.
  static const double bottomSheetMaxWidth = 560;

  /// Max width of centered auth/login cards.
  static const double loginMaxWidth = 460;

  /// Max width of screen content so it never stretches on tablets.
  static const double screenContentMaxWidth = 560;

  /// Device class derived from the available width.
  static DeviceType deviceTypeFor(double width) {
    if (width < mobileMaxWidth) return DeviceType.mobile;
    if (width < tabletMaxWidth) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  /// Number of card columns that fit into [availableWidth] without making
  /// any card narrower than [minCardWidth].
  static int columnsFor(
    double availableWidth, {
    double minCardWidth = 340,
    double spacing = 16,
    int maxColumns = 3,
  }) {
    if (availableWidth.isInfinite || availableWidth <= 0) return 1;
    final fit = ((availableWidth + spacing) / (minCardWidth + spacing)).floor();
    return fit.clamp(1, maxColumns);
  }
}

/// Device class derived from the available width.
enum DeviceType { mobile, tablet, desktop }

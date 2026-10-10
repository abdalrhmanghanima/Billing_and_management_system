import 'package:flutter/material.dart';
import 'package:billing_and_sales_management/responsive/core/breakpoints.dart';
import 'package:billing_and_sales_management/responsive/core/responsive_context.dart';
import 'package:billing_and_sales_management/responsive/navigation/responsive_bottom_nav.dart';
import 'package:billing_and_sales_management/responsive/navigation/responsive_side_nav.dart';

/// Where navigation is rendered.
enum NavigationDisplay {
  /// Resolve from the current breakpoint (mobile/tablet -> bottom,
  /// desktop -> side).
  automatic,

  /// Force the bottom navigation bar.
  bottom,

  /// Force the side navigation.
  side,
}

/// A single generic navigation destination.
///
/// The consuming app provides the actual items - the kit never hardcodes
/// destinations or localized labels.
class ResponsiveNavigationItem {
  const ResponsiveNavigationItem({
    required this.icon,
    required this.label,
    required this.value,
    this.selectedIcon,
    this.onTap,
  });

  /// Icon shown when the item is not selected.
  final IconData icon;

  /// Icon shown when the item is selected; defaults to [icon].
  final IconData? selectedIcon;

  /// Visible label (localized by the caller).
  final String label;

  /// Value/index reported through `onSelected`.
  final int value;

  /// Optional custom action. When set it replaces `onSelected`.
  final VoidCallback? onTap;
}

/// Switches between [ResponsiveBottomNav] and [ResponsiveSideNav] based on
/// the current breakpoint and the requested [display] mode.
class ResponsiveNavigation extends StatelessWidget {
  const ResponsiveNavigation({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    this.centerAction,
    this.display = NavigationDisplay.automatic,
    this.tabletDisplay = NavigationDisplay.bottom,
    this.sideNavWidth,
    this.sideNavHeader,
    this.backgroundColor,
    this.indicatorColor,
  });

  final List<ResponsiveNavigationItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  /// Central elevated action of the design's bottom bar (e.g. "+ Invoice").
  /// Ignored by the side navigation.
  final ResponsiveNavigationItem? centerAction;

  final NavigationDisplay display;

  /// How navigation behaves on tablet widths when [display] is
  /// [NavigationDisplay.automatic]. Defaults to the bottom bar.
  final NavigationDisplay tabletDisplay;

  final double? sideNavWidth;
  final Widget? sideNavHeader;
  final Color? backgroundColor;
  final Color? indicatorColor;

  /// Resolves the concrete navigation style for the current context.
  static NavigationDisplay resolve(
    BuildContext context, {
    NavigationDisplay display = NavigationDisplay.automatic,
    NavigationDisplay tabletDisplay = NavigationDisplay.bottom,
  }) {
    switch (display) {
      case NavigationDisplay.bottom:
        return NavigationDisplay.bottom;
      case NavigationDisplay.side:
        return NavigationDisplay.side;
      case NavigationDisplay.automatic:
        if (context.isDesktop) return NavigationDisplay.side;
        if (context.isTablet) {
          return tabletDisplay == NavigationDisplay.automatic
              ? NavigationDisplay.bottom
              : tabletDisplay;
        }
        return NavigationDisplay.bottom;
    }
  }

  @override
  Widget build(BuildContext context) {
    final resolved = resolve(
      context,
      display: display,
      tabletDisplay: tabletDisplay,
    );

    if (resolved == NavigationDisplay.side) {
      return ResponsiveSideNav(
        items: items,
        selectedIndex: selectedIndex,
        onSelected: onSelected,
        width: sideNavWidth ?? AppBreakpoints.sideNavWidth,
        header: sideNavHeader,
        backgroundColor: backgroundColor,
        selectedColor: indicatorColor,
      );
    }

    return ResponsiveBottomNav(
      items: items,
      selectedIndex: selectedIndex,
      onSelected: onSelected,
      centerAction: centerAction,
      backgroundColor: backgroundColor,
      indicatorColor: indicatorColor,
    );
  }
}

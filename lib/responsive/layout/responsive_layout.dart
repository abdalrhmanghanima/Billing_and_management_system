import 'package:flutter/material.dart';
import 'package:billing_and_sales_management/responsive/navigation/responsive_navigation.dart';

/// App shell that combines content with responsive navigation.
///
/// * Mobile / default tablet -> [ResponsiveBottomNav] under the content.
/// * Desktop -> [ResponsiveSideNav] beside the content.
///
/// ```dart
/// ResponsiveLayout(
///   items: items,
///   selectedIndex: index,
///   onSelected: (i) => setState(() => index = i),
///   appBar: CustomAppBar(title: 'Home'),
///   child: const HomeView(),
/// )
/// ```
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    required this.child,
    this.centerAction,
    this.navigationDisplay = NavigationDisplay.automatic,
    this.tabletNavigation = NavigationDisplay.bottom,
    this.appBar,
    this.floatingActionButton,
    this.backgroundColor,
    this.sideNavHeader,
    this.sideNavWidth,
    this.indicatorColor,
  });

  final List<ResponsiveNavigationItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  /// Central elevated action of the bottom bar (design's "+ Invoice").
  final ResponsiveNavigationItem? centerAction;

  /// The current page content.
  final Widget child;

  final NavigationDisplay navigationDisplay;
  final NavigationDisplay tabletNavigation;

  /// Rendered above the content (side mode) or by the [Scaffold] (bottom mode).
  final PreferredSizeWidget? appBar;

  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final Widget? sideNavHeader;
  final double? sideNavWidth;
  final Color? indicatorColor;

  @override
  Widget build(BuildContext context) {
    final display = ResponsiveNavigation.resolve(
      context,
      display: navigationDisplay,
      tabletDisplay: tabletNavigation,
    );

    final navigation = ResponsiveNavigation(
      items: items,
      selectedIndex: selectedIndex,
      onSelected: onSelected,
      centerAction: centerAction,
      display: display,
      sideNavHeader: sideNavHeader,
      sideNavWidth: sideNavWidth,
      indicatorColor: indicatorColor,
    );

    if (display == NavigationDisplay.side) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: Row(
          children: [
            navigation,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ?appBar,
                  Expanded(child: child),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: floatingActionButton,
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      body: child,
      bottomNavigationBar: navigation,
      floatingActionButton: floatingActionButton,
    );
  }
}

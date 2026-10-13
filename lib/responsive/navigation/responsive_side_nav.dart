import 'package:flutter/material.dart';
import 'package:billing_and_sales_management/responsive/core/breakpoints.dart';
import 'package:billing_and_sales_management/responsive/core/responsive_extensions.dart';
import 'package:billing_and_sales_management/responsive/navigation/responsive_navigation.dart';
import 'package:billing_and_sales_management/responsive/theme/app_dimensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_palette.dart';
import 'package:billing_and_sales_management/responsive/theme/app_spacing.dart';
import 'package:billing_and_sales_management/responsive/widgets/custom_text.dart';

/// Persistent side navigation (desktop) driven by generic
/// [ResponsiveNavigationItem]s.
///
/// RTL-safe: uses [EdgeInsetsDirectional] / [BorderDirectional] and rows that
/// mirror automatically.
class ResponsiveSideNav extends StatelessWidget {
  const ResponsiveSideNav({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    this.width = AppBreakpoints.sideNavWidth,
    this.header,
    this.backgroundColor,
    this.selectedColor,
    this.selectedLabelColor,
  });

  final List<ResponsiveNavigationItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  /// Width of the rail.
  final double width;

  /// Optional header (e.g. app logo/title) above the items.
  final Widget? header;

  final Color? backgroundColor;

  /// Highlight color of the selected item.
  final Color? selectedColor;

  /// Icon/label color of the selected item.
  final Color? selectedLabelColor;

  void _handle(ResponsiveNavigationItem item) {
    if (item.onTap != null) {
      item.onTap!();
    } else {
      onSelected(item.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final bg = backgroundColor ?? palette.surface;
    final highlight = selectedColor ?? palette.accentText;
    final highlightText = selectedLabelColor ?? palette.accentText;
    final index = selectedIndex.clamp(0, items.isEmpty ? 0 : items.length - 1);
    final radius = AppDimensions.radiusLg.r;

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: bg,
        border: BorderDirectional(end: BorderSide(color: palette.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (header != null)
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: AppSpacing.base.r,
                end: AppSpacing.base.r,
                top: AppSpacing.base.r,
                bottom: AppSpacing.sm.r,
              ),
              child: header!,
            ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsetsDirectional.all(AppSpacing.sm.r),
              itemCount: items.length,
              itemBuilder: (context, i) {
                final item = items[i];
                final selected = i == index;

                return Padding(
                  padding: EdgeInsetsDirectional.only(
                    bottom: AppSpacing.s2xs.r,
                  ),
                  child: Material(
                    color: selected
                        ? highlight.withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(radius),
                    child: InkWell(
                      onTap: () => _handle(item),
                      borderRadius: BorderRadius.circular(radius),
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(
                          start: AppSpacing.md.r,
                          end: AppSpacing.md.r,
                          top: AppSpacing.md.r,
                          bottom: AppSpacing.md.r,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              (selected ? item.selectedIcon : item.icon) ??
                                  item.icon,
                              size: AppDimensions.iconLg.r,
                              color: selected
                                  ? highlightText
                                  : palette.textSecondary,
                            ),
                            SizedBox(width: AppSpacing.md.r),
                            Expanded(
                              child: CustomText(
                                text: item.label,
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: selected
                                    ? highlightText
                                    : palette.textSecondary,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

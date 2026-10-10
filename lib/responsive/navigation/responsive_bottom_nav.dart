import 'dart:math';

import 'package:flutter/material.dart';
import 'package:billing_and_sales_management/responsive/core/responsive_context.dart';
import 'package:billing_and_sales_management/responsive/core/responsive_extensions.dart';
import 'package:billing_and_sales_management/responsive/navigation/responsive_navigation.dart';
import 'package:billing_and_sales_management/responsive/theme/app_colors.dart';
import 'package:billing_and_sales_management/responsive/theme/app_dimensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_shadows.dart';
import 'package:billing_and_sales_management/responsive/theme/app_spacing.dart';
import 'package:billing_and_sales_management/responsive/theme/app_text_styles.dart';

/// Bottom navigation bar (mobile / default tablet) driven by generic
/// [ResponsiveNavigationItem]s.
///
/// Matches the reference design (`.mobile-bottom-nav`):
/// * 72 design px tall (60 px of content + bottom inset),
/// * white surface, 1 px top border, upward shadow,
/// * 22 px icons with 10 px labels, active tab in brand primary,
/// * optional [centerAction] rendered as an elevated 52 px gradient button
///   that protrudes above the bar (design's central "+ Invoice" button).
class ResponsiveBottomNav extends StatelessWidget {
  const ResponsiveBottomNav({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    this.centerAction,
    this.backgroundColor,
    this.indicatorColor,
  });

  final List<ResponsiveNavigationItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  /// Optional central action button inserted in the middle of the bar.
  final ResponsiveNavigationItem? centerAction;

  final Color? backgroundColor;
  final Color? indicatorColor;

  void _handle(int index) {
    final item = items[index];
    if (item.onTap != null) {
      item.onTap!();
    } else {
      onSelected(index);
    }
  }

  void _handleCenter() {
    final action = centerAction;
    if (action == null) return;
    if (action.onTap != null) {
      action.onTap!();
    } else {
      onSelected(action.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty && centerAction == null) return const SizedBox.shrink();

    final index = items.isEmpty ? 0 : selectedIndex.clamp(0, items.length - 1);
    final activeColor = indicatorColor ?? AppColors.primary;
    final inactiveColor = AppColors.neutral400;
    final contentHeight = AppDimensions.bottomNavContentHeight.h;
    final bottomInset = max(
      AppDimensions.bottomNavBottomPadding.h,
      context.safeAreaBottom,
    );

    final rowChildren = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      if (centerAction != null && i == items.length ~/ 2) {
        rowChildren.add(
          SizedBox(
            width: AppDimensions.centerFabSize.w,
            height: contentHeight,
            child: Center(
              child: Transform.translate(
                offset: Offset(0, -AppSpacing.md.h),
                child: _CenterActionButton(
                  item: centerAction!,
                  onTap: _handleCenter,
                ),
              ),
            ),
          ),
        );
      }
      rowChildren.add(
        Expanded(
          child: SizedBox(
            height: contentHeight,
            child: _NavTab(
              item: items[i],
              selected: i == index,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              onTap: () => _handle(i),
            ),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: contentHeight + bottomInset,
      clipBehavior: Clip.none,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.border)),
        boxShadow: AppShadows.bottomNav,
      ),
      child: Column(
        children: [
          Expanded(child: Row(children: rowChildren)),
          SizedBox(height: bottomInset),
        ],
      ),
    );
  }
}

/// Single tab: icon above a label, lifted 2 px when selected.
class _NavTab extends StatelessWidget {
  const _NavTab({
    required this.item,
    required this.selected,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  final ResponsiveNavigationItem item;
  final bool selected;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? activeColor : inactiveColor;

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.translate(
            offset: Offset(0, selected ? -2.r : 0),
            child: Icon(
              (selected ? (item.selectedIcon ?? item.icon) : item.icon),
              size: AppDimensions.navIconSize.r,
              color: color,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
                (selected
                        ? AppTextStyles.navLabelActive
                        : AppTextStyles.navLabel)
                    .copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

/// Elevated central action button of the design (gradient teal, white ring).
class _CenterActionButton extends StatelessWidget {
  const _CenterActionButton({required this.item, required this.onTap});

  final ResponsiveNavigationItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final size = AppDimensions.centerFabSize.r;

    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
              border: Border.all(color: AppColors.white, width: 3.r),
              boxShadow: AppShadows.fab,
            ),
            child: Icon(
              item.selectedIcon ?? item.icon,
              size: AppDimensions.iconLg.r,
              color: AppColors.white,
            ),
          ),
          if (item.label.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              item.label,
              maxLines: 1,
              style: AppTextStyles.navLabelActive.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

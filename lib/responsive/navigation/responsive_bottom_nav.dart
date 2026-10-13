import 'dart:math';

import 'package:flutter/material.dart';
import 'package:billing_and_sales_management/responsive/core/responsive_context.dart';
import 'package:billing_and_sales_management/responsive/core/responsive_extensions.dart';
import 'package:billing_and_sales_management/responsive/navigation/responsive_navigation.dart';
import 'package:billing_and_sales_management/responsive/theme/app_colors.dart';
import 'package:billing_and_sales_management/responsive/theme/app_dimensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_palette.dart';
import 'package:billing_and_sales_management/responsive/theme/app_shadows.dart';
import 'package:billing_and_sales_management/responsive/theme/app_spacing.dart';
import 'package:billing_and_sales_management/responsive/theme/app_text_styles.dart';

/// Floating bottom navigation bar (mobile / default tablet) driven by generic
/// [ResponsiveNavigationItem]s.
///
/// Matches the reference design: a white rounded pill with a soft shadow, a
/// smooth curved notch that wraps the raised [centerAction] button, and
/// icon-over-label destinations (active tab in brand primary).
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

  static const double _pillHeight = 80;
  static const double _notchHalfWidthFactor = 2.47;
  static const double _centerSlotRatio = 0.24;

  final List<ResponsiveNavigationItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  /// Optional central action button floating over the pill's notched edge.
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
    final palette = context.palette;
    final activeColor = indicatorColor ?? palette.accentText;
    final inactiveColor = palette.iconMuted;
    final surface = backgroundColor ?? palette.surface;

    final pillHeight = _pillHeight.h;
    final bottomInset = max(
      AppDimensions.bottomNavBottomPadding.h,
      context.safeAreaBottom,
    );
    final fabRadius = AppDimensions.centerFabSize.r / 2;
    final pillMargin = AppSpacing.base.w;
    final innerPadding = AppSpacing.xs.w;
    final cornerRadius = AppDimensions.radius2xl.r;
    final iconSize = AppDimensions.navIconSize.r;
    final iconLabelGap = AppSpacing.s2xs.h;
    final labelHeight =
        AppTextStyles.size2xs *
        1.2 *
        MediaQuery.textScalerOf(context).scale(1.0);
    final tabLabelTop =
        (pillHeight - (iconSize + iconLabelGap + labelHeight)) / 2 +
        iconSize +
        iconLabelGap;
    final fabLabelGap = max(tabLabelTop - fabRadius, AppSpacing.xs.h);

    return LayoutBuilder(
      builder: (context, constraints) {
        final barWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : context.screenWidth;
        final rowWidth = max(barWidth - 2 * pillMargin - 2 * innerPadding, 0.0);

        var notchHalfWidth = 0.0;
        if (centerAction != null) {
          notchHalfWidth = min(
            _notchHalfWidthFactor * fabRadius,
            rowWidth / 2 - cornerRadius - AppSpacing.sm.r,
          );
          if (notchHalfWidth < fabRadius) notchHalfWidth = 0;
        }

        final centerSlotWidth = centerAction == null
            ? 0.0
            : min(
                max(
                  rowWidth * _centerSlotRatio,
                  2 * fabRadius + AppSpacing.lg.r,
                ),
                rowWidth,
              );
        final sideWidth = max((rowWidth - centerSlotWidth) / 2, 0.0);
        final leftCount = items.length ~/ 2;
        final rightCount = items.length - leftCount;

        final rowChildren = <Widget>[];
        for (var i = 0; i < items.length; i++) {
          if (centerAction != null && i == leftCount) {
            if (leftCount == 0) rowChildren.add(SizedBox(width: sideWidth));
            rowChildren.add(SizedBox(width: centerSlotWidth));
          }
          final tab = SizedBox(
            height: pillHeight,
            child: _NavTab(
              item: items[i],
              selected: i == index,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              onTap: () => _handle(i),
            ),
          );
          if (centerAction == null) {
            rowChildren.add(Expanded(child: tab));
          } else {
            rowChildren.add(
              SizedBox(
                width: sideWidth / (i < leftCount ? leftCount : rightCount),
                child: tab,
              ),
            );
          }
        }

        return SizedBox(
          width: double.infinity,
          height: fabRadius + pillHeight + bottomInset,
          child: Stack(
            children: [
              PositionedDirectional(
                start: pillMargin,
                end: pillMargin,
                top: fabRadius,
                height: pillHeight,
                child: CustomPaint(
                  painter: _FloatingNavPillPainter(
                    surface: surface,
                    shadowColor: palette.navShadowColor,
                    shadowOffset: AppSpacing.s3xs.r,
                    shadowBlur: AppDimensions.radiusMd.r,
                    cornerRadius: cornerRadius,
                    notchHalfWidth: notchHalfWidth,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: innerPadding),
                    child: Row(children: rowChildren),
                  ),
                ),
              ),
              if (centerAction != null)
                PositionedDirectional(
                  start: 0,
                  end: 0,
                  top: 0,
                  child: Center(
                    child: _CenterActionButton(
                      item: centerAction!,
                      labelGap: fabLabelGap,
                      onTap: _handleCenter,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Single tab: icon above a label, lifted when selected.
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
    return InkWell(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: selected ? 1 : 0, end: selected ? 1 : 0),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        builder: (context, value, _) {
          final color = Color.lerp(inactiveColor, activeColor, value)!;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: selected ? 1.06 : 1,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                child: Icon(
                  selected ? (item.selectedIcon ?? item.icon) : item.icon,
                  size: AppDimensions.navIconSize.r,
                  color: color,
                ),
              ),
              SizedBox(height: AppSpacing.s2xs.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    item.label,
                    maxLines: 1,
                    style:
                        (selected
                                ? AppTextStyles.navLabelActive
                                : AppTextStyles.navLabel)
                            .copyWith(color: color),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Elevated central action button floating over the pill's notch (solid brand
/// circle, white ring, label aligned with the tab labels underneath).
class _CenterActionButton extends StatelessWidget {
  const _CenterActionButton({
    required this.item,
    required this.labelGap,
    required this.onTap,
  });

  final ResponsiveNavigationItem item;
  final double labelGap;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final size = AppDimensions.centerFabSize.r;
    final palette = context.palette;
    final ringColor = palette.surface;

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
              border: Border.all(color: ringColor, width: 3.r),
              boxShadow: AppShadows.fab,
            ),
            child: Icon(
              item.selectedIcon ?? item.icon,
              size: AppDimensions.iconLg.r,
              color: AppColors.white,
            ),
          ),
          if (item.label.isNotEmpty) ...[
            SizedBox(height: labelGap),
            Text(
              item.label,
              maxLines: 1,
              style: AppTextStyles.navLabelActive.copyWith(
                color: palette.accentText,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FloatingNavPillPainter extends CustomPainter {
  const _FloatingNavPillPainter({
    required this.surface,
    required this.shadowColor,
    required this.shadowOffset,
    required this.shadowBlur,
    required this.cornerRadius,
    required this.notchHalfWidth,
  });

  static const double _depthRatio = 0.5226;
  static const double _c1Ratio = 0.5956;
  static const double _c2Ratio = 0.4174;

  final Color surface;
  final Color shadowColor;
  final double shadowOffset;
  final double shadowBlur;
  final double cornerRadius;
  final double notchHalfWidth;

  bool get _hasNotch => notchHalfWidth > 0;

  @override
  void paint(Canvas canvas, Size size) {
    final path = _pillPath(size);
    final shadowPaint = Paint()
      ..color = shadowColor
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlur);

    canvas.save();
    if (_hasNotch) {
      final margin = shadowBlur * 2 + shadowOffset * 2;
      canvas.clipPath(
        Path.combine(
          PathOperation.difference,
          Path()..addRect(
            Rect.fromLTRB(
              -margin,
              -margin,
              size.width + margin,
              size.height + margin,
            ),
          ),
          _cavityPath(size),
        ),
      );
    }
    canvas.translate(0, shadowOffset);
    canvas.drawPath(path, shadowPaint);
    canvas.restore();

    canvas.drawPath(path, Paint()..color = surface);
  }

  Path _pillPath(Size size) {
    final rect = Offset.zero & size;
    final radius = min(cornerRadius, rect.height / 2);
    final cx = rect.center.dx;
    final w = _hasNotch ? min(notchHalfWidth, rect.width / 2 - radius) : 0.0;
    final depth = w * _depthRatio;

    final path = Path()..moveTo(rect.left + radius, rect.top);

    if (w > 0) {
      path
        ..lineTo(cx - w, rect.top)
        ..cubicTo(
          cx - _c1Ratio * w,
          rect.top,
          cx - _c2Ratio * w,
          rect.top + depth,
          cx,
          rect.top + depth,
        )
        ..cubicTo(
          cx + _c2Ratio * w,
          rect.top + depth,
          cx + _c1Ratio * w,
          rect.top,
          cx + w,
          rect.top,
        );
    }

    path
      ..lineTo(rect.right - radius, rect.top)
      ..quadraticBezierTo(rect.right, rect.top, rect.right, rect.top + radius)
      ..lineTo(rect.right, rect.bottom - radius)
      ..quadraticBezierTo(
        rect.right,
        rect.bottom,
        rect.right - radius,
        rect.bottom,
      )
      ..lineTo(rect.left + radius, rect.bottom)
      ..quadraticBezierTo(
        rect.left,
        rect.bottom,
        rect.left,
        rect.bottom - radius,
      )
      ..lineTo(rect.left, rect.top + radius)
      ..quadraticBezierTo(rect.left, rect.top, rect.left + radius, rect.top)
      ..close();

    return path;
  }

  Path _cavityPath(Size size) {
    final radius = min(cornerRadius, size.height / 2);
    final cx = size.width / 2;
    final w = min(notchHalfWidth, size.width / 2 - radius);
    final depth = w * _depthRatio;
    final top = -size.height;

    return Path()
      ..moveTo(cx - w, top)
      ..lineTo(cx - w, 0)
      ..cubicTo(cx - _c1Ratio * w, 0, cx - _c2Ratio * w, depth, cx, depth)
      ..cubicTo(cx + _c2Ratio * w, depth, cx + _c1Ratio * w, 0, cx + w, 0)
      ..lineTo(cx + w, top)
      ..close();
  }

  @override
  bool shouldRepaint(_FloatingNavPillPainter oldDelegate) {
    return surface != oldDelegate.surface ||
        shadowColor != oldDelegate.shadowColor ||
        shadowOffset != oldDelegate.shadowOffset ||
        shadowBlur != oldDelegate.shadowBlur ||
        cornerRadius != oldDelegate.cornerRadius ||
        notchHalfWidth != oldDelegate.notchHalfWidth;
  }
}

import 'package:flutter/material.dart';
import 'package:billing_and_sales_management/responsive/core/responsive_extensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_dimensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_palette.dart';
import 'package:billing_and_sales_management/responsive/theme/app_shadows.dart';
import 'package:billing_and_sales_management/responsive/theme/app_spacing.dart';

/// Card container matching the design's cards (`.entity-card`,
/// `.action-card`, `.recent-invoice-card`): white surface, 1 px neutral
/// border, 14 px radius and the subtle `--shadow-xs` elevation.
class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.radius,
    this.color,
    this.border,
    this.onTap,
    this.onLongPress,
    this.elevation = 0,
    this.shadow,
    this.width,
  });

  final Widget child;

  /// Inner padding; defaults to the design's `14px 16px`.
  final EdgeInsetsGeometry? padding;

  /// Outer margin.
  final EdgeInsetsGeometry? margin;

  /// Corner radius; defaults to `AppDimensions.cardRadius`.
  final double? radius;

  /// Fill color; defaults to the theme's card color.
  final Color? color;

  /// Border; defaults to the design's 1 px neutral border. Pass
  /// `BorderSide.none` to remove it.
  final BoxBorder? border;

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  /// Shadow elevation (0 = the design's resting `--shadow-xs`).
  final double elevation;

  /// Explicit shadow override.
  final List<BoxShadow>? shadow;

  /// Optional width (defaults to the parent constraint).
  final double? width;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final effectiveRadius = radius ?? AppDimensions.cardRadius;
    final radiusValue = effectiveRadius.r;
    final card = Container(
      width: width,
      margin: margin,
      padding:
          padding ??
          EdgeInsets.symmetric(
            horizontal: AppSpacing.base.w,
            vertical: AppSpacing.cardPaddingVertical.h,
          ),
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(radiusValue),
        border: border ?? Border.all(color: palette.border),
        boxShadow: shadow ?? AppShadows.card(elevation: elevation),
      ),
      child: child,
    );

    if (onTap == null && onLongPress == null) return card;

    return Material(
      color: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(radiusValue),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(radiusValue),
        overlayColor: WidgetStatePropertyAll(
          palette.overlayHover.withValues(alpha: 0.6),
        ),
        child: card,
      ),
    );
  }
}

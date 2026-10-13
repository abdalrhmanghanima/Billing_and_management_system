import 'package:flutter/material.dart';
import 'package:billing_and_sales_management/responsive/core/responsive_extensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_dimensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_palette.dart';
import 'package:billing_and_sales_management/responsive/theme/app_shadows.dart';

/// Round icon button matching the design's `.icon-btn` / `.header-action-btn`:
/// a 38-42 px white circle with a 1 px neutral border and the resting
/// `--shadow-xs`.
class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.size = AppDimensions.headerActionSize,
    this.iconSize = AppDimensions.iconMd,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.bordered = true,
    this.shadow = true,
    this.padding,
    this.borderRadius,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  /// Outer diameter in design px (38 header, 40 icon, 42 filter).
  final double size;

  final double iconSize;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;

  /// Draws the design's 1 px neutral border.
  final bool bordered;

  /// Applies the design's `--shadow-xs`.
  final bool shadow;

  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final radius = borderRadius ?? size;
    final bg = backgroundColor ?? palette.surface;
    final fg = foregroundColor ?? palette.textStrong;

    final button = Material(
      color: bg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.r),
        side: bordered
            ? BorderSide(color: borderColor ?? palette.border)
            : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(radius.r),
        overlayColor: WidgetStatePropertyAll(palette.overlayHover),
        child: SizedBox(
          width: size.r,
          height: size.r,
          child: Icon(icon, size: iconSize.r, color: fg),
        ),
      ),
    );

    final result = Padding(
      padding: padding ?? EdgeInsets.zero,
      child: shadow
          ? DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius.r),
                boxShadow: AppShadows.xs,
              ),
              child: button,
            )
          : button,
    );

    if (tooltip == null) return result;
    return Tooltip(message: tooltip!, child: result);
  }
}

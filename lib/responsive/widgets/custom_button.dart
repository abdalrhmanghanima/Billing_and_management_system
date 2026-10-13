import 'package:flutter/material.dart';
import 'package:billing_and_sales_management/responsive/core/responsive_extensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_colors.dart';
import 'package:billing_and_sales_management/responsive/theme/app_dimensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_palette.dart';
import 'package:billing_and_sales_management/responsive/theme/app_shadows.dart';
import 'package:billing_and_sales_management/responsive/theme/app_spacing.dart';
import 'package:billing_and_sales_management/responsive/theme/app_text_styles.dart';
import 'package:billing_and_sales_management/responsive/widgets/custom_loading.dart';
import 'package:billing_and_sales_management/responsive/widgets/custom_text.dart';

/// Visual variant of [CustomButton], mirroring the design's button classes.
enum CustomButtonVariant {
  /// `.btn-primary` - solid teal, brand shadow.
  primary,

  /// `.btn-secondary` - neutral surface with a light border.
  secondary,

  /// `.btn-coral` - warm coral accent.
  coral,

  /// `.btn-outline` - transparent with a teal border.
  outline,

  /// Borderless text action.
  text,
}

/// Size variant: `.btn` (48 px) and `.btn-sm` (38 px).
enum CustomButtonSize { medium, small }

/// Reusable button built from the design's `.btn` rules.
///
/// * full width by default (`width: double.infinity`),
/// * 48 design px high, 14 px radius, 14/600 label,
/// * loading and disabled states,
/// * pressed state scales down to 0.98 like the design's `:active`.
class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.loading = false,
    this.enabled = true,
    this.variant = CustomButtonVariant.primary,
    this.size = CustomButtonSize.medium,
    this.icon,
    this.width,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.textStyle,
    this.padding,
    this.border,
  });

  /// Button label (localized by the caller).
  final String text;

  /// Called when tapped; `null` disables the button.
  final VoidCallback? onPressed;

  /// Shows a spinner and blocks taps.
  final bool loading;

  /// Master switch for the enabled/disabled state.
  final bool enabled;

  final CustomButtonVariant variant;
  final CustomButtonSize size;

  /// Optional leading icon.
  final IconData? icon;

  /// Width; defaults to `double.infinity`.
  final double? width;

  /// Height; defaults to the variant height (48 / 38 design px).
  final double? height;

  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? borderRadius;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final BorderSide? border;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _pressed = false;

  bool get _interactive =>
      widget.enabled && widget.onPressed != null && !widget.loading;

  _ButtonColors _colors(BuildContext context) {
    final palette = context.palette;
    final disabled = !_interactive;

    switch (widget.variant) {
      case CustomButtonVariant.primary:
        return _ButtonColors(
          background: disabled
              ? palette.disabled
              : (widget.backgroundColor ?? AppColors.primary),
          foreground: disabled ? palette.textMuted : AppColors.white,
          border: widget.border,
          shadow: disabled ? AppShadows.xs : AppShadows.primaryButton,
        );
      case CustomButtonVariant.secondary:
        return _ButtonColors(
          background: disabled
              ? palette.disabled
              : (widget.backgroundColor ?? palette.subtleSurface),
          foreground: disabled
              ? palette.textMuted
              : (widget.foregroundColor ?? palette.textStrong),
          border: widget.border ?? BorderSide(color: palette.border),
          shadow: AppShadows.xs,
        );
      case CustomButtonVariant.coral:
        return _ButtonColors(
          background: disabled
              ? palette.disabled
              : (widget.backgroundColor ?? AppColors.coral),
          foreground: disabled ? palette.textMuted : AppColors.white,
          border: widget.border,
          shadow: disabled ? AppShadows.xs : AppShadows.coralButton,
        );
      case CustomButtonVariant.outline:
        return _ButtonColors(
          background: Colors.transparent,
          foreground: disabled
              ? palette.textMuted
              : (widget.foregroundColor ?? palette.accentText),
          border:
              widget.border ??
              BorderSide(color: palette.accentText, width: 1.5),
          shadow: const [],
        );
      case CustomButtonVariant.text:
        return _ButtonColors(
          background: Colors.transparent,
          foreground: disabled
              ? palette.textMuted
              : (widget.foregroundColor ?? palette.accentText),
          border: null,
          shadow: const [],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmall = widget.size == CustomButtonSize.small;
    final colors = _colors(context);
    final radius =
        (widget.borderRadius ??
                (isSmall ? AppDimensions.radiusMd : AppDimensions.buttonRadius))
            .r;
    final height =
        widget.height ??
        (isSmall ? AppDimensions.buttonSmHeight : AppDimensions.buttonHeight);
    final textStyle =
        widget.textStyle ??
        (isSmall ? AppTextStyles.buttonSmall : AppTextStyles.button);

    final Widget content = widget.loading
        ? CustomLoading.small(color: colors.foreground)
        : FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    size: AppDimensions.iconSm.r,
                    color: colors.foreground,
                  ),
                  SizedBox(width: AppSpacing.sm.w),
                ],
                CustomText(
                  text: widget.text,
                  style: textStyle,
                  color: colors.foreground,
                ),
              ],
            ),
          );

    return GestureDetector(
      onTap: _interactive ? widget.onPressed : null,
      onTapDown: _interactive ? (_) => setState(() => _pressed = true) : null,
      onTapUp: _interactive ? (_) => setState(() => _pressed = false) : null,
      onTapCancel: _interactive ? () => setState(() => _pressed = false) : null,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 100),
        child: Material(
          color: colors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: colors.border ?? BorderSide.none,
          ),
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          shadowColor: Colors.transparent,
          child: Container(
            width: widget.width ?? double.infinity,
            height: height.h,
            padding:
                widget.padding ??
                EdgeInsets.symmetric(
                  horizontal: (isSmall ? AppSpacing.md : AppSpacing.lg).w,
                ),
            decoration: colors.shadow.isEmpty
                ? null
                : BoxDecoration(boxShadow: colors.shadow),
            alignment: Alignment.center,
            child: content,
          ),
        ),
      ),
    );
  }
}

class _ButtonColors {
  const _ButtonColors({
    required this.background,
    required this.foreground,
    required this.border,
    required this.shadow,
  });

  final Color background;
  final Color foreground;
  final BorderSide? border;
  final List<BoxShadow> shadow;
}

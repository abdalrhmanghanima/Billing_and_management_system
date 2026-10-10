import 'package:flutter/material.dart';
import 'package:billing_and_sales_management/responsive/core/responsive_extensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_colors.dart';
import 'package:billing_and_sales_management/responsive/theme/app_spacing.dart';
import 'package:billing_and_sales_management/responsive/theme/app_text_styles.dart';
import 'package:billing_and_sales_management/responsive/widgets/custom_text.dart';

/// Semantic color variant of [CustomChip] (design's `.badge-*` classes).
enum CustomChipVariant {
  neutral,
  primary,
  cyan,
  coral,
  success,
  warning,
  error,
  info,
}

/// Pill chip / status badge (`.badge`, `.entity-avatar` tags, filters).
///
/// With [badge] the chip reproduces the design's status pill exactly:
/// 4 x 10 padding, full radius, 10/700 uppercase label with 0.3 letterspacing
/// and the semantic background / border / text colors.
class CustomChip extends StatelessWidget {
  const CustomChip({
    super.key,
    required this.label,
    this.variant = CustomChipVariant.neutral,
    this.badge = false,
    this.selected = false,
    this.onTap,
    this.avatar,
    this.backgroundColor,
    this.labelColor,
    this.borderColor,
    this.textStyle,
  });

  /// Chip label (localized by the caller).
  final String label;

  final CustomChipVariant variant;

  /// Renders the compact uppercase status pill.
  final bool badge;

  final bool selected;
  final VoidCallback? onTap;
  final Widget? avatar;

  final Color? backgroundColor;
  final Color? labelColor;
  final Color? borderColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final palette = _palette();

    final bg = selected
        ? AppColors.primary
        : (backgroundColor ?? palette.background);
    final fg = selected ? AppColors.white : (labelColor ?? palette.text);
    final border = selected
        ? BorderSide.none
        : (borderColor != null
              ? BorderSide(color: borderColor!)
              : palette.border);

    final style =
        (textStyle ??
                (badge
                    ? AppTextStyles.badge
                    : AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w500,
                      )))
            .copyWith(color: fg);

    final label = badge ? this.label.toUpperCase() : this.label;

    return Material(
      color: bg,
      shape: StadiumBorder(side: border),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: badge
              ? EdgeInsets.symmetric(
                  horizontal: AppSpacing.md.w,
                  vertical: AppSpacing.s2xs.h,
                )
              : EdgeInsets.symmetric(
                  horizontal: AppSpacing.md.r,
                  vertical: AppSpacing.sm.h,
                ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (avatar != null) ...[
                avatar!,
                SizedBox(width: AppSpacing.sm.w),
              ],
              CustomText(text: label, style: style, color: fg),
            ],
          ),
        ),
      ),
    );
  }

  ({Color background, Color text, BorderSide border}) _palette() {
    switch (variant) {
      case CustomChipVariant.neutral:
        return (
          background: AppColors.neutral100,
          text: AppColors.neutral600,
          border: const BorderSide(color: AppColors.neutral200),
        );
      case CustomChipVariant.primary:
        return (
          background: AppColors.primarySubtle,
          text: AppColors.primary,
          border: const BorderSide(color: AppColors.primarySubtle),
        );
      case CustomChipVariant.cyan:
        return (
          background: AppColors.cyanLight,
          text: AppColors.cyanDark,
          border: const BorderSide(color: AppColors.cyanLight),
        );
      case CustomChipVariant.coral:
        return (
          background: AppColors.coralSubtle,
          text: AppColors.coral,
          border: const BorderSide(color: AppColors.coralBorder),
        );
      case CustomChipVariant.success:
        return (
          background: AppColors.successBg,
          text: AppColors.successText,
          border: const BorderSide(color: AppColors.successBorder),
        );
      case CustomChipVariant.warning:
        return (
          background: AppColors.warningBg,
          text: AppColors.warningText,
          border: const BorderSide(color: AppColors.warningBorder),
        );
      case CustomChipVariant.error:
        return (
          background: AppColors.errorBg,
          text: AppColors.errorText,
          border: const BorderSide(color: AppColors.errorBorder),
        );
      case CustomChipVariant.info:
        return (
          background: AppColors.infoBg,
          text: AppColors.info,
          border: const BorderSide(color: AppColors.infoBorder),
        );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:billing_and_sales_management/responsive/core/responsive_extensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_palette.dart';
import 'package:billing_and_sales_management/responsive/theme/app_spacing.dart';
import 'package:billing_and_sales_management/responsive/theme/app_text_styles.dart';
import 'package:billing_and_sales_management/responsive/widgets/custom_text.dart';

/// Design's `.section-header`: a 15/700 title with an optional trailing
/// action link (13/600, brand primary).
class CustomSectionHeader extends StatelessWidget {
  const CustomSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.trailing,
    this.padding,
  });

  final String title;

  /// Trailing link label (e.g. "See all").
  final String? actionLabel;
  final VoidCallback? onAction;

  /// Custom trailing widget; replaces [actionLabel].
  final Widget? trailing;

  /// Outer padding; defaults to the design's 12 px bottom gap only.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.only(bottom: AppSpacing.md.h),
      child: Row(
        children: [
          Expanded(
            child: CustomText(
              text: title,
              style: AppTextStyles.sectionTitle,
              color: context.palette.textPrimary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (trailing != null)
            trailing!
          else if (actionLabel != null)
            GestureDetector(
              onTap: onAction,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsetsDirectional.only(start: AppSpacing.sm.w),
                child: CustomText(
                  text: actionLabel!,
                  style: AppTextStyles.label,
                  color: context.palette.accentText,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:billing_and_sales_management/responsive/core/responsive_extensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_dimensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_palette.dart';
import 'package:billing_and_sales_management/responsive/theme/app_spacing.dart';
import 'package:billing_and_sales_management/responsive/theme/app_text_styles.dart';
import 'package:billing_and_sales_management/responsive/widgets/custom_text.dart';

/// Centered "nothing here" placeholder matching the design's
/// `.empty-state-card`: a 72 px brand-tinted icon circle, a 15/700 title and
/// a 13 px muted description, with an optional action.
class CustomEmptyState extends StatelessWidget {
  const CustomEmptyState({
    super.key,
    this.icon = Icons.inbox_outlined,
    required this.title,
    this.message,
    this.action,
    this.iconColor,
    this.iconBackgroundColor,
  });

  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;
  final Color? iconColor;
  final Color? iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg.w,
          vertical: AppSpacing.s3xl.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppDimensions.emptyStateIconBox.r,
              height: AppDimensions.emptyStateIconBox.r,
              decoration: BoxDecoration(
                color: iconBackgroundColor ?? palette.primarySubtle,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: AppDimensions.stateIconSize.r,
                color: iconColor ?? palette.accentText,
              ),
            ),
            SizedBox(height: AppSpacing.base.h),
            CustomText(
              text: title,
              style: AppTextStyles.sectionTitle,
              color: palette.textPrimary,
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              SizedBox(height: AppSpacing.xs.h),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 260.w),
                child: CustomText(
                  text: message!,
                  style: AppTextStyles.bodySmall.copyWith(
                    height: AppTextStyles.heightRelaxed,
                  ),
                  color: palette.textMuted,
                  textAlign: TextAlign.center,
                  maxLines: 4,
                ),
              ),
            ],
            if (action != null) ...[SizedBox(height: AppSpacing.lg.h), action!],
          ],
        ),
      ),
    );
  }
}

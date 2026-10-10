import 'package:flutter/material.dart';
import 'package:billing_and_sales_management/responsive/core/responsive_extensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_colors.dart';
import 'package:billing_and_sales_management/responsive/theme/app_dimensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_spacing.dart';
import 'package:billing_and_sales_management/responsive/theme/app_text_styles.dart';
import 'package:billing_and_sales_management/responsive/widgets/custom_button.dart';
import 'package:billing_and_sales_management/responsive/widgets/custom_text.dart';

/// Centered error placeholder styled like the design's empty state but with
/// the semantic error palette.
///
/// Strings are parameters - pass localized text from the caller.
class CustomErrorState extends StatelessWidget {
  const CustomErrorState({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.error_outline,
    this.onRetry,
    this.retryLabel = 'Retry',
    this.action,
  });

  final String title;
  final String? message;
  final IconData icon;
  final VoidCallback? onRetry;
  final String retryLabel;

  /// Custom action widget; replaces the built-in retry button.
  final Widget? action;

  @override
  Widget build(BuildContext context) {
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
              decoration: const BoxDecoration(
                color: AppColors.errorBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: AppDimensions.stateIconSize.r,
                color: AppColors.error,
              ),
            ),
            SizedBox(height: AppSpacing.base.h),
            CustomText(
              text: title,
              style: AppTextStyles.sectionTitle,
              color: AppColors.neutral900,
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
                  color: AppColors.neutral500,
                  textAlign: TextAlign.center,
                  maxLines: 4,
                ),
              ),
            ],
            if (action != null || onRetry != null) ...[
              SizedBox(height: AppSpacing.lg.h),
              action ??
                  CustomButton(
                    text: retryLabel,
                    onPressed: onRetry,
                    width: 220.w,
                  ),
            ],
          ],
        ),
      ),
    );
  }
}

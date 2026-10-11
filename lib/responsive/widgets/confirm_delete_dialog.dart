import 'package:flutter/material.dart';
import 'package:billing_and_sales_management/responsive/core/responsive_extensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_colors.dart';
import 'package:billing_and_sales_management/responsive/theme/app_dimensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_spacing.dart';
import 'package:billing_and_sales_management/responsive/theme/app_text_styles.dart';
import 'package:billing_and_sales_management/responsive/widgets/custom_button.dart';
import 'package:billing_and_sales_management/responsive/widgets/custom_dialog.dart';
import 'package:billing_and_sales_management/responsive/widgets/custom_text.dart';

/// Opens the destructive-action confirmation dialog (`.modal` from the design)
/// and resolves to `true` only when the user taps the confirm button.
///
/// Cancel, barrier tap and system back all resolve to `false`, so callers can
/// treat any non-`true` result as "do nothing".
Future<bool> showConfirmDeleteDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmText = 'Delete',
  String cancelText = 'Cancel',
}) async {
  final confirmed = await showResponsiveDialog<bool>(
    context: context,
    builder: (dialogContext) => _ConfirmDeleteContent(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: () => Navigator.of(dialogContext).pop(true),
      onCancel: () => Navigator.of(dialogContext).pop(false),
    ),
  );

  return confirmed ?? false;
}

class _ConfirmDeleteContent extends StatelessWidget {
  const _ConfirmDeleteContent({
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    required this.onCancel,
  });

  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: AppDimensions.emptyStateIconBox.r,
            height: AppDimensions.emptyStateIconBox.r,
            decoration: const BoxDecoration(
              color: AppColors.errorBg,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.delete_outline,
              size: AppDimensions.iconXl.r,
              color: AppColors.error,
            ),
          ),
        ),
        SizedBox(height: AppSpacing.base.h),
        CustomText(
          text: title,
          style: AppTextStyles.sectionTitle,
          color: AppColors.neutral900,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSpacing.sm.h),
        CustomText(
          text: message,
          style: AppTextStyles.bodySmall,
          color: AppColors.neutral500,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSpacing.lg.h),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                text: cancelText,
                variant: CustomButtonVariant.secondary,
                onPressed: onCancel,
              ),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: CustomButton(
                text: confirmText,
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.white,
                onPressed: onConfirm,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

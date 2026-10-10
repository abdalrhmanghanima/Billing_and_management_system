import 'package:flutter/material.dart';
import 'package:billing_and_sales_management/responsive/core/responsive_extensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_colors.dart';
import 'package:billing_and_sales_management/responsive/theme/app_dimensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_spacing.dart';
import 'package:billing_and_sales_management/responsive/widgets/custom_text.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({
    super.key,
    this.size = AppDimensions.loadingSize,
    this.strokeWidth = 3,
    this.color,
    this.message,
  });

  const CustomLoading.small({
    super.key,
    this.size = AppDimensions.buttonLoadingSize,
    this.strokeWidth = 2,
    this.color,
    this.message,
  });

  final double size;
  final double strokeWidth;
  final Color? color;
  final String? message;

  static Widget centered({
    Key? key,
    double size = AppDimensions.loadingSize,
    double strokeWidth = 3,
    Color? color,
    String? message,
  }) {
    return Center(
      child: CustomLoading(
        key: key,
        size: size,
        strokeWidth: strokeWidth,
        color: color,
        message: message,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final indicator = SizedBox.square(
      dimension: size.r,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        color: color ?? AppColors.white,
      ),
    );

    if (message == null) return indicator;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        indicator,
        SizedBox(height: AppSpacing.md.r),
        CustomText(
          text: message!,
          color: AppColors.textSecondary,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

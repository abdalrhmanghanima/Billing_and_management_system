import 'package:flutter/material.dart';
import 'package:billing_and_sales_management/responsive/theme/app_colors.dart';

/// Thin horizontal divider using the theme's border color.
class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
    this.height,
    this.thickness = 1,
    this.color,
    this.indent,
    this.endIndent,
  });

  final double? height;
  final double thickness;
  final Color? color;
  final double? indent;
  final double? endIndent;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      thickness: thickness,
      color: color ?? AppColors.border,
      indent: indent,
      endIndent: endIndent,
    );
  }
}

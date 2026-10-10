import 'package:billing_and_sales_management/responsive/responsive.dart';
import 'package:flutter/material.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: CustomText(
          text: 'More',
          style: AppTextStyles.pageTitle,
          color: AppColors.textPrimary,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

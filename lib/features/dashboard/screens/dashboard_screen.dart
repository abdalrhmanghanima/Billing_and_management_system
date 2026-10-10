import 'package:billing_and_sales_management/responsive/responsive.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: CustomText(
          text: 'Home',
          style: AppTextStyles.pageTitle,
          color: AppColors.textPrimary,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

import 'package:billing_and_sales_management/responsive/responsive.dart';
import 'package:flutter/material.dart';

class ItemsScreen extends StatelessWidget {
  const ItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: CustomText(
          text: 'Items',
          style: AppTextStyles.pageTitle,
          color: AppColors.textPrimary,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

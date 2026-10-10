import 'package:billing_and_sales_management/responsive/responsive.dart';
import 'package:flutter/material.dart';

class ClientsScreen extends StatelessWidget {
  const ClientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: CustomText(
          text: 'Clients',
          style: AppTextStyles.pageTitle,
          color: AppColors.textPrimary,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

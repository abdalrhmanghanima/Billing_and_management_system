import 'package:billing_and_sales_management/features/categories/screens/categories_screen.dart';
import 'package:billing_and_sales_management/features/companies/screens/companies_screen.dart';
import 'package:billing_and_sales_management/features/types/screens/types_screen.dart';
import 'package:billing_and_sales_management/features/units/screens/units_screen.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';
import 'package:flutter/material.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  void _openCompanies(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (context) => const CompaniesScreen()),
    );
  }

  void _openTypes(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (context) => const TypesScreen()));
  }

  void _openUnits(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (context) => const UnitsScreen()));
  }

  void _openCategories(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (context) => const CategoriesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaxWidthBox(
        maxWidth: AppDimensions.maxContentWidth,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.pageHorizontal.w,
            AppSpacing.base.h,
            AppSpacing.pageHorizontal.w,
            AppSpacing.xl.h,
          ),
          children: [
            CustomText(
              text: 'Master Catalog & Admin',
              style: AppTextStyles.sectionTitle,
              color: AppColors.neutral900,
            ),
            SizedBox(height: AppSpacing.s3xs.h),
            CustomText(
              text: 'Manage system entities and official requests',
              style: AppTextStyles.bodySmall,
              color: AppColors.neutral500,
            ),
            SizedBox(height: AppSpacing.lg.h),
            CustomEntityTile(
              avatarIcon: Icons.business_outlined,
              avatarTone: EntityAvatarTone.cyan,
              title: 'Companies',
              subtitle: 'Supplier & Brand Catalog',
              onTap: () => _openCompanies(context),
            ),
            SizedBox(height: AppSpacing.cardGap.h),
            CustomEntityTile(
              avatarIcon: Icons.description_outlined,
              avatarTone: EntityAvatarTone.primary,
              title: 'Types',
              subtitle: 'Item Classifications',
              onTap: () => _openTypes(context),
            ),
            SizedBox(height: AppSpacing.cardGap.h),
            CustomEntityTile(
              avatarIcon: Icons.table_chart_outlined,
              avatarTone: EntityAvatarTone.cyan,
              title: 'Units',
              subtitle: 'Measurement & Packaging',
              onTap: () => _openUnits(context),
            ),
            SizedBox(height: AppSpacing.cardGap.h),
            CustomEntityTile(
              avatarIcon: Icons.category_outlined,
              avatarTone: EntityAvatarTone.coral,
              title: 'Categories',
              subtitle: 'Product Grouping',
              onTap: () => _openCategories(context),
            ),
          ],
        ),
      ),
    );
  }
}

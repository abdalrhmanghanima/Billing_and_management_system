import 'package:billing_and_sales_management/features/auth/providers/logout_provider.dart';
import 'package:billing_and_sales_management/features/auth/screens/login_screen.dart';
import 'package:billing_and_sales_management/features/categories/providers/categories_notifier.dart';
import 'package:billing_and_sales_management/features/categories/screens/categories_screen.dart';
import 'package:billing_and_sales_management/features/companies/providers/companies_notifier.dart';
import 'package:billing_and_sales_management/features/companies/screens/companies_screen.dart';
import 'package:billing_and_sales_management/features/request_forms/screens/request_form_screen.dart';
import 'package:billing_and_sales_management/features/types/providers/types_notifier.dart';
import 'package:billing_and_sales_management/features/types/screens/types_screen.dart';
import 'package:billing_and_sales_management/features/units/providers/units_notifier.dart';
import 'package:billing_and_sales_management/features/units/screens/units_screen.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MoreScreen extends ConsumerWidget {
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

  void _openRequestForm(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (context) => const RequestFormScreen()),
    );
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    await ref.read(logoutProvider.notifier).logout();

    final logoutState = ref.read(logoutProvider);

    if (!context.mounted) return;

    if (logoutState.hasError) {
      CustomSnackbar.showError(
        context,
        'Could not sign out. Please try again.',
      );
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companiesCount = ref
        .watch(companiesProvider)
        .maybeWhen(data: (list) => list.length, orElse: () => null);
    final typesCount = ref
        .watch(typesProvider)
        .maybeWhen(data: (list) => list.length, orElse: () => null);
    final unitsCount = ref
        .watch(unitsProvider)
        .maybeWhen(data: (list) => list.length, orElse: () => null);
    final categoriesCount = ref
        .watch(categoriesProvider)
        .maybeWhen(data: (list) => list.length, orElse: () => null);

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
            SizedBox(height: AppSpacing.md.h),
            _HubGrid(
              companiesCount: companiesCount,
              typesCount: typesCount,
              unitsCount: unitsCount,
              categoriesCount: categoriesCount,
              onCompanies: () => _openCompanies(context),
              onTypes: () => _openTypes(context),
              onUnits: () => _openUnits(context),
              onCategories: () => _openCategories(context),
              onRequestForm: () => _openRequestForm(context),
            ),
            SizedBox(height: AppSpacing.xl.h),
            const CustomDivider(),
            SizedBox(height: AppSpacing.base.h),
            CustomButton(
              text: 'Sign Out',
              variant: CustomButtonVariant.secondary,
              foregroundColor: AppColors.error,
              border: const BorderSide(color: AppColors.errorBorder),
              onPressed: () => _signOut(context, ref),
            ),
          ],
        ),
      ),
    );
  }
}

class _HubGrid extends StatelessWidget {
  const _HubGrid({
    required this.companiesCount,
    required this.typesCount,
    required this.unitsCount,
    required this.categoriesCount,
    required this.onCompanies,
    required this.onTypes,
    required this.onUnits,
    required this.onCategories,
    required this.onRequestForm,
  });

  final int? companiesCount;
  final int? typesCount;
  final int? unitsCount;
  final int? categoriesCount;
  final VoidCallback onCompanies;
  final VoidCallback onTypes;
  final VoidCallback onUnits;
  final VoidCallback onCategories;
  final VoidCallback onRequestForm;

  String _countLabel(int? count, String noun) {
    if (count == null) return '';
    return '$count $noun';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _HubTile(
                icon: Icons.business_outlined,
                iconColor: AppColors.cyanDark,
                iconBackground: AppColors.cyanLight,
                title: 'Companies',
                subtitle: _countLabel(companiesCount, 'records'),
                onTap: onCompanies,
              ),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: _HubTile(
                icon: Icons.description_outlined,
                iconColor: AppColors.primary,
                iconBackground: AppColors.primarySubtle,
                title: 'Types',
                subtitle: _countLabel(typesCount, 'records'),
                onTap: onTypes,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md.h),
        Row(
          children: [
            Expanded(
              child: _HubTile(
                icon: Icons.table_chart_outlined,
                iconColor: AppColors.cyanDark,
                iconBackground: AppColors.cyanLight,
                title: 'Units',
                subtitle: _countLabel(unitsCount, 'units'),
                onTap: onUnits,
              ),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: _HubTile(
                icon: Icons.category_outlined,
                iconColor: AppColors.coral,
                iconBackground: AppColors.coralSubtle,
                title: 'Categories',
                subtitle: _countLabel(categoriesCount, 'categories'),
                onTap: onCategories,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md.h),
        _HubTile(
          icon: Icons.assignment_outlined,
          iconColor: AppColors.purple,
          iconBackground: AppColors.purpleSubtle,
          title: 'Request a Form (SRS Section 4)',
          subtitle: 'Employee working hours and shift requests',
          onTap: onRequestForm,
        ),
      ],
    );
  }
}

class _HubTile extends StatelessWidget {
  const _HubTile({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 18.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50.r,
            height: 50.r,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg.r),
            ),
            child: Icon(icon, size: AppDimensions.iconXl.r, color: iconColor),
          ),
          SizedBox(height: AppSpacing.md.h),
          CustomText(
            text: title,
            style: AppTextStyles.label,
            fontWeight: FontWeight.w700,
            color: AppColors.neutral900,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (subtitle.isNotEmpty) ...[
            SizedBox(height: AppSpacing.s2xs.h),
            CustomText(
              text: subtitle,
              style: AppTextStyles.microLabel,
              color: AppColors.neutral500,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

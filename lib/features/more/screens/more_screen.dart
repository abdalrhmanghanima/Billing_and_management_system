import 'package:billing_and_sales_management/core/translate/app_translate.dart';
import 'package:billing_and_sales_management/features/auth/providers/logout_provider.dart';
import 'package:billing_and_sales_management/features/auth/screens/login_screen.dart';
import 'package:billing_and_sales_management/features/categories/providers/categories_notifier.dart';
import 'package:billing_and_sales_management/features/categories/screens/categories_screen.dart';
import 'package:billing_and_sales_management/features/companies/providers/companies_notifier.dart';
import 'package:billing_and_sales_management/features/companies/screens/companies_screen.dart';
import 'package:billing_and_sales_management/features/request_forms/screens/request_form_screen.dart';
import 'package:billing_and_sales_management/features/theme/providers/theme_mode_provider.dart';
import 'package:billing_and_sales_management/features/types/providers/types_notifier.dart';
import 'package:billing_and_sales_management/features/types/screens/types_screen.dart';
import 'package:billing_and_sales_management/features/units/providers/units_notifier.dart';
import 'package:billing_and_sales_management/features/units/screens/units_screen.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MoreScreen extends ConsumerStatefulWidget {
  const MoreScreen({super.key});

  @override
  ConsumerState<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends ConsumerState<MoreScreen> {
  bool _appearanceExpanded = false;
  bool _languageExpanded = false;
  bool _signingOut = false;
  bool _isRefreshing = false;

  Future<void> _refresh() async {
    if (_isRefreshing) return;
    _isRefreshing = true;
    try {
      await Future.wait([
        ref.read(companiesProvider.notifier).refresh(),
        ref.read(typesProvider.notifier).refresh(),
        ref.read(unitsProvider.notifier).refresh(),
        ref.read(categoriesProvider.notifier).refresh(),
      ]);
    } finally {
      _isRefreshing = false;
    }
  }

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

  Future<void> _confirmSignOut() async {
    if (_signingOut) return;

    final confirmed = await showConfirmDeleteDialog(
      context: context,
      title: AppTranslate.signOut.tr(),
      message: AppTranslate.signOutConfirmationMessage.tr(),
      confirmText: AppTranslate.signOut.tr(),
    );

    if (!confirmed || !mounted) return;

    await _signOut();
  }

  Future<void> _signOut() async {
    if (_signingOut) return;
    setState(() => _signingOut = true);

    await ref.read(logoutProvider.notifier).logout();

    final logoutState = ref.read(logoutProvider);

    if (!mounted) return;
    setState(() => _signingOut = false);

    if (logoutState.hasError) {
      CustomSnackbar.showError(context, AppTranslate.couldNotSignOut.tr());
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
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
    final currentThemeMode = ref.watch(themeModeProvider);

    return SafeArea(
      child: MaxWidthBox(
        maxWidth: AppDimensions.maxContentWidth,
        child: RefreshIndicator(
          color: context.palette.accentText,
          onRefresh: _refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              AppSpacing.pageHorizontal.w,
              AppSpacing.base.h,
              AppSpacing.pageHorizontal.w,
              AppSpacing.xl.h,
            ),
            children: [
              CustomText(
                text: AppTranslate.masterCatalogAndAdmin.tr(),
                style: AppTextStyles.sectionTitle,
                color: palette.textPrimary,
              ),
              SizedBox(height: AppSpacing.s3xs.h),
              CustomText(
                text: AppTranslate.manageSystemEntitiesMessage.tr(),
                style: AppTextStyles.bodySmall,
                color: palette.textMuted,
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
              InkWell(
                onTap: () =>
                    setState(() => _appearanceExpanded = !_appearanceExpanded),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: AppTranslate.appearance.tr(),
                            style: AppTextStyles.sectionTitle,
                            color: palette.textPrimary,
                          ),
                          SizedBox(height: AppSpacing.s3xs.h),
                          CustomText(
                            text: AppTranslate.chooseAppAppearanceMessage.tr(),
                            style: AppTextStyles.bodySmall,
                            color: palette.textMuted,
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: _appearanceExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOutCubic,
                      child: Icon(
                        Icons.expand_more,
                        size: AppDimensions.iconLg.r,
                        color: palette.iconMuted,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOutCubic,
                alignment: Alignment.topCenter,
                child: _appearanceExpanded
                    ? Padding(
                        padding: EdgeInsets.only(top: AppSpacing.md.h),
                        child: _ThemeSelector(
                          currentMode: currentThemeMode,
                          onChanged: (mode) => ref
                              .read(themeModeProvider.notifier)
                              .setMode(mode),
                        ),
                      )
                    : const SizedBox(width: double.infinity),
              ),
              SizedBox(height: AppSpacing.xl.h),
              const CustomDivider(),
              SizedBox(height: AppSpacing.base.h),
              InkWell(
                onTap: () =>
                    setState(() => _languageExpanded = !_languageExpanded),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: AppTranslate.language.tr(),
                            style: AppTextStyles.sectionTitle,
                            color: palette.textPrimary,
                          ),
                          SizedBox(height: AppSpacing.s3xs.h),
                          CustomText(
                            text: AppTranslate.chooseLanguage.tr(),
                            style: AppTextStyles.bodySmall,
                            color: palette.textMuted,
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: _languageExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOutCubic,
                      child: Icon(
                        Icons.expand_more,
                        size: AppDimensions.iconLg.r,
                        color: palette.iconMuted,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOutCubic,
                alignment: Alignment.topCenter,
                child: _languageExpanded
                    ? Padding(
                        padding: EdgeInsets.only(top: AppSpacing.md.h),
                        child: _LanguageSelector(
                          currentLocale: context.locale,
                          onChanged: (locale) => context.setLocale(locale),
                        ),
                      )
                    : const SizedBox(width: double.infinity),
              ),
              SizedBox(height: AppSpacing.xl.h),
              const CustomDivider(),
              SizedBox(height: AppSpacing.base.h),
              CustomButton(
                text: AppTranslate.signOut.tr(),
                variant: CustomButtonVariant.secondary,
                foregroundColor: AppColors.error,
                border: BorderSide(color: palette.errorBorder),
                loading: _signingOut,
                onPressed: _signingOut ? null : _confirmSignOut,
              ),
            ],
          ),
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

  String _countLabel(int? count, String key) {
    if (count == null) return '';
    return key.tr(namedArgs: {'count': '$count'});
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _HubTile(
                icon: Icons.business_outlined,
                iconColor: palette.cyanText,
                iconBackground: palette.cyanLight,
                title: AppTranslate.companies.tr(),
                subtitle: _countLabel(
                  companiesCount,
                  AppTranslate.countRecords,
                ),
                onTap: onCompanies,
              ),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: _HubTile(
                icon: Icons.description_outlined,
                iconColor: palette.accentText,
                iconBackground: palette.primarySubtle,
                title: AppTranslate.types.tr(),
                subtitle: _countLabel(typesCount, AppTranslate.countRecords),
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
                iconColor: palette.cyanText,
                iconBackground: palette.cyanLight,
                title: AppTranslate.units.tr(),
                subtitle: _countLabel(unitsCount, AppTranslate.countUnits),
                onTap: onUnits,
              ),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: _HubTile(
                icon: Icons.category_outlined,
                iconColor: AppColors.coral,
                iconBackground: palette.coralSubtle,
                title: AppTranslate.categories.tr(),
                subtitle: _countLabel(
                  categoriesCount,
                  AppTranslate.countCategories,
                ),
                onTap: onCategories,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md.h),
        _HubTile(
          icon: Icons.assignment_outlined,
          iconColor: palette.purpleText,
          iconBackground: palette.purpleSubtle,
          title: AppTranslate.requestAFormSrsSection4.tr(),
          subtitle: AppTranslate.requestFormSubtitle.tr(),
          onTap: onRequestForm,
        ),
      ],
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector({required this.currentMode, required this.onChanged});

  final ThemeMode currentMode;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _ThemeOptionTile(
            icon: Icons.brightness_auto_outlined,
            title: AppTranslate.systemDefault.tr(),
            subtitle: AppTranslate.followDeviceSetting.tr(),
            selected: currentMode == ThemeMode.system,
            onTap: () => onChanged(ThemeMode.system),
          ),
          CustomDivider(
            indent: AppSpacing.pageHorizontal.w,
            endIndent: AppSpacing.pageHorizontal.w,
          ),
          _ThemeOptionTile(
            icon: Icons.light_mode_outlined,
            title: AppTranslate.light.tr(),
            subtitle: AppTranslate.alwaysUseLightTheme.tr(),
            selected: currentMode == ThemeMode.light,
            onTap: () => onChanged(ThemeMode.light),
          ),
          CustomDivider(
            indent: AppSpacing.pageHorizontal.w,
            endIndent: AppSpacing.pageHorizontal.w,
          ),
          _ThemeOptionTile(
            icon: Icons.dark_mode_outlined,
            title: AppTranslate.dark.tr(),
            subtitle: AppTranslate.alwaysUseDarkTheme.tr(),
            selected: currentMode == ThemeMode.dark,
            onTap: () => onChanged(ThemeMode.dark),
          ),
        ],
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector({
    required this.currentLocale,
    required this.onChanged,
  });

  final Locale currentLocale;
  final ValueChanged<Locale> onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _ThemeOptionTile(
            icon: Icons.language_outlined,
            title: AppTranslate.english.tr(),
            selected: currentLocale.languageCode == 'en',
            onTap: () => onChanged(const Locale('en')),
          ),
          CustomDivider(
            indent: AppSpacing.pageHorizontal.w,
            endIndent: AppSpacing.pageHorizontal.w,
          ),
          _ThemeOptionTile(
            icon: Icons.translate_outlined,
            title: AppTranslate.arabic.tr(),
            selected: currentLocale.languageCode == 'ar',
            onTap: () => onChanged(const Locale('ar')),
          ),
        ],
      ),
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  const _ThemeOptionTile({
    required this.icon,
    required this.title,
    this.subtitle = '',
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.pageHorizontal.w,
          vertical: AppSpacing.md.h,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: AppDimensions.iconLg.r,
              color: selected ? palette.accentText : palette.iconMuted,
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    style: AppTextStyles.label,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? palette.accentText : palette.textPrimary,
                  ),
                  if (subtitle.isNotEmpty)
                    CustomText(
                      text: subtitle,
                      style: AppTextStyles.microLabel,
                      color: palette.textMuted,
                    ),
                ],
              ),
            ),
            if (selected)
              Icon(
                Icons.check_circle,
                size: AppDimensions.iconMd.r,
                color: palette.accentText,
              ),
          ],
        ),
      ),
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
    final palette = context.palette;

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
            color: palette.textPrimary,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (subtitle.isNotEmpty) ...[
            SizedBox(height: AppSpacing.s2xs.h),
            CustomText(
              text: subtitle,
              style: AppTextStyles.microLabel,
              color: palette.textMuted,
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

import 'package:billing_and_sales_management/core/errors/company_exception.dart';
import 'package:billing_and_sales_management/domain/companies/entities/company.dart';
import 'package:billing_and_sales_management/features/companies/providers/companies_notifier.dart';
import 'package:billing_and_sales_management/features/companies/widgets/company_form_sheet.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompaniesScreen extends ConsumerStatefulWidget {
  const CompaniesScreen({super.key});

  @override
  ConsumerState<CompaniesScreen> createState() => _CompaniesScreenState();
}

class _CompaniesScreenState extends ConsumerState<CompaniesScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAddCompanySheet() {
    showAppBottomSheet<void>(
      context: context,
      title: 'Add Company',
      builder: (_) => const CompanyFormSheet(),
    );
  }

  List<Company> _filter(List<Company> companies) {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return companies;

    return companies
        .where(
          (company) =>
              company.name.toLowerCase().contains(query) ||
              company.notes.toLowerCase().contains(query),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final companiesState = ref.watch(companiesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Companies',
        subtitle: 'Supplier & Brand Catalog',
      ),
      floatingActionButton: _AddCompanyButton(onPressed: _openAddCompanySheet),
      body: MaxWidthBox(
        maxWidth: AppDimensions.maxContentWidth,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.pageHorizontal.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppSpacing.base.h),
              CustomSearchBar(
                controller: _searchController,
                hint: 'Search companies...',
                onChanged: (value) => setState(() => _query = value),
              ),
              SizedBox(height: AppSpacing.base.h),
              Expanded(
                child: companiesState.when(
                  loading: () => const CustomSkeletonList(count: 4),
                  error: (error, _) => CustomErrorState(
                    title: 'Could not load companies',
                    message: error is CompanyException
                        ? error.message
                        : 'Something went wrong. Please try again.',
                    onRetry: () =>
                        ref.read(companiesProvider.notifier).refresh(),
                  ),
                  data: (companies) => _CompaniesList(
                    companies: _filter(companies),
                    isSearching: _query.trim().isNotEmpty,
                    onAddCompany: _openAddCompanySheet,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.pageBottom.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompaniesList extends StatelessWidget {
  const _CompaniesList({
    required this.companies,
    required this.isSearching,
    required this.onAddCompany,
  });

  final List<Company> companies;
  final bool isSearching;
  final VoidCallback onAddCompany;

  @override
  Widget build(BuildContext context) {
    if (companies.isEmpty) {
      if (isSearching) {
        return const CustomEmptyState(
          icon: Icons.search_off_outlined,
          title: 'No Companies Found',
          message: 'No companies match your search.',
        );
      }

      return CustomEmptyState(
        icon: Icons.business_outlined,
        iconColor: AppColors.cyanDark,
        iconBackgroundColor: AppColors.cyanLight,
        title: 'No Companies Added',
        message: 'Add your supplier or brand companies here.',
        action: CustomButton(
          text: '+ Add Company',
          size: CustomButtonSize.small,
          width: 200.w,
          onPressed: onAddCompany,
        ),
      );
    }

    return ListView.separated(
      itemCount: companies.length,
      separatorBuilder: (context, index) =>
          SizedBox(height: AppSpacing.cardGap.h),
      itemBuilder: (context, index) {
        final company = companies[index];

        return CustomEntityTile(
          avatarIcon: Icons.business_outlined,
          avatarTone: EntityAvatarTone.cyan,
          title: company.name,
          subtitle: company.notes.isEmpty
              ? 'No description notes'
              : company.notes,
        );
      },
    );
  }
}

class _AddCompanyButton extends StatelessWidget {
  const _AddCompanyButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final size = AppDimensions.fabSize.r;

    return DecoratedBox(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: AppShadows.fab,
      ),
      child: Material(
        color: AppColors.primary,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(
              Icons.add,
              size: AppDimensions.iconLg.r,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}

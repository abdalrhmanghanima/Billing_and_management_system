import 'package:billing_and_sales_management/core/errors/category_exception.dart';
import 'package:billing_and_sales_management/domain/categories/entities/category.dart';
import 'package:billing_and_sales_management/features/categories/providers/categories_notifier.dart';
import 'package:billing_and_sales_management/features/categories/widgets/category_form_sheet.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAddCategorySheet() {
    showAppBottomSheet<void>(
      context: context,
      title: 'Add Category',
      builder: (_) => const CategoryFormSheet(),
    );
  }

  List<Category> _filter(List<Category> categories) {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return categories;

    return categories
        .where((category) => category.name.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesState = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Categories',
        subtitle: 'Product Grouping',
      ),
      floatingActionButton: _AddCategoryButton(
        onPressed: _openAddCategorySheet,
      ),
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
                hint: 'Search categories...',
                onChanged: (value) => setState(() => _query = value),
              ),
              SizedBox(height: AppSpacing.base.h),
              Expanded(
                child: categoriesState.when(
                  loading: () => const CustomSkeletonList(count: 4),
                  error: (error, _) => CustomErrorState(
                    title: 'Could not load categories',
                    message: error is CategoryException
                        ? error.message
                        : 'Something went wrong. Please try again.',
                    onRetry: () =>
                        ref.read(categoriesProvider.notifier).refresh(),
                  ),
                  data: (categories) => _CategoriesList(
                    categories: _filter(categories),
                    isSearching: _query.trim().isNotEmpty,
                    onAddCategory: _openAddCategorySheet,
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

class _CategoriesList extends StatelessWidget {
  const _CategoriesList({
    required this.categories,
    required this.isSearching,
    required this.onAddCategory,
  });

  final List<Category> categories;
  final bool isSearching;
  final VoidCallback onAddCategory;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      if (isSearching) {
        return const CustomEmptyState(
          icon: Icons.search_off_outlined,
          title: 'No Categories Found',
          message: 'No categories match your search.',
        );
      }

      return CustomEmptyState(
        icon: Icons.category_outlined,
        iconColor: AppColors.coral,
        iconBackgroundColor: AppColors.coralSubtle,
        title: 'No Categories Added',
        message: 'Group your product inventory into clean categories.',
        action: CustomButton(
          text: '+ Add Category',
          size: CustomButtonSize.small,
          width: 200.w,
          onPressed: onAddCategory,
        ),
      );
    }

    return ListView.separated(
      itemCount: categories.length,
      separatorBuilder: (context, index) =>
          SizedBox(height: AppSpacing.cardGap.h),
      itemBuilder: (context, index) {
        final category = categories[index];

        return CustomEntityTile(
          avatarIcon: Icons.category_outlined,
          avatarTone: EntityAvatarTone.coral,
          title: category.name,
          subtitle: category.notes.isEmpty
              ? 'Product category'
              : category.notes,
        );
      },
    );
  }
}

class _AddCategoryButton extends StatelessWidget {
  const _AddCategoryButton({required this.onPressed});

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

import 'package:flutter/material.dart';
import 'package:billing_and_sales_management/responsive/core/responsive_extensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_colors.dart';
import 'package:billing_and_sales_management/responsive/theme/app_dimensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_palette.dart';
import 'package:billing_and_sales_management/responsive/theme/app_spacing.dart';
import 'package:billing_and_sales_management/responsive/theme/app_text_styles.dart';

/// Pill search input reproducing the design's `.search-box input`:
/// 42 design px tall, 18 px radius, 1.5 px neutral border, search icon at
/// 12 px from the start edge, 13 px text.
class CustomSearchField extends StatelessWidget {
  const CustomSearchField({
    super.key,
    this.controller,
    this.hint,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.focusNode,
    this.readOnly = false,
    this.autofocus = false,
    this.textInputAction = TextInputAction.search,
  });

  final TextEditingController? controller;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final bool readOnly;
  final bool autofocus;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTap: onTap,
      readOnly: readOnly,
      autofocus: autofocus,
      textInputAction: textInputAction,
      style: AppTextStyles.bodySmall.copyWith(
        fontSize: AppTextStyles.sizeSm.sp,
        color: palette.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg.w,
          vertical: AppSpacing.md.w - 2.w,
        ),
        prefixIcon: Padding(
          padding: EdgeInsetsDirectional.only(start: AppSpacing.md.w),
          child: Icon(
            Icons.search,
            size: AppDimensions.iconMd.r,
            color: palette.iconMuted,
          ),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 38.w, maxWidth: 38.w),
        border: _border(palette.border),
        enabledBorder: _border(palette.border),
        focusedBorder: _border(palette.accentText),
        errorBorder: _border(AppColors.error),
        focusedErrorBorder: _border(AppColors.error),
        filled: true,
        fillColor: palette.inputFill,
        hintStyle: AppTextStyles.bodySmall.copyWith(
          fontSize: AppTextStyles.sizeSm.sp,
          color: palette.textMuted,
        ),
      ),
    );
  }

  InputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.searchRadius.r),
      borderSide: BorderSide(color: color, width: 1.5),
    );
  }
}

/// Design's `.search-filter-row`: a flexible search field plus an optional
/// 42 px filter button.
class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    this.controller,
    this.hint,
    this.onChanged,
    this.onFilterPressed,
    this.filterActive = false,
    this.focusNode,
    this.readOnly = false,
  });

  final TextEditingController? controller;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterPressed;
  final bool filterActive;
  final FocusNode? focusNode;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomSearchField(
            controller: controller,
            hint: hint,
            onChanged: onChanged,
            focusNode: focusNode,
            readOnly: readOnly,
          ),
        ),
        if (onFilterPressed != null) ...[
          SizedBox(width: AppSpacing.md.w),
          _FilterButton(active: filterActive, onPressed: onFilterPressed),
        ],
      ],
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.active, required this.onPressed});

  final bool active;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Material(
      color: active ? palette.primarySubtle : palette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg.r),
        side: BorderSide(
          color: active ? palette.accentText : palette.border,
          width: 1.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg.r),
        child: SizedBox(
          width: AppDimensions.filterButtonSize.r,
          height: AppDimensions.filterButtonSize.r,
          child: Icon(
            Icons.tune,
            size: AppDimensions.iconMd.r,
            color: active ? palette.accentText : palette.textSecondary,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:billing_and_sales_management/responsive/core/responsive_extensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_dimensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_palette.dart';
import 'package:billing_and_sales_management/responsive/theme/app_spacing.dart';
import 'package:billing_and_sales_management/responsive/theme/app_text_styles.dart';
import 'package:billing_and_sales_management/responsive/widgets/custom_text.dart';
import 'package:billing_and_sales_management/responsive/widgets/custom_text_field.dart';

/// Select control reproducing the design's `.select-field`: same field
/// styling as [CustomTextField] with a chevron 14 px from the end edge, plus
/// the design's static label above it.
class CustomDropdown<T> extends StatelessWidget {
  const CustomDropdown({
    super.key,
    required this.options,
    required this.labelOf,
    this.value,
    this.onChanged,
    this.label,
    this.isRequired = false,
    this.hint,
    this.validator,
    this.enabled = true,
    this.autofocus = false,
  });

  /// Values offered by the dropdown.
  final List<T> options;

  /// Builds the visible label of an option (and of the selected value).
  final String Function(T value) labelOf;

  final T? value;
  final ValueChanged<T?>? onChanged;

  final String? label;
  final bool isRequired;
  final String? hint;
  final String? Function(T?)? validator;
  final bool enabled;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          CustomFieldLabel(
            label: label!,
            isRequired: isRequired,
            enabled: enabled,
          ),
          SizedBox(height: AppSpacing.xs.h),
        ],
        DropdownButtonFormField<T>(
          initialValue: value,
          onChanged: enabled ? onChanged : null,
          validator: validator,
          autofocus: autofocus,
          menuMaxHeight: 320.h,
          dropdownColor: palette.surface,
          iconEnabledColor: palette.textMuted,
          style: AppTextStyles.body.copyWith(color: palette.textPrimary),
          items: [
            for (final option in options)
              DropdownMenuItem<T>(
                value: option,
                child: CustomText(
                  text: labelOf(option),
                  style: AppTextStyles.body,
                  color: palette.textPrimary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: null,
            suffixIcon: Padding(
              padding: EdgeInsetsDirectional.only(
                end: AppDimensions.inputHorizontalPadding.w,
              ),
              child: Icon(
                Icons.expand_more,
                size: AppDimensions.iconMd.r,
                color: palette.textMuted,
              ),
            ),
            suffixIconConstraints: BoxConstraints(
              minWidth: AppDimensions.inputSuffixWidth.w,
              maxWidth: AppDimensions.inputSuffixWidth.w,
            ),
          ),
        ),
      ],
    );
  }
}

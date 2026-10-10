import 'package:flutter/material.dart';
import 'package:billing_and_sales_management/responsive/core/responsive_extensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_colors.dart';
import 'package:billing_and_sales_management/responsive/theme/app_dimensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_spacing.dart';
import 'package:billing_and_sales_management/responsive/theme/app_text_styles.dart';
import 'package:billing_and_sales_management/responsive/widgets/custom_text.dart';

/// Reusable text input built on [TextFormField].
///
/// Reproduces the design's form group (`.form-group`):
///
/// * static 13/600 label above the field with an optional red required star,
/// * 6 design px gap between label and field,
/// * 48 design px field, 1.5 px neutral border, 14 px radius,
/// * validation hint rendered below the field (11/500, error color),
/// * automatic visibility toggle for [obscureText].
class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.hint,
    this.label,
    this.isRequired = false,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.onTap,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.autofocus = false,
    this.autofillHints,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String? hint;
  final String? label;

  /// Renders the design's red `*` after the label.
  final bool isRequired;

  /// External validation message (use [validator] for in-field validation).
  final String? errorText;

  /// Leading widget (e.g. `const Icon(Icons.search)`).
  final Widget? prefixIcon;

  /// Trailing widget. When null and [obscureText] is true, a visibility
  /// toggle is provided automatically.
  final Widget? suffixIcon;

  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool enabled;
  final bool readOnly;
  final int maxLines;
  final int? minLines;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final bool autofocus;
  final Iterable<String>? autofillHints;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscured = widget.obscureText;

  @override
  Widget build(BuildContext context) {
    final isMultiline = widget.maxLines > 1;

    final Widget? suffix =
        widget.suffixIcon ??
        (widget.obscureText
            ? IconButton(
                onPressed: () => setState(() => _obscured = !_obscured),
                tooltip: _obscured ? 'Show' : 'Hide',
                icon: Icon(
                  _obscured
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: AppDimensions.iconMd.r,
                  color: AppColors.neutral400,
                ),
              )
            : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          CustomFieldLabel(
            label: widget.label!,
            isRequired: widget.isRequired,
            enabled: widget.enabled,
          ),
          SizedBox(height: AppSpacing.xs.h),
        ],
        TextFormField(
          controller: widget.controller,
          initialValue: widget.controller == null ? widget.initialValue : null,
          obscureText: _obscured,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          minLines: widget.minLines,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          autofocus: widget.autofocus,
          autofillHints: widget.autofillHints,
          decoration: InputDecoration(
            hintText: widget.hint,
            errorText: widget.errorText,
            prefixIcon: widget.prefixIcon == null
                ? null
                : Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: AppDimensions.inputHorizontalPadding.w,
                    ),
                    child: widget.prefixIcon,
                  ),
            prefixIconConstraints: BoxConstraints(
              minWidth: AppDimensions.inputPrefixWidth.w,
              maxWidth: AppDimensions.inputPrefixWidth.w,
            ),
            suffixIcon: suffix == null
                ? null
                : Padding(
                    padding: EdgeInsetsDirectional.only(
                      end: AppDimensions.inputHorizontalPadding.w,
                    ),
                    child: suffix,
                  ),
            suffixIconConstraints: suffix == null
                ? null
                : BoxConstraints(
                    minWidth: AppDimensions.inputSuffixWidth.w,
                    maxWidth: AppDimensions.inputSuffixWidth.w,
                  ),
            constraints: isMultiline
                ? BoxConstraints(minHeight: AppDimensions.textAreaMinHeight.h)
                : null,
          ),
        ),
      ],
    );
  }
}

/// Design's `.form-label`: a static 13/600 label with an optional red
/// required star. Shared by [CustomTextField] and other form controls.
class CustomFieldLabel extends StatelessWidget {
  const CustomFieldLabel({
    super.key,
    required this.label,
    this.isRequired = false,
    this.enabled = true,
  });

  final String label;
  final bool isRequired;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(
          text: label,
          style: AppTextStyles.label,
          color: enabled ? AppColors.neutral700 : AppColors.neutral400,
        ),
        if (isRequired)
          CustomText(
            text: ' *',
            style: AppTextStyles.label,
            color: AppColors.error,
          ),
      ],
    );
  }
}

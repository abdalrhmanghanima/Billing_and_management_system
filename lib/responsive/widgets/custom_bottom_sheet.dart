import 'package:flutter/material.dart';
import 'package:billing_and_sales_management/responsive/core/responsive_extensions.dart';
import 'package:billing_and_sales_management/responsive/layout/responsive_sheet_content.dart';
import 'package:billing_and_sales_management/responsive/theme/app_dimensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_palette.dart';
import 'package:billing_and_sales_management/responsive/theme/app_spacing.dart';
import 'package:billing_and_sales_management/responsive/theme/app_text_styles.dart';

/// Opens a bottom sheet wrapped in [ResponsiveSheetContent].
///
/// * Mobile -> full-width sheet with rounded top corners and drag handle.
/// * Tablet/desktop -> bottom-centered panel capped at
///   `AppBreakpoints.bottomSheetMaxWidth`.
///
/// The background stays transparent so the theme controls the surface color.
Future<T?> showResponsiveBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = true,
  bool useSafeArea = true,
  bool isDismissible = true,
  bool showDragHandle = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    useSafeArea: useSafeArea,
    isDismissible: isDismissible,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => ResponsiveSheetContent(
      showDragHandle: showDragHandle,
      child: builder(sheetContext),
    ),
  );
}

/// Opens the design's form bottom sheet (`.bottom-sheet-header` /
/// `.bottom-sheet-body`): a 15/700 title with a 38 px close button over a
/// divider, and a padded, scrollable body.
///
/// ```dart
/// showAppBottomSheet(
///   context: context,
///   title: context.tr('companies.add'),
///   builder: (context) => const CompanyForm(),
/// );
/// ```
Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required String title,
  required WidgetBuilder builder,
  bool isDismissible = true,
  bool showCloseButton = true,
  VoidCallback? onClose,
}) {
  return showResponsiveBottomSheet<T>(
    context: context,
    isDismissible: isDismissible,
    builder: (sheetContext) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _BottomSheetHeader(
          title: title,
          showCloseButton: showCloseButton,
          onClose: onClose,
        ),
        Flexible(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.only(
              start: AppSpacing.lg.w,
              end: AppSpacing.lg.w,
              top: AppSpacing.lg.h,
              bottom: AppSpacing.xl.h,
            ),
            child: builder(sheetContext),
          ),
        ),
      ],
    ),
  );
}

class _BottomSheetHeader extends StatelessWidget {
  const _BottomSheetHeader({
    required this.title,
    required this.showCloseButton,
    this.onClose,
  });

  final String title;
  final bool showCloseButton;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: EdgeInsetsDirectional.only(
        start: AppSpacing.lg.w,
        end: AppSpacing.md.w,
        top: AppSpacing.md.h,
        bottom: AppSpacing.md.h + 2.h,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: palette.subtleBorder)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.appBarTitle.copyWith(
                color: palette.textPrimary,
              ),
            ),
          ),
          if (showCloseButton)
            IconButton(
              onPressed: onClose ?? () => Navigator.of(context).maybePop(),
              tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(
                minWidth: AppDimensions.headerActionSize.w,
                minHeight: AppDimensions.headerActionSize.w,
              ),
              style: IconButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: palette.textStrong,
                shape: const CircleBorder(),
              ),
              icon: Icon(Icons.close, size: 20.r),
            ),
        ],
      ),
    );
  }
}

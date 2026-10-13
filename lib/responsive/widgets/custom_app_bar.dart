import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:billing_and_sales_management/responsive/core/responsive_extensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_dimensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_palette.dart';
import 'package:billing_and_sales_management/responsive/theme/app_text_styles.dart';
import 'package:billing_and_sales_management/responsive/widgets/custom_text.dart';

/// Generic app bar matching the design's `.mobile-app-header`:
///
/// * 56 design px tall, flat (no elevation), screen-colored surface,
/// * centered 15/700 title with an optional 10 px subtitle,
/// * 38 design px round back button (RTL aware),
/// * optional 1 px bottom border (`.bordered`).
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.subtitle,
    this.showBackArrow = true,
    this.centerTitle = true,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.titleColor,
    this.bordered = false,
    this.systemUiOverlayStyle,
    this.titleSpacing,
    this.elevation = 0,
  });

  final String? title;
  final String? subtitle;
  final bool showBackArrow;
  final bool centerTitle;
  final List<Widget>? actions;

  /// Custom leading widget; replaces the back arrow when provided.
  final Widget? leading;

  final Color? backgroundColor;
  final Color? titleColor;

  /// Renders the design's `bordered` header variant.
  final bool bordered;

  final SystemUiOverlayStyle? systemUiOverlayStyle;
  final double? titleSpacing;
  final double elevation;

  @override
  Size get preferredSize => Size.fromHeight(AppDimensions.appBarHeight.h);

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final scheme = Theme.of(context).colorScheme;
    final palette = context.palette;
    final showLeading = leading != null || showBackArrow;

    return AppBar(
      backgroundColor:
          backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: elevation,
      scrolledUnderElevation: 0,
      systemOverlayStyle: systemUiOverlayStyle,
      automaticallyImplyLeading: false,
      leadingWidth: (AppDimensions.headerActionSize + 16).w,
      leading:
          leading ??
          (showBackArrow
              ? IconButton(
                  onPressed: () => Navigator.maybePop(context),
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  padding: EdgeInsetsDirectional.only(start: 4.r),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: palette.textStrong,
                    minimumSize: Size(
                      AppDimensions.headerActionSize.w,
                      AppDimensions.headerActionSize.w,
                    ),
                    shape: const CircleBorder(),
                  ),
                  icon: Icon(
                    isRtl ? Icons.arrow_forward : Icons.arrow_back,
                    size: 22.r,
                  ),
                )
              : null),
      titleSpacing: titleSpacing,
      title: title == null
          ? null
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(
                  text: title!,
                  style: AppTextStyles.appBarTitle,
                  color: titleColor ?? scheme.onSurface,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 1.h),
                  CustomText(
                    text: subtitle!,
                    style: AppTextStyles.microLabel,
                    color: palette.textMuted,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
      centerTitle: centerTitle,
      actions:
          actions ??
          (showLeading
              ? [
                  SizedBox(
                    width: (AppDimensions.headerActionSize + 8).w,
                    height: AppDimensions.headerActionSize.w,
                  ),
                ]
              : null),
      bottom: bordered
          ? PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(height: 1, color: palette.border),
            )
          : null,
    );
  }
}

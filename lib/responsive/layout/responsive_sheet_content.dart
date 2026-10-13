import 'package:flutter/material.dart';
import 'package:billing_and_sales_management/responsive/core/breakpoints.dart';
import 'package:billing_and_sales_management/responsive/core/responsive_context.dart';
import 'package:billing_and_sales_management/responsive/core/responsive_extensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_dimensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_palette.dart';

/// Wraps bottom-sheet content so it reproduces the design's mobile sheet
/// (`.bottom-sheet-content`):
///
/// * white surface with 28 px top corners,
/// * drag handle + optional header/body structure provided by the caller,
/// * capped at 88 % of the screen height,
/// * on tablet/desktop the sheet becomes a bottom-centered panel instead of
///   stretching across the whole window.
class ResponsiveSheetContent extends StatelessWidget {
  const ResponsiveSheetContent({
    super.key,
    required this.child,
    this.color,
    this.showDragHandle = true,
    this.maxWidth = AppBreakpoints.bottomSheetMaxWidth,
  });

  final Widget child;

  /// Surface color; defaults to the theme's sheet color.
  final Color? color;

  /// Renders the design's 40 x 4 grab handle above the content.
  final bool showDragHandle;

  /// Maximum width of the sheet on large screens.
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final surface = DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.sheetRadius.r),
        ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.88,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showDragHandle)
              Padding(
                padding: EdgeInsets.only(top: 10.r, bottom: 4.h),
                child: Center(
                  child: Container(
                    width: 40.r,
                    height: 4.r,
                    decoration: BoxDecoration(
                      color: context.palette.handleColor,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusFull,
                      ),
                    ),
                  ),
                ),
              ),
            Flexible(child: child),
          ],
        ),
      ),
    );

    if (!context.isLargeScreen) {
      return surface;
    }

    return Align(
      alignment: AlignmentDirectional.bottomCenter,
      heightFactor: 1,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: surface,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:billing_and_sales_management/responsive/core/breakpoints.dart';
import 'package:billing_and_sales_management/responsive/core/responsive_extensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_dimensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_spacing.dart';

/// Responsive dialog: fills the usable width on mobile (with the standard
/// dialog inset) and is capped at [maxWidth] on tablet/desktop.
///
/// ```dart
/// showDialog(
///   context: context,
///   builder: (_) => const ResponsiveDialog(child: ConfirmContent()),
/// );
/// ```
class ResponsiveDialog extends StatelessWidget {
  const ResponsiveDialog({
    super.key,
    required this.child,
    this.maxWidth = AppBreakpoints.dialogMaxWidth,
    this.backgroundColor,
    this.radius,
    this.padding,
  });

  final Widget child;

  /// Cap for large screens.
  final double maxWidth;

  final Color? backgroundColor;

  /// Corner radius; defaults to `AppDimensions.dialogRadius.r`.
  final double? radius;

  /// Inner padding; defaults to `AppSpacing.lg.r` (design dialogs use 20).
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          radius ?? AppDimensions.dialogRadius.r,
        ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding ?? EdgeInsets.all(AppSpacing.lg.r),
          child: child,
        ),
      ),
    );
  }
}

/// Opens a [ResponsiveDialog] with `showDialog`.
Future<T?> showResponsiveDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  Color? backgroundColor,
  double? maxWidth,
  EdgeInsetsGeometry? padding,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (dialogContext) => ResponsiveDialog(
      maxWidth: maxWidth ?? AppBreakpoints.dialogMaxWidth,
      backgroundColor: backgroundColor,
      padding: padding,
      child: builder(dialogContext),
    ),
  );
}

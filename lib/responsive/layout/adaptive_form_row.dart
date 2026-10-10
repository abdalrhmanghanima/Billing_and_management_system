import 'package:flutter/material.dart';
import 'package:billing_and_sales_management/responsive/core/breakpoints.dart';
import 'package:billing_and_sales_management/responsive/core/responsive_context.dart';
import 'package:billing_and_sales_management/responsive/core/responsive_extensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_spacing.dart';

/// Lays out form fields in a single column on mobile and in two columns
/// when enough width is available (tablet/desktop or a wide landscape).
///
/// ```dart
/// AdaptiveFormRow(
///   children: [
///     TextFieldA(),
///     TextFieldB(),
///   ],
/// )
/// ```
class AdaptiveFormRow extends StatelessWidget {
  const AdaptiveFormRow({
    super.key,
    required this.children,
    this.spacing,
    this.minRowWidth = AppBreakpoints.formRowMinWidth,
  });

  final List<Widget> children;

  /// Gap between fields. When `null`, `16.h` is used vertically and
  /// `16.w` horizontally (the reference design's form spacing).
  final double? spacing;

  /// Minimum available width before the fields switch to multiple columns.
  final double minRowWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.maxWidth;
        final canUseRow =
            !context.isMobile &&
            children.length > 1 &&
            available.isFinite &&
            available >= minRowWidth;

        if (!canUseRow) {
          final gap = spacing ?? AppSpacing.base.h;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) SizedBox(height: gap),
                children[i],
              ],
            ],
          );
        }

        final gap = spacing ?? AppSpacing.base.w;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) SizedBox(width: gap),
              Expanded(child: children[i]),
            ],
          ],
        );
      },
    );
  }
}

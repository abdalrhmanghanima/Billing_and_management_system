import 'package:flutter/material.dart';

/// Constrains its child to [maxWidth] and centers it horizontally when the
/// available space is larger.
///
/// On small screens the constraint does not bind and the child is returned
/// untouched, so the layout is identical to having no wrapper at all.
///
/// ```dart
/// MaxWidthBox(
///   maxWidth: 840,
///   child: Column(...),
/// )
/// ```
class MaxWidthBox extends StatelessWidget {
  const MaxWidthBox({
    super.key,
    required this.maxWidth,
    required this.child,
    this.center = true,
    this.applyFromWidth = 0,
  });

  final double maxWidth;
  final Widget child;

  /// Centers the constrained child. Set to `false` in cross-start aligned
  /// parents where the content should stay left/right aligned.
  final bool center;

  /// When > 0 the constraint is only applied if the screen width is at least
  /// this value (e.g. `AppBreakpoints.desktopMinWidth` to affect desktop only).
  final double applyFromWidth;

  @override
  Widget build(BuildContext context) {
    if (applyFromWidth > 0 &&
        MediaQuery.sizeOf(context).width < applyFromWidth) {
      return child;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final incoming = constraints.maxWidth;

        // Constraint does not bind: keep the original layout untouched.
        if (incoming.isFinite && incoming <= maxWidth) {
          return child;
        }

        final constrained = ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        );

        return center ? Center(child: constrained) : constrained;
      },
    );
  }
}

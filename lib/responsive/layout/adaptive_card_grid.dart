import 'package:flutter/material.dart';
import 'package:billing_and_sales_management/responsive/core/breakpoints.dart';

/// A vertical list of equal cards that automatically lays out multiple
/// columns when the available width allows it.
///
/// With a single column it behaves exactly like a `ListView.separated`.
///
/// ```dart
/// AdaptiveCardGrid(
///   minCardWidth: 280,
///   spacing: 16,
///   children: [Card1(), Card2(), Card3()],
/// )
/// ```
class AdaptiveCardGrid extends StatelessWidget {
  const AdaptiveCardGrid({
    super.key,
    required this.children,
    this.minCardWidth = 340,
    this.spacing = 16,
    this.columnSpacing,
    this.maxColumns = 3,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
  });

  /// Pre-built card widgets.
  final List<Widget> children;

  /// Minimum comfortable width of a single card column.
  final double minCardWidth;

  /// Gap between cards (vertical gap and, unless [columnSpacing] is set,
  /// the horizontal gap between columns).
  final double spacing;

  /// Horizontal gap between columns; defaults to [spacing].
  final double? columnSpacing;

  /// Upper bound of columns regardless of width.
  final int maxColumns;

  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  /// Pure column computation - exposed for tests and custom layouts.
  static int columnsFor(
    double availableWidth, {
    double minCardWidth = 340,
    double spacing = 16,
    int maxColumns = 3,
  }) {
    return AppBreakpoints.columnsFor(
      availableWidth,
      minCardWidth: minCardWidth,
      spacing: spacing,
      maxColumns: maxColumns,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final hGap = columnSpacing ?? spacing;
        final columns = columnsFor(
          constraints.maxWidth,
          minCardWidth: minCardWidth,
          spacing: hGap,
          maxColumns: maxColumns,
        );

        if (columns <= 1) {
          return ListView.separated(
            padding: padding ?? EdgeInsets.zero,
            physics: physics,
            shrinkWrap: shrinkWrap,
            itemCount: children.length,
            separatorBuilder: (context, index) => SizedBox(height: spacing),
            itemBuilder: (context, index) => children[index],
          );
        }

        final rows = <Widget>[];
        for (var start = 0; start < children.length; start += columns) {
          final rowChildren = <Widget>[];
          for (var offset = 0; offset < columns; offset++) {
            final index = start + offset;
            if (index >= children.length) break;
            if (rowChildren.isNotEmpty) {
              rowChildren.add(SizedBox(width: hGap));
            }
            rowChildren.add(Expanded(child: children[index]));
          }

          rows.add(
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: rowChildren,
            ),
          );

          if (start + columns < children.length) {
            rows.add(SizedBox(height: spacing));
          }
        }

        return ListView(
          padding: padding ?? EdgeInsets.zero,
          physics: physics,
          shrinkWrap: shrinkWrap,
          children: rows,
        );
      },
    );
  }
}

/// Familiar alias for [AdaptiveCardGrid].
typedef AdaptiveCardList = AdaptiveCardGrid;

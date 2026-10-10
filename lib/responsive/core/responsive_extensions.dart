import 'package:billing_and_sales_management/responsive/core/responsive_service.dart';

/// Size helpers that scale design units to the current screen.
///
/// Design units are the raw pixel values of the reference design
/// (390 x 844 frame). All four helpers use the same uniform scale factor, so
/// a widget keeps exactly the proportions it has in the design.
///
/// ```dart
/// SizedBox(width: 16.w, height: 48.h);
/// BorderRadius.circular(14.r);
/// TextStyle(fontSize: 14.sp);
/// ```
extension SizeExtension on num {
  /// Scales a horizontal design unit.
  double get w => ResponsiveService.scaleWidth() * this;

  /// Scales a vertical design unit.
  double get h => ResponsiveService.scaleHeight() * this;

  /// Scales a radius/spacing design unit.
  double get r => ResponsiveService.scaleRadius() * this;

  /// Scales a font size design unit (narrower band, see [ResponsiveService.scaleText]).
  double get sp => ResponsiveService.scaleText() * this;
}

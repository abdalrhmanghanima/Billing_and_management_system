import 'package:flutter/material.dart';
import 'package:billing_and_sales_management/responsive/theme/app_text_styles.dart';

/// Lightweight, reusable [Text] wrapper.
///
/// Falls back to [AppTextStyles.body] and the theme's text color when no
/// overrides are given, so it works with light/dark themes out of the box.
class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.style,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.softWrap,
    this.height,
    this.decoration,
    this.letterSpacing,
  });

  final String text;

  /// Base style; defaults to [AppTextStyles.body].
  final TextStyle? style;

  /// Overrides the style color (null keeps the theme color).
  final Color? color;

  /// Overrides the font size (design units; use `.sp` to scale).
  final double? fontSize;

  final FontWeight? fontWeight;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final bool? softWrap;
  final double? height;
  final TextDecoration? decoration;
  final double? letterSpacing;

  @override
  Widget build(BuildContext context) {
    final resolved = (style ?? AppTextStyles.body).copyWith(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      decoration: decoration,
      letterSpacing: letterSpacing,
    );

    return Text(
      text,
      style: resolved,
      maxLines: maxLines,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
      textAlign: textAlign,
      softWrap: softWrap,
    );
  }
}

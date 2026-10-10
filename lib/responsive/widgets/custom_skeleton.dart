import 'package:flutter/material.dart';
import 'package:billing_and_sales_management/responsive/core/responsive_extensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_colors.dart';
import 'package:billing_and_sales_management/responsive/theme/app_dimensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_spacing.dart';

/// Single shimmer block (design's `.skeleton`).
class CustomSkeleton extends StatefulWidget {
  const CustomSkeleton({
    super.key,
    this.width,
    this.height = 14,
    this.radius = AppDimensions.radiusMd,
    this.circle = false,
  });

  final double? width;
  final double height;
  final double radius;
  final bool circle;

  @override
  State<CustomSkeleton> createState() => _CustomSkeletonState();
}

class _CustomSkeletonState extends State<CustomSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          width: widget.width?.w,
          height: widget.height.h,
          decoration: BoxDecoration(
            borderRadius: widget.circle
                ? null
                : BorderRadius.circular(widget.radius.r),
            shape: widget.circle ? BoxShape.circle : BoxShape.rectangle,
            gradient: LinearGradient(
              begin: Alignment(-1 + 2 * _controller.value, 0),
              end: Alignment(1 + 2 * _controller.value, 0),
              colors: const [
                AppColors.neutral200,
                AppColors.neutral100,
                AppColors.neutral200,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Shimmer text line (design's `.skeleton-text`).
class CustomSkeletonText extends StatelessWidget {
  const CustomSkeletonText({super.key, this.width, this.lines = 1});

  final double? width;
  final int lines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < lines; i++) ...[
          CustomSkeleton(
            width: i == lines - 1 && lines > 1 ? (width ?? 160) * 0.7 : width,
          ),
          if (i != lines - 1) SizedBox(height: AppSpacing.sm.h),
        ],
      ],
    );
  }
}

/// Shimmer card (design's `.skeleton-card`).
class CustomSkeletonCard extends StatelessWidget {
  const CustomSkeletonCard({super.key, this.height = 64});

  final double height;

  @override
  Widget build(BuildContext context) {
    return CustomSkeleton(
      width: double.infinity,
      height: height,
      radius: AppDimensions.cardRadius,
    );
  }
}

/// Stack of shimmer cards used while a list loads.
class CustomSkeletonList extends StatelessWidget {
  const CustomSkeletonList({super.key, this.count = 5, this.cardHeight = 64});

  final int count;
  final double cardHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < count; i++) ...[
          CustomSkeletonCard(height: cardHeight),
          if (i != count - 1) SizedBox(height: AppSpacing.cardGap.h),
        ],
      ],
    );
  }
}

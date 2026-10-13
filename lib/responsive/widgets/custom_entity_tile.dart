import 'package:flutter/material.dart';
import 'package:billing_and_sales_management/responsive/core/responsive_extensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_dimensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_palette.dart';
import 'package:billing_and_sales_management/responsive/theme/app_spacing.dart';
import 'package:billing_and_sales_management/responsive/theme/app_text_styles.dart';
import 'package:billing_and_sales_management/responsive/widgets/custom_card.dart';
import 'package:billing_and_sales_management/responsive/widgets/custom_text.dart';

/// Avatar tint of an entity tile (design's `.entity-avatar` variants).
enum EntityAvatarTone { primary, coral, cyan }

/// List tile used by every master-data screen (`.entity-card`):
/// 44 px rounded avatar, 14/600 title, 11 px subtitle and a trailing value
/// with a chevron.
class CustomEntityTile extends StatelessWidget {
  const CustomEntityTile({
    super.key,
    required this.title,
    this.subtitle,
    this.avatarText,
    this.avatarIcon,
    this.avatarTone = EntityAvatarTone.primary,
    this.trailing,
    this.trailingText,
    this.showChevron = true,
    this.onTap,
    this.margin,
  });

  final String title;
  final String? subtitle;

  /// Single character / short label rendered inside the avatar.
  final String? avatarText;

  /// Icon rendered inside the avatar (takes precedence over [avatarText]).
  final IconData? avatarIcon;

  final EntityAvatarTone avatarTone;

  /// Custom trailing widget (e.g. a status badge).
  final Widget? trailing;

  /// Trailing value text (e.g. a price), 13/700 brand primary.
  final String? trailingText;

  final bool showChevron;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  ({Color background, Color foreground}) _tone(AppPalette palette) {
    switch (avatarTone) {
      case EntityAvatarTone.coral:
        return (background: palette.coralSubtle, foreground: palette.coralText);
      case EntityAvatarTone.cyan:
        return (background: palette.cyanLight, foreground: palette.cyanText);
      case EntityAvatarTone.primary:
        return (
          background: palette.primarySubtle,
          foreground: palette.accentText,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final tone = _tone(palette);

    return CustomCard(
      onTap: onTap,
      margin: margin,
      child: Row(
        children: [
          Container(
            width: AppDimensions.avatarSize.r,
            height: AppDimensions.avatarSize.r,
            decoration: BoxDecoration(
              color: tone.background,
              borderRadius: BorderRadius.circular(AppDimensions.avatarRadius.r),
            ),
            alignment: Alignment.center,
            child: avatarIcon != null
                ? Icon(
                    avatarIcon,
                    size: AppDimensions.iconLg.r,
                    color: tone.foreground,
                  )
                : CustomText(
                    text: avatarText ?? '',
                    style: AppTextStyles.sectionTitle,
                    color: tone.foreground,
                    maxLines: 1,
                  ),
          ),
          SizedBox(width: AppSpacing.lg.w - 6.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  text: title,
                  style: AppTextStyles.cardTitle,
                  color: palette.textPrimary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  SizedBox(height: AppSpacing.s2xs.h),
                  CustomText(
                    text: subtitle!,
                    style: AppTextStyles.metaText,
                    color: palette.textMuted,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (trailingText != null) ...[
            SizedBox(width: AppSpacing.sm.w),
            CustomText(
              text: trailingText!,
              style: AppTextStyles.label,
              color: palette.accentText,
            ),
          ],
          if (trailing != null) ...[
            SizedBox(width: AppSpacing.sm.w),
            trailing!,
          ],
          if (showChevron) ...[
            SizedBox(width: AppSpacing.sm.w),
            Icon(
              Icons.chevron_right,
              size: AppDimensions.iconMd.r,
              color: palette.iconMuted,
            ),
          ],
        ],
      ),
    );
  }
}

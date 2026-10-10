import 'dart:async';

import 'package:flutter/material.dart';
import 'package:billing_and_sales_management/responsive/core/responsive_extensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_colors.dart';
import 'package:billing_and_sales_management/responsive/theme/app_dimensions.dart';
import 'package:billing_and_sales_management/responsive/theme/app_spacing.dart';
import 'package:billing_and_sales_management/responsive/theme/app_text_styles.dart';

enum AppSnackType { info, success, error, warning }

class CustomSnackbar {
  CustomSnackbar._();

  static const Duration defaultDuration = Duration(milliseconds: 2600);
  static const Duration _exitDuration = Duration(milliseconds: 280);

  static OverlayEntry? _entry;
  static Timer? _timer;
  static Completer<void>? _completer;
  static ValueNotifier<bool>? _visible;

  static Future<void> show(
    BuildContext context, {
    required String message,
    AppSnackType type = AppSnackType.info,
    IconData? icon,
    Duration duration = defaultDuration,
  }) {
    final overlay = Navigator.of(context, rootNavigator: true).overlay;
    if (overlay == null) return Future<void>.value();

    _dismissCurrent();

    final visible = ValueNotifier<bool>(true);
    final topInset = MediaQuery.paddingOf(context).top;
    final completer = Completer<void>();
    final entry = OverlayEntry(
      builder: (_) => _CustomSnackbarView(
        message: message,
        type: type,
        icon: icon,
        visible: visible,
        topInset: topInset,
      ),
    );

    _entry = entry;
    _completer = completer;
    _visible = visible;
    overlay.insert(entry);

    _timer = Timer(duration, () async {
      visible.value = false;
      await Future<void>.delayed(_exitDuration);
      if (identical(_entry, entry)) {
        _entry = null;
        _timer = null;
        _visible = null;
        _complete(completer);
        entry.remove();
        visible.dispose();
      }
    });

    return completer.future;
  }

  static Future<void> showSuccess(
    BuildContext context,
    String message, {
    IconData? icon,
    Duration duration = defaultDuration,
  }) {
    return show(
      context,
      message: message,
      type: AppSnackType.success,
      icon: icon,
      duration: duration,
    );
  }

  static Future<void> showError(
    BuildContext context,
    String message, {
    IconData? icon,
    Duration duration = defaultDuration,
  }) {
    return show(
      context,
      message: message,
      type: AppSnackType.error,
      icon: icon,
      duration: duration,
    );
  }

  static Future<void> showWarning(
    BuildContext context,
    String message, {
    IconData? icon,
    Duration duration = defaultDuration,
  }) {
    return show(
      context,
      message: message,
      type: AppSnackType.warning,
      icon: icon,
      duration: duration,
    );
  }

  static Future<void> showInfo(
    BuildContext context,
    String message, {
    IconData? icon,
    Duration duration = defaultDuration,
  }) {
    return show(
      context,
      message: message,
      type: AppSnackType.info,
      icon: icon,
      duration: duration,
    );
  }

  static void _dismissCurrent() {
    _timer?.cancel();
    _timer = null;

    final entry = _entry;
    final completer = _completer;
    final visible = _visible;
    _entry = null;
    _completer = null;
    _visible = null;

    entry?.remove();
    visible?.dispose();
    _complete(completer);
  }

  static void _complete(Completer<void>? completer) {
    if (completer != null && !completer.isCompleted) completer.complete();
  }
}

class _CustomSnackbarView extends StatelessWidget {
  const _CustomSnackbarView({
    required this.message,
    required this.type,
    required this.icon,
    required this.visible,
    required this.topInset,
  });

  final String message;
  final AppSnackType type;
  final IconData? icon;
  final ValueNotifier<bool> visible;
  final double topInset;

  ({Color accent, IconData icon}) get _style {
    switch (type) {
      case AppSnackType.success:
        return (accent: AppColors.primary, icon: Icons.check_circle_outline);
      case AppSnackType.error:
        return (accent: AppColors.error, icon: Icons.error_outline);
      case AppSnackType.warning:
        return (accent: AppColors.warning, icon: Icons.warning_amber_outlined);
      case AppSnackType.info:
        return (accent: AppColors.primary, icon: Icons.info_outline);
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _style;
    final resIcon = icon ?? style.icon;

    return PositionedDirectional(
      top: topInset + 8.h,
      start: AppSpacing.base.w,
      end: AppSpacing.base.w,
      child: ValueListenableBuilder<bool>(
        valueListenable: visible,
        builder: (context, show, child) {
          return AnimatedSlide(
            offset: show ? Offset.zero : const Offset(0, -1.2),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            child: AnimatedOpacity(
              opacity: show ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: child,
            ),
          );
        },
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.base.w,
              vertical: AppSpacing.md.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.neutral900,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg.r),
              border: BorderDirectional(
                start: BorderSide(color: style.accent, width: 4.r),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x59000000),
                  blurRadius: 25,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(resIcon, size: 18.r, color: AppColors.white),
                SizedBox(width: AppSpacing.md.w),
                Expanded(
                  child: Text(
                    message,
                    softWrap: true,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

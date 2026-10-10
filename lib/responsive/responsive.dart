/// Public entry point of the design-system / responsive kit.
///
/// Import a single line anywhere in the app:
///
/// ```dart
/// import 'package:billing_and_sales_management/responsive/responsive.dart';
/// ```
///
/// Everything the design system exposes is re-exported here: breakpoints and
/// scaling, theme tokens, layout widgets, reusable UI components and
/// responsive navigation.
library;

// Core — breakpoints, context, scaling.
export 'package:billing_and_sales_management/responsive/core/breakpoints.dart';
export 'package:billing_and_sales_management/responsive/core/responsive_context.dart';
export 'package:billing_and_sales_management/responsive/core/responsive_extensions.dart';
export 'package:billing_and_sales_management/responsive/core/responsive_service.dart';

// Theme — colors, shadows, typography, dimensions, spacing, ThemeData factories.
export 'package:billing_and_sales_management/responsive/theme/app_colors.dart';
export 'package:billing_and_sales_management/responsive/theme/app_dimensions.dart';
export 'package:billing_and_sales_management/responsive/theme/app_shadows.dart';
export 'package:billing_and_sales_management/responsive/theme/app_spacing.dart';
export 'package:billing_and_sales_management/responsive/theme/app_text_styles.dart';
export 'package:billing_and_sales_management/responsive/theme/app_theme.dart';

// Layout — builder, max-width box, adaptive grid/row, sheet, app shell.
export 'package:billing_and_sales_management/responsive/layout/adaptive_card_grid.dart';
export 'package:billing_and_sales_management/responsive/layout/adaptive_form_row.dart';
export 'package:billing_and_sales_management/responsive/layout/max_width_box.dart';
export 'package:billing_and_sales_management/responsive/layout/responsive_builder.dart';
export 'package:billing_and_sales_management/responsive/layout/responsive_layout.dart';
export 'package:billing_and_sales_management/responsive/layout/responsive_sheet_content.dart';

// Widgets — reusable UI built from the reference design.
export 'package:billing_and_sales_management/responsive/widgets/custom_app_bar.dart';
export 'package:billing_and_sales_management/responsive/widgets/custom_bottom_sheet.dart';
export 'package:billing_and_sales_management/responsive/widgets/custom_button.dart';
export 'package:billing_and_sales_management/responsive/widgets/custom_card.dart';
export 'package:billing_and_sales_management/responsive/widgets/custom_chip.dart';
export 'package:billing_and_sales_management/responsive/widgets/custom_dialog.dart';
export 'package:billing_and_sales_management/responsive/widgets/custom_divider.dart';
export 'package:billing_and_sales_management/responsive/widgets/custom_dropdown.dart';
export 'package:billing_and_sales_management/responsive/widgets/custom_empty_state.dart';
export 'package:billing_and_sales_management/responsive/widgets/custom_entity_tile.dart';
export 'package:billing_and_sales_management/responsive/widgets/custom_error_state.dart';
export 'package:billing_and_sales_management/responsive/widgets/custom_icon_button.dart';
export 'package:billing_and_sales_management/responsive/widgets/custom_loading.dart';
export 'package:billing_and_sales_management/responsive/widgets/custom_search_field.dart';
export 'package:billing_and_sales_management/responsive/widgets/custom_section_header.dart';
export 'package:billing_and_sales_management/responsive/widgets/custom_skeleton.dart';
export 'package:billing_and_sales_management/responsive/widgets/custom_snackbar.dart';
export 'package:billing_and_sales_management/responsive/widgets/custom_text.dart';
export 'package:billing_and_sales_management/responsive/widgets/custom_text_field.dart';

// Navigation — items, bottom bar, side rail, resolver.
export 'package:billing_and_sales_management/responsive/navigation/responsive_bottom_nav.dart';
export 'package:billing_and_sales_management/responsive/navigation/responsive_navigation.dart';
export 'package:billing_and_sales_management/responsive/navigation/responsive_side_nav.dart';

import 'package:billing_and_sales_management/core/translate/app_translate.dart';
import 'package:billing_and_sales_management/domain/invoices/entities/invoice_line.dart';
import 'package:billing_and_sales_management/domain/invoices/entities/sales_invoice.dart';
import 'package:billing_and_sales_management/features/dashboard/models/dashboard_state.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class InvoiceDetailsScreen extends StatelessWidget {
  const InvoiceDetailsScreen({super.key, required this.invoice});

  final SalesInvoice invoice;

  static String _initialsOf(String name) {
    final letters = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .map((part) => part[0])
        .join();

    if (letters.isEmpty) return '';

    return letters
        .substring(0, letters.length >= 2 ? 2 : letters.length)
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final isPaid = invoice.isPaid;
    final palette = context.palette;

    return Scaffold(
      appBar: CustomAppBar(
        title: AppTranslate.invoiceDetails.tr(),
        subtitle: AppTranslate.viewReceipt.tr(),
      ),
      body: MaxWidthBox(
        maxWidth: AppDimensions.maxContentWidth,
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.pageHorizontal.w,
            vertical: AppSpacing.base.h,
          ),
          children: [
            CustomCard(
              padding: EdgeInsets.all(18.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: AppTranslate.invoiceNumber.tr(
                                namedArgs: {
                                  'number': invoice.billNumber.toString(),
                                },
                              ),
                              style: AppTextStyles.pageTitle,
                              color: palette.textPrimary,
                            ),
                            SizedBox(height: AppSpacing.s2xs.h),
                            CustomText(
                              text: invoice.billDate,
                              style: AppTextStyles.metaText,
                              color: palette.textMuted,
                            ),
                          ],
                        ),
                      ),
                      CustomChip(
                        label: invoice.isPaid
                            ? AppTranslate.paid.tr()
                            : AppTranslate.unpaid.tr(),
                        variant: isPaid
                            ? CustomChipVariant.success
                            : CustomChipVariant.warning,
                        badge: true,
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: palette.insetSurface,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusMd.r,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 38.r,
                          height: 38.r,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: palette.primarySubtle,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.avatarRadius.r,
                            ),
                          ),
                          child: CustomText(
                            text: _initialsOf(invoice.clientName),
                            style: AppTextStyles.label,
                            fontWeight: FontWeight.w700,
                            color: palette.accentText,
                          ),
                        ),
                        SizedBox(width: AppSpacing.md.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: invoice.clientName,
                                style: AppTextStyles.bodyStrong,
                                color: palette.textPrimary,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              CustomText(
                                text: AppTranslate.clientAccount.tr(),
                                style: AppTextStyles.microLabel,
                                color: palette.textMuted,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  CustomText(
                    text: AppTranslate.itemsCount.tr(
                      namedArgs: {'count': invoice.lines.length.toString()},
                    ),
                    style: AppTextStyles.label,
                    fontWeight: FontWeight.w600,
                    color: palette.textPrimary,
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  for (final line in invoice.lines) ...[
                    _InvoiceLineRow(line: line),
                    SizedBox(height: AppSpacing.sm.h),
                  ],
                  SizedBox(height: AppSpacing.s2xs.h),
                  Container(
                    padding: EdgeInsets.only(top: AppSpacing.md.h),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: palette.border)),
                    ),
                    child: Column(
                      children: [
                        _TotalsRow(
                          label: AppTranslate.billsTotal.tr(),
                          value: DashboardAmountFormatter.format(
                            invoice.billsTotal,
                          ),
                        ),
                        if (invoice.percentageDiscount > 0) ...[
                          SizedBox(height: AppSpacing.s2xs.h),
                          _TotalsRow(
                            label: AppTranslate.discountPercentage.tr(
                              namedArgs: {
                                'percentage': invoice.percentageDiscount
                                    .toString(),
                              },
                            ),
                            value:
                                '-${DashboardAmountFormatter.format((invoice.billsTotal * invoice.percentageDiscount) / 100)}',
                          ),
                        ],
                        if (invoice.valueDiscount > 0) ...[
                          SizedBox(height: AppSpacing.s2xs.h),
                          _TotalsRow(
                            label: AppTranslate.valueDiscount.tr(),
                            value:
                                '-${DashboardAmountFormatter.format(invoice.valueDiscount)}',
                          ),
                        ],
                        SizedBox(height: AppSpacing.s2xs.h),
                        _TotalsRow(
                          label: AppTranslate.theNet.tr(),
                          value: DashboardAmountFormatter.format(
                            invoice.theNet,
                          ),
                          emphasized: true,
                        ),
                        SizedBox(height: AppSpacing.s2xs.h),
                        _TotalsRow(
                          label: AppTranslate.paidUp.tr(),
                          value: DashboardAmountFormatter.format(
                            invoice.paidUp,
                          ),
                        ),
                        SizedBox(height: AppSpacing.sm.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: palette.coralSubtle,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusMd.r,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomText(
                                  text: AppTranslate.theRest.tr(),
                                  style: AppTextStyles.label,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.coral,
                                ),
                              ),
                              CustomText(
                                text: DashboardAmountFormatter.format(
                                  invoice.theRest,
                                ),
                                style: AppTextStyles.label,
                                fontWeight: FontWeight.w800,
                                color: AppColors.coral,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.lg.h),
            CustomButton(
              text: AppTranslate.backToInvoices.tr(),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ],
        ),
      ),
    );
  }
}

class _InvoiceLineRow extends StatelessWidget {
  const _InvoiceLineRow({required this.line});

  final InvoiceLine line;

  static String _formatQuantity(double quantity) {
    if (quantity == quantity.truncateToDouble()) {
      return quantity.toInt().toString();
    }
    return quantity.toString();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: EdgeInsets.only(bottom: AppSpacing.sm.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: palette.border, width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: line.itemName,
                  style: AppTextStyles.label,
                  fontWeight: FontWeight.w600,
                  color: palette.textPrimary,
                ),
                CustomText(
                  text:
                      '${_formatQuantity(line.quantity)} × ${DashboardAmountFormatter.format(line.sellingPrice)}',
                  style: AppTextStyles.metaText,
                  color: palette.textMuted,
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm.w),
          CustomText(
            text: DashboardAmountFormatter.format(line.total),
            style: AppTextStyles.label,
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
          ),
        ],
      ),
    );
  }
}

class _TotalsRow extends StatelessWidget {
  const _TotalsRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      children: [
        Expanded(
          child: CustomText(
            text: label,
            style: emphasized
                ? AppTextStyles.sectionTitle
                : AppTextStyles.bodySmall,
            color: emphasized ? palette.accentText : palette.textSecondary,
          ),
        ),
        CustomText(
          text: value,
          style: emphasized
              ? AppTextStyles.sectionTitle
              : AppTextStyles.bodySmall,
          fontWeight: emphasized ? FontWeight.w700 : FontWeight.w400,
          color: emphasized ? palette.accentText : palette.textSecondary,
        ),
      ],
    );
  }
}

import 'package:billing_and_sales_management/domain/invoices/entities/invoice_line.dart';
import 'package:billing_and_sales_management/domain/invoices/entities/sales_invoice.dart';
import 'package:billing_and_sales_management/features/dashboard/models/dashboard_state.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';
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

  static String _formatPercentage(double value) {
    if (value == value.truncateToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isPaid = invoice.isPaid;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Invoice Details',
        subtitle: 'View Receipt',
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
                              text: 'Invoice #${invoice.billNumber}',
                              style: AppTextStyles.pageTitle,
                              color: AppColors.neutral900,
                            ),
                            SizedBox(height: AppSpacing.s2xs.h),
                            CustomText(
                              text: invoice.billDate,
                              style: AppTextStyles.metaText,
                              color: AppColors.neutral500,
                            ),
                          ],
                        ),
                      ),
                      CustomChip(
                        label: invoice.status,
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
                      color: AppColors.neutral50,
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
                            color: AppColors.primarySubtle,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.avatarRadius.r,
                            ),
                          ),
                          child: CustomText(
                            text: _initialsOf(invoice.clientName),
                            style: AppTextStyles.label,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
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
                                color: AppColors.neutral900,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              CustomText(
                                text: 'Client Account',
                                style: AppTextStyles.microLabel,
                                color: AppColors.neutral500,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  CustomText(
                    text: 'Items (${invoice.lines.length})',
                    style: AppTextStyles.label,
                    fontWeight: FontWeight.w600,
                    color: AppColors.neutral800,
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  for (final line in invoice.lines) ...[
                    _InvoiceLineRow(line: line),
                    SizedBox(height: AppSpacing.sm.h),
                  ],
                  SizedBox(height: AppSpacing.s2xs.h),
                  Container(
                    padding: EdgeInsets.only(top: AppSpacing.md.h),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: AppColors.neutral200),
                      ),
                    ),
                    child: Column(
                      children: [
                        _TotalsRow(
                          label: 'Bills Total',
                          value: DashboardAmountFormatter.format(
                            invoice.billsTotal,
                          ),
                        ),
                        if (invoice.percentageDiscount > 0) ...[
                          SizedBox(height: AppSpacing.s2xs.h),
                          _TotalsRow(
                            label: 'Discount (${invoice.percentageDiscount}%)',
                            value:
                                '-${DashboardAmountFormatter.format((invoice.billsTotal * invoice.percentageDiscount) / 100)}',
                          ),
                        ],
                        if (invoice.valueDiscount > 0) ...[
                          SizedBox(height: AppSpacing.s2xs.h),
                          _TotalsRow(
                            label: 'Value Discount',
                            value:
                                '-${DashboardAmountFormatter.format(invoice.valueDiscount)}',
                          ),
                        ],
                        SizedBox(height: AppSpacing.s2xs.h),
                        _TotalsRow(
                          label: 'The Net',
                          value: DashboardAmountFormatter.format(
                            invoice.theNet,
                          ),
                          emphasized: true,
                        ),
                        SizedBox(height: AppSpacing.s2xs.h),
                        _TotalsRow(
                          label: 'Paid Up',
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
                            color: AppColors.coralSubtle,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusMd.r,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomText(
                                  text: 'The Rest',
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
              text: 'Back to Invoices',
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
    return Container(
      padding: EdgeInsets.only(bottom: AppSpacing.sm.h),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.neutral200, width: 1),
        ),
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
                  color: AppColors.neutral800,
                ),
                CustomText(
                  text:
                      '${_formatQuantity(line.quantity)} × ${DashboardAmountFormatter.format(line.sellingPrice)}',
                  style: AppTextStyles.metaText,
                  color: AppColors.neutral500,
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm.w),
          CustomText(
            text: DashboardAmountFormatter.format(line.total),
            style: AppTextStyles.label,
            fontWeight: FontWeight.w700,
            color: AppColors.neutral900,
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
    return Row(
      children: [
        Expanded(
          child: CustomText(
            text: label,
            style: emphasized
                ? AppTextStyles.sectionTitle
                : AppTextStyles.bodySmall,
            color: emphasized ? AppColors.primary : AppColors.neutral600,
          ),
        ),
        CustomText(
          text: value,
          style: emphasized
              ? AppTextStyles.sectionTitle
              : AppTextStyles.bodySmall,
          fontWeight: emphasized ? FontWeight.w700 : FontWeight.w400,
          color: emphasized ? AppColors.primary : AppColors.neutral600,
        ),
      ],
    );
  }
}

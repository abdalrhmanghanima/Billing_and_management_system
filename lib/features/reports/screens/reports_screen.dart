import 'package:billing_and_sales_management/core/translate/app_translate.dart';
import 'package:billing_and_sales_management/domain/invoices/entities/sales_invoice.dart';
import 'package:billing_and_sales_management/features/dashboard/models/dashboard_state.dart';
import 'package:billing_and_sales_management/features/invoices/providers/invoices_notifier.dart';
import 'package:billing_and_sales_management/features/invoices/screens/invoice_details_screen.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  late final TextEditingController _fromDateController;
  late final TextEditingController _toDateController;

  late DateTime _fromDate;
  late DateTime _toDate;

  String? _rangeError;
  bool _reportGenerated = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _fromDate = DateTime(now.year, now.month, 1);
    _toDate = now;
    _fromDateController = TextEditingController(text: _toIsoDate(_fromDate));
    _toDateController = TextEditingController(text: _toIsoDate(_toDate));
  }

  @override
  void dispose() {
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  String _toIsoDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  Future<void> _pickFromDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fromDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _fromDate = picked;
        _fromDateController.text = _toIsoDate(picked);
        _rangeError = null;
      });
    }
  }

  Future<void> _pickToDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _toDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _toDate = picked;
        _toDateController.text = _toIsoDate(picked);
        _rangeError = null;
      });
    }
  }

  void _showReport() {
    final fromEmpty = _fromDateController.text.trim().isEmpty;
    final toEmpty = _toDateController.text.trim().isEmpty;

    if (fromEmpty || toEmpty) {
      setState(() => _rangeError = AppTranslate.pleaseSelectBothDates.tr());
      return;
    }

    if (_fromDate.isAfter(_toDate)) {
      setState(() => _rangeError = AppTranslate.fromDateAfterToDate.tr());
      return;
    }

    setState(() {
      _rangeError = null;
      _reportGenerated = true;
    });
  }

  List<SalesInvoice> _filterByRange(List<SalesInvoice> invoices) {
    final from = DateTime(_fromDate.year, _fromDate.month, _fromDate.day);
    final to = DateTime(_toDate.year, _toDate.month, _toDate.day);

    return invoices.where((invoice) {
      final parsed = DateTime.tryParse(invoice.billDate.trim());
      if (parsed == null) return false;
      final day = DateTime(parsed.year, parsed.month, parsed.day);
      return !day.isBefore(from) && !day.isAfter(to);
    }).toList();
  }

  void _openInvoiceDetails(SalesInvoice invoice) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => InvoiceDetailsScreen(invoice: invoice),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final invoicesState = ref.watch(invoicesProvider);

    return Scaffold(
      appBar: CustomAppBar(title: AppTranslate.salesReport.tr()),
      body: SafeArea(
        top: false,
        child: MaxWidthBox(
          maxWidth: AppDimensions.maxContentWidth,
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.pageHorizontal.w,
              AppSpacing.pageTop.h,
              AppSpacing.pageHorizontal.w,
              AppSpacing.pageBottom.h,
            ),
            children: [
              _buildPeriodCard(),
              SizedBox(height: AppSpacing.lg.h),
              _buildResults(invoicesState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodCard() {
    return CustomCard(
      padding: EdgeInsets.all(AppSpacing.base.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdaptiveFormRow(
            children: [
              CustomTextField(
                controller: _fromDateController,
                label: AppTranslate.fromDate.tr(),
                isRequired: true,
                hint: AppTranslate.dateFormatHint.tr(),
                prefixIcon: const Icon(Icons.calendar_today_outlined),
                readOnly: true,
                onTap: _pickFromDate,
              ),
              CustomTextField(
                controller: _toDateController,
                label: AppTranslate.toDate.tr(),
                isRequired: true,
                hint: AppTranslate.dateFormatHint.tr(),
                prefixIcon: const Icon(Icons.calendar_today_outlined),
                readOnly: true,
                onTap: _pickToDate,
              ),
            ],
          ),
          if (_rangeError != null) ...[
            SizedBox(height: AppSpacing.xs.h),
            CustomText(
              text: _rangeError!,
              style: AppTextStyles.fieldError,
              color: AppColors.error,
            ),
          ],
          SizedBox(height: AppSpacing.md.h),
          CustomButton(
            text: AppTranslate.showReport.tr(),
            onPressed: _showReport,
          ),
        ],
      ),
    );
  }

  Widget _buildResults(AsyncValue<List<SalesInvoice>> invoicesState) {
    return invoicesState.when(
      loading: () => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomSkeleton(height: 64.h),
          SizedBox(height: AppSpacing.cardGap.h),
          CustomSkeleton(height: 64.h),
          SizedBox(height: AppSpacing.cardGap.h),
          CustomSkeleton(height: 64.h),
        ],
      ),
      error: (error, _) => CustomErrorState(
        title: AppTranslate.couldNotLoadInvoices.tr(),
        onRetry: () => ref.read(invoicesProvider.notifier).refresh(),
      ),
      data: (invoices) {
        if (!_reportGenerated) {
          return CustomEmptyState(
            icon: Icons.assessment_outlined,
            iconColor: context.palette.purpleText,
            iconBackgroundColor: context.palette.purpleSubtle,
            title: AppTranslate.noDataYet.tr(),
            message: AppTranslate.selectPeriodAndShowReportMessage.tr(),
          );
        }

        final filtered = _filterByRange(invoices);

        if (filtered.isEmpty) {
          return CustomEmptyState(
            icon: Icons.assessment_outlined,
            iconColor: context.palette.purpleText,
            iconBackgroundColor: context.palette.purpleSubtle,
            title: AppTranslate.noInvoicesFound.tr(),
            message: AppTranslate.noInvoicesInPeriodMessage.tr(),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomSectionHeader(title: AppTranslate.salesInvoices.tr()),
            for (var i = 0; i < filtered.length; i++) ...[
              if (i > 0) SizedBox(height: AppSpacing.cardGap.h),
              _ReportInvoiceTile(
                invoice: filtered[i],
                onTap: () => _openInvoiceDetails(filtered[i]),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _ReportInvoiceTile extends StatelessWidget {
  const _ReportInvoiceTile({required this.invoice, this.onTap});

  final SalesInvoice invoice;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return CustomCard(
      onTap: onTap,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Row(
        children: [
          Container(
            width: 55.r,
            height: 35.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: palette.primarySubtle,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd.r),
            ),
            padding: EdgeInsets.only(left: 4.w, right: 4.w),
            child: CustomText(
              text: '#${invoice.billNumber}',
              style: AppTextStyles.label,
              fontWeight: FontWeight.w700,
              color: palette.accentText,
            ),
          ),
          SizedBox(width: AppSpacing.cardGap.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: invoice.clientName,
                  style: AppTextStyles.label,
                  fontWeight: FontWeight.w700,
                  color: palette.textPrimary,
                  maxLines: 1,
                ),
                CustomText(
                  text: invoice.billDate,
                  fontSize: AppTextStyles.size2xs,
                  color: palette.textMuted,
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                text: DashboardAmountFormatter.format(invoice.billsTotal),
                style: AppTextStyles.label,
                fontWeight: FontWeight.w700,
                color: palette.textPrimary,
              ),
              SizedBox(height: AppSpacing.s2xs.h),
              CustomChip(
                label: invoice.isPaid
                    ? AppTranslate.paid.tr()
                    : AppTranslate.unpaid.tr(),
                variant: invoice.isPaid
                    ? CustomChipVariant.success
                    : CustomChipVariant.warning,
                badge: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

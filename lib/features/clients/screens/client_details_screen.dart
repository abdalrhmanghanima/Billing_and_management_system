import 'dart:ui' as ui;

import 'package:billing_and_sales_management/core/translate/app_translate.dart';
import 'package:billing_and_sales_management/domain/clients/entities/client.dart';
import 'package:billing_and_sales_management/domain/invoices/entities/sales_invoice.dart';
import 'package:billing_and_sales_management/domain/request_forms/entities/request_form.dart';
import 'package:billing_and_sales_management/features/clients/print/client_invoice_history_pdf.dart';
import 'package:billing_and_sales_management/features/dashboard/models/dashboard_state.dart';
import 'package:billing_and_sales_management/features/invoices/providers/invoices_notifier.dart';
import 'package:billing_and_sales_management/features/invoices/screens/invoice_details_screen.dart';
import 'package:billing_and_sales_management/features/request_forms/providers/request_forms_notifier.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

class ClientDetailsScreen extends ConsumerStatefulWidget {
  const ClientDetailsScreen({super.key, required this.client});

  final Client client;

  @override
  ConsumerState<ClientDetailsScreen> createState() =>
      _ClientDetailsScreenState();
}

class _ClientDetailsScreenState extends ConsumerState<ClientDetailsScreen> {
  late int _selectedMonth;
  late int _selectedYear;

  bool _isPrinting = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = now.month;
    _selectedYear = now.year;
  }

  Future<void> _refresh() async {
    ref.invalidate(clientRequestFormsProvider);
    await ref.read(invoicesProvider.notifier).refresh();
  }

  String _monthLabel(int month, int year) {
    return '${AppTranslate.monthNames[month - 1].tr()} $year';
  }

  void _previousMonth() {
    setState(() {
      if (_selectedMonth == 1) {
        _selectedMonth = 12;
        _selectedYear -= 1;
      } else {
        _selectedMonth -= 1;
      }
    });
  }

  void _nextMonth() {
    setState(() {
      if (_selectedMonth == 12) {
        _selectedMonth = 1;
        _selectedYear += 1;
      } else {
        _selectedMonth += 1;
      }
    });
  }

  Future<void> _pickMonthYear() async {
    final picked = await showResponsiveDialog<(int, int)>(
      context: context,
      builder: (_) => _MonthYearPickerDialog(
        initialMonth: _selectedMonth,
        initialYear: _selectedYear,
      ),
    );

    if (picked == null || !mounted) return;

    setState(() {
      _selectedMonth = picked.$1;
      _selectedYear = picked.$2;
    });
  }

  List<SalesInvoice> _filterInvoices(List<SalesInvoice> invoices) {
    final filtered = invoices.where((invoice) {
      if (invoice.clientId != widget.client.id) return false;

      final parsed = DateTime.tryParse(invoice.billDate.trim());
      if (parsed == null) return false;

      return parsed.year == _selectedYear && parsed.month == _selectedMonth;
    }).toList();

    filtered.sort((a, b) {
      final byDate = b.billDate.compareTo(a.billDate);
      if (byDate != 0) return byDate;
      return b.billNumber.compareTo(a.billNumber);
    });

    return filtered;
  }

  Future<void> _printInvoiceHistory(List<SalesInvoice> invoices) async {
    if (_isPrinting || invoices.isEmpty) return;

    setState(() => _isPrinting = true);

    try {
      final isRtl = Directionality.of(context) == ui.TextDirection.rtl;

      final bytes = await ClientInvoiceHistoryPdf.build(
        client: widget.client,
        invoices: invoices,
        isRtl: isRtl,
        labels: ClientInvoiceHistoryReportLabels(
          title: AppTranslate.invoiceHistory.tr(),
          period: _monthLabel(_selectedMonth, _selectedYear),
          clientNumber: AppTranslate.clientNumber.tr(),
          clientName: AppTranslate.clientName.tr(),
          phone: AppTranslate.phone.tr(),
          address: AppTranslate.address.tr(),
          invoiceNumber: AppTranslate.invoiceNumberHeader.tr(),
          date: AppTranslate.date.tr(),
          netTotal: AppTranslate.theNet.tr(),
          paidAmount: AppTranslate.paidUp.tr(),
          remainingAmount: AppTranslate.theRest.tr(),
          status: AppTranslate.status.tr(),
          paid: AppTranslate.paid.tr(),
          unpaid: AppTranslate.unpaid.tr(),
          totals: AppTranslate.totals.tr(),
        ),
      );

      await Printing.layoutPdf(onLayout: (_) async => bytes);
    } catch (_) {
      if (mounted) {
        CustomSnackbar.showError(
          context,
          AppTranslate.couldNotPrintInvoiceHistory.tr(),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPrinting = false);
      }
    }
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
    final palette = context.palette;
    final client = widget.client;
    final invoicesState = ref.watch(invoicesProvider);
    final requestFormsState = ref.watch(clientRequestFormsProvider(client.id));
    final loadedInvoices = invoicesState.valueOrNull;
    final printableInvoices = loadedInvoices == null
        ? const <SalesInvoice>[]
        : _filterInvoices(loadedInvoices);

    return Scaffold(
      appBar: CustomAppBar(
        title: client.name,
        subtitle: AppTranslate.clientDetails.tr(),
      ),
      body: MaxWidthBox(
        maxWidth: AppDimensions.maxContentWidth,
        child: RefreshIndicator(
          color: context.palette.accentText,
          onRefresh: _refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.pageHorizontal.w,
              vertical: AppSpacing.base.h,
            ),
            children: [
              _ClientInfoCard(client: client),
              SizedBox(height: AppSpacing.lg.h),
              CustomSectionHeader(
                title: AppTranslate.invoiceHistory.tr(),
                trailing: CustomButton(
                  text: AppTranslate.print.tr(),
                  variant: CustomButtonVariant.outline,
                  size: CustomButtonSize.small,
                  icon: Icons.print_outlined,
                  width: 110.w,
                  loading: _isPrinting,
                  onPressed: _isPrinting || printableInvoices.isEmpty
                      ? null
                      : () => _printInvoiceHistory(printableInvoices),
                ),
              ),
              CustomCard(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md.w,
                  vertical: AppSpacing.sm.h,
                ),
                child: Row(
                  children: [
                    CustomIconButton(
                      icon: Icons.chevron_left,
                      onPressed: _previousMonth,
                      tooltip: AppTranslate.previousMonth.tr(),
                      size: AppDimensions.headerActionSize,
                      iconSize: AppDimensions.iconSm,
                      shadow: false,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: _pickMonthYear,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMd.r,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm.w,
                            vertical: AppSpacing.xs.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: CustomText(
                                  text: _monthLabel(
                                    _selectedMonth,
                                    _selectedYear,
                                  ),
                                  style: AppTextStyles.sectionTitle,
                                  color: palette.textPrimary,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: AppSpacing.xs.w),
                              Icon(
                                Icons.expand_more,
                                size: AppDimensions.iconMd.r,
                                color: palette.iconMuted,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    CustomIconButton(
                      icon: Icons.chevron_right,
                      onPressed: _nextMonth,
                      tooltip: AppTranslate.nextMonth.tr(),
                      size: AppDimensions.headerActionSize,
                      iconSize: AppDimensions.iconSm,
                      shadow: false,
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.md.h),
              ..._buildInvoiceHistory(invoicesState),
              SizedBox(height: AppSpacing.lg.h),
              CustomSectionHeader(title: AppTranslate.requestFormsHistory.tr()),
              ..._buildRequestFormsHistory(requestFormsState),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildInvoiceHistory(AsyncValue<List<SalesInvoice>> state) {
    return state.when(
      loading: () => [const CustomSkeletonList(count: 3)],
      error: (error, _) => [
        CustomErrorState(
          title: AppTranslate.couldNotLoadInvoices.tr(),
          onRetry: () => ref.read(invoicesProvider.notifier).refresh(),
        ),
      ],
      data: (invoices) {
        final filtered = _filterInvoices(invoices);

        if (filtered.isEmpty) {
          return [
            CustomEmptyState(
              icon: Icons.receipt_long_outlined,
              iconColor: context.palette.accentText,
              iconBackgroundColor: context.palette.primarySubtle,
              title: AppTranslate.noInvoicesForPeriod.tr(),
              message: AppTranslate.noInvoicesForClientInPeriodMessage.tr(),
            ),
          ];
        }

        return [
          for (var i = 0; i < filtered.length; i++) ...[
            if (i > 0) SizedBox(height: AppSpacing.cardGap.h),
            _ClientInvoiceTile(
              invoice: filtered[i],
              onTap: () => _openInvoiceDetails(filtered[i]),
            ),
          ],
        ];
      },
    );
  }

  List<Widget> _buildRequestFormsHistory(AsyncValue<List<RequestForm>> state) {
    return state.when(
      loading: () => [const CustomSkeletonList(count: 2)],
      error: (error, _) => [
        CustomErrorState(
          title: AppTranslate.couldNotLoadRequests.tr(),
          onRetry: () => ref.invalidate(clientRequestFormsProvider),
        ),
      ],
      data: (requestForms) {
        if (requestForms.isEmpty) {
          return [
            CustomEmptyState(
              icon: Icons.assignment_outlined,
              iconColor: context.palette.purpleText,
              iconBackgroundColor: context.palette.purpleSubtle,
              title: AppTranslate.noRequestsYet.tr(),
              message: AppTranslate.noRequestsForClientMessage.tr(),
            ),
          ];
        }

        return [
          for (var i = 0; i < requestForms.length; i++) ...[
            if (i > 0) SizedBox(height: AppSpacing.cardGap.h),
            CustomEntityTile(
              avatarIcon: Icons.schedule_outlined,
              avatarTone: i.isEven
                  ? EntityAvatarTone.primary
                  : EntityAvatarTone.cyan,
              title: requestForms[i].date,
              subtitle:
                  '${requestForms[i].startTime} - ${requestForms[i].endTime}',
              showChevron: false,
            ),
          ],
        ];
      },
    );
  }
}

class _ClientInfoCard extends StatelessWidget {
  const _ClientInfoCard({required this.client});

  final Client client;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return CustomCard(
      padding: EdgeInsets.all(18.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 48.r,
                height: 48.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: palette.primarySubtle,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.avatarRadius.r,
                  ),
                ),
                child: CustomText(
                  text: client.initials,
                  style: AppTextStyles.sectionTitle,
                  color: palette.accentText,
                ),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: client.name,
                      style: AppTextStyles.cardTitle,
                      color: palette.textPrimary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppSpacing.s2xs.h),
                    CustomText(
                      text:
                          '${AppTranslate.clientNumber.tr()} #${client.number}',
                      style: AppTextStyles.metaText,
                      color: palette.textMuted,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),
          _ClientInfoRow(
            icon: Icons.phone_outlined,
            label: AppTranslate.phone.tr(),
            value: client.phone,
          ),
          SizedBox(height: AppSpacing.sm.h),
          _ClientInfoRow(
            icon: Icons.location_on_outlined,
            label: AppTranslate.address.tr(),
            value: client.address,
          ),
        ],
      ),
    );
  }
}

class _ClientInfoRow extends StatelessWidget {
  const _ClientInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: AppDimensions.iconMd.r, color: palette.iconMuted),
        SizedBox(width: AppSpacing.sm.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: label,
                style: AppTextStyles.microLabel,
                color: palette.textMuted,
              ),
              CustomText(
                text: value,
                style: AppTextStyles.label,
                fontWeight: FontWeight.w600,
                color: palette.textPrimary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ClientInvoiceTile extends StatelessWidget {
  const _ClientInvoiceTile({required this.invoice, this.onTap});

  final SalesInvoice invoice;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return CustomCard(
      onTap: onTap,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 55.r,
                height: 35.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: palette.primarySubtle,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: CustomText(
                  text: '#${invoice.billNumber}',
                  style: AppTextStyles.label,
                  fontWeight: FontWeight.w700,
                  color: palette.accentText,
                ),
              ),
              SizedBox(width: AppSpacing.cardGap.w),
              Expanded(
                child: CustomText(
                  text: invoice.billDate,
                  style: AppTextStyles.metaText,
                  color: palette.textMuted,
                ),
              ),
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
          SizedBox(height: AppSpacing.sm.h),
          Container(
            padding: EdgeInsets.only(top: AppSpacing.sm.h),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: palette.border)),
            ),
            child: Row(
              children: [
                _InvoiceAmountColumn(
                  label: AppTranslate.theNet.tr(),
                  value: DashboardAmountFormatter.format(invoice.theNet),
                ),
                _InvoiceAmountColumn(
                  label: AppTranslate.paidUp.tr(),
                  value: DashboardAmountFormatter.format(invoice.paidUp),
                ),
                _InvoiceAmountColumn(
                  label: AppTranslate.theRest.tr(),
                  value: DashboardAmountFormatter.format(invoice.theRest),
                  highlight: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoiceAmountColumn extends StatelessWidget {
  const _InvoiceAmountColumn({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: label,
            style: AppTextStyles.microLabel,
            color: palette.textMuted,
            maxLines: 1,
          ),
          SizedBox(height: AppSpacing.s3xs.h),
          CustomText(
            text: value,
            style: AppTextStyles.label,
            fontWeight: FontWeight.w700,
            color: highlight ? AppColors.coral : palette.textPrimary,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _MonthYearPickerDialog extends StatefulWidget {
  const _MonthYearPickerDialog({
    required this.initialMonth,
    required this.initialYear,
  });

  final int initialMonth;
  final int initialYear;

  @override
  State<_MonthYearPickerDialog> createState() => _MonthYearPickerDialogState();
}

class _MonthYearPickerDialogState extends State<_MonthYearPickerDialog> {
  late int _month;
  late int _year;

  @override
  void initState() {
    super.initState();
    _month = widget.initialMonth;
    _year = widget.initialYear;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final years = [for (var year = now.year + 1; year >= 2000; year--) year];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomText(
          text: AppTranslate.selectMonthAndYear.tr(),
          style: AppTextStyles.sectionTitle,
          color: context.palette.textPrimary,
        ),
        SizedBox(height: AppSpacing.md.h),
        CustomDropdown<int>(
          label: AppTranslate.month.tr(),
          options: [for (var month = 1; month <= 12; month--) month],
          value: _month,
          labelOf: (month) => AppTranslate.monthNames[month - 1].tr(),
          onChanged: (month) {
            if (month != null) setState(() => _month = month);
          },
        ),
        SizedBox(height: AppSpacing.formGroupGap.h),
        CustomDropdown<int>(
          label: AppTranslate.year.tr(),
          options: years,
          value: _year,
          labelOf: (year) => year.toString(),
          onChanged: (year) {
            if (year != null) setState(() => _year = year);
          },
        ),
        SizedBox(height: AppSpacing.lg.h),
        CustomButton(
          text: AppTranslate.apply.tr(),
          onPressed: () => Navigator.of(context).pop((_month, _year)),
        ),
      ],
    );
  }
}

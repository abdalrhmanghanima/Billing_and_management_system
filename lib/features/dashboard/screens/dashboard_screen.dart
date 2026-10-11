import 'package:billing_and_sales_management/domain/invoices/entities/sales_invoice.dart';
import 'package:billing_and_sales_management/features/clients/providers/clients_notifier.dart';
import 'package:billing_and_sales_management/features/dashboard/models/dashboard_state.dart';
import 'package:billing_and_sales_management/features/dashboard/providers/dashboard_provider.dart';
import 'package:billing_and_sales_management/features/home/providers/selected_tab_provider.dart';
import 'package:billing_and_sales_management/features/invoices/providers/invoices_notifier.dart';
import 'package:billing_and_sales_management/features/invoices/screens/create_invoice_screen.dart';
import 'package:billing_and_sales_management/features/invoices/screens/invoice_details_screen.dart';
import 'package:billing_and_sales_management/features/items/providers/items_notifier.dart';
import 'package:billing_and_sales_management/features/reports/screens/reports_screen.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  static const int _clientsTabIndex = 1;
  static const int _itemsTabIndex = 2;
  static const int _recentInvoiceLimit = 5;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardProvider);

    void openTab(int index) {
      ref.read(selectedTabProvider.notifier).select(index);
    }

    void openCreateInvoice() {
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const CreateInvoiceScreen()),
      );
    }

    void openInvoiceDetails(SalesInvoice invoice) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => InvoiceDetailsScreen(invoice: invoice),
        ),
      );
    }

    void openReports() {
      Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => const ReportsScreen()));
    }

    final recentInvoices = state.recentInvoices.length > _recentInvoiceLimit
        ? state.recentInvoices.sublist(0, _recentInvoiceLimit)
        : state.recentInvoices;

    return SafeArea(
      bottom: false,
      child: MaxWidthBox(
        maxWidth: AppDimensions.maxContentWidth,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.pageHorizontal.w,
            AppSpacing.base.h,
            AppSpacing.pageHorizontal.w,
            AppSpacing.xl.h,
          ),
          children: [
            _DashboardHeader(
              onNotificationsTap: () => CustomSnackbar.showInfo(
                context,
                'No new notifications at this time.',
              ),
            ),
            SizedBox(height: AppSpacing.base.h),
            if (state.isLoading) ...[
              const Center(child: CustomLoading(color: AppColors.primary)),
              SizedBox(height: AppSpacing.lg.h),
            ] else if (state.errorMessage != null) ...[
              CustomErrorState(
                title: 'Could not load dashboard',
                message: state.errorMessage,
                onRetry: () {
                  ref.invalidate(invoicesProvider);
                  ref.invalidate(clientsProvider);
                  ref.invalidate(itemsProvider);
                },
              ),
              SizedBox(height: AppSpacing.lg.h),
            ] else ...[
              _SummaryStatsRow(state: state),
              SizedBox(height: AppSpacing.lg.h),
            ],
            _QuickActionsGrid(
              onNewInvoice: openCreateInvoice,
              onAddClient: () => openTab(_clientsTabIndex),
              onAddItem: () => openTab(_itemsTabIndex),
              onSalesReport: openReports,
            ),
            SizedBox(height: AppSpacing.xl.h),
            CustomSectionHeader(
              title: 'Recent Invoices',
              actionLabel: 'See All',
              onAction: openReports,
            ),
            if (state.isLoading)
              CustomSkeleton(height: 64.h)
            else if (state.errorMessage != null)
              CustomErrorState(
                title: 'Could not load invoices',
                message: state.errorMessage,
                onRetry: () => ref.invalidate(invoicesProvider),
              )
            else
              _RecentInvoicesList(
                invoices: recentInvoices,
                onCreateInvoice: openCreateInvoice,
                onInvoiceTap: (invoice) {
                  if (invoice.invoice != null) {
                    openInvoiceDetails(invoice.invoice!);
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({required this.onNotificationsTap});

  final VoidCallback onNotificationsTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Good day',
                style: AppTextStyles.caption,
                fontWeight: FontWeight.w500,
                color: AppColors.neutral500,
              ),
              SizedBox(height: AppSpacing.s3xs.h),
              CustomText(
                text: 'Billing & Sales',
                style: AppTextStyles.pageTitle,
                letterSpacing: -0.3,
                color: AppColors.neutral900,
              ),
            ],
          ),
        ),
        CustomIconButton(
          icon: Icons.notifications_outlined,
          onPressed: onNotificationsTap,
          size: AppDimensions.headerActionSize,
          iconSize: AppDimensions.iconMd,
          shadow: false,
          tooltip: 'Notifications',
        ),
      ],
    );
  }
}

class _SummaryStatsRow extends StatelessWidget {
  const _SummaryStatsRow({required this.state});

  final DashboardState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatChip(value: '${state.invoiceCount}', label: 'Invoices'),
        ),
        SizedBox(width: AppSpacing.cardGap.w),
        Expanded(
          child: _StatChip(value: '${state.clientCount}', label: 'Clients'),
        ),
        SizedBox(width: AppSpacing.cardGap.w),
        Expanded(
          child: _StatChip(value: '${state.itemCount}', label: 'Items'),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg.r),
        border: Border.all(color: AppColors.neutral200),
        boxShadow: AppShadows.xs,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: value,
            style: AppTextStyles.amount,
            color: AppColors.primary,
          ),
          SizedBox(height: AppSpacing.s3xs.h),
          CustomText(
            text: label.toUpperCase(),
            style: AppTextStyles.microLabel,
            color: AppColors.neutral500,
          ),
        ],
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid({
    required this.onNewInvoice,
    required this.onAddClient,
    required this.onAddItem,
    required this.onSalesReport,
  });

  final VoidCallback onNewInvoice;
  final VoidCallback onAddClient;
  final VoidCallback onAddItem;
  final VoidCallback onSalesReport;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _ActionCard(
                icon: Icons.receipt_long_outlined,
                title: 'New Invoice',
                iconColor: AppColors.coral,
                iconBackground: AppColors.coralSubtle,
                onTap: onNewInvoice,
              ),
            ),
            SizedBox(width: AppSpacing.cardGap.w),
            Expanded(
              child: _ActionCard(
                icon: Icons.people_outline,
                title: 'Add Client',
                iconColor: AppColors.cyanDark,
                iconBackground: AppColors.cyanLight,
                onTap: onAddClient,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.cardGap.h),
        Row(
          children: [
            Expanded(
              child: _ActionCard(
                icon: Icons.inventory_2_outlined,
                title: 'Add Item',
                iconColor: AppColors.primary,
                iconBackground: AppColors.primarySubtle,
                onTap: onAddItem,
              ),
            ),
            SizedBox(width: AppSpacing.cardGap.w),
            Expanded(
              child: _ActionCard(
                icon: Icons.show_chart,
                title: 'Sales Report',
                iconColor: AppColors.purple,
                iconBackground: AppColors.purpleSubtle,
                onTap: onSalesReport,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.iconColor,
    required this.iconBackground,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final Color iconColor;
  final Color iconBackground;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38.r,
            height: 38.r,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd.r),
            ),
            child: Icon(icon, size: AppDimensions.iconMd.r, color: iconColor),
          ),
          SizedBox(height: AppSpacing.cardGap.h),
          CustomText(
            text: title,
            style: AppTextStyles.label,
            fontWeight: FontWeight.w700,
            color: AppColors.neutral800,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _RecentInvoicesList extends StatelessWidget {
  const _RecentInvoicesList({
    required this.invoices,
    required this.onCreateInvoice,
    required this.onInvoiceTap,
  });

  final List<DashboardRecentInvoice> invoices;
  final VoidCallback onCreateInvoice;
  final ValueChanged<DashboardRecentInvoice> onInvoiceTap;

  @override
  Widget build(BuildContext context) {
    if (invoices.isEmpty) {
      return CustomEmptyState(
        icon: Icons.receipt_long_outlined,
        title: 'No Invoices Yet',
        message: 'Create your first sales invoice to see it listed here.',
        action: CustomButton(
          text: '+ Create Invoice',
          size: CustomButtonSize.small,
          onPressed: onCreateInvoice,
        ),
      );
    }

    return Column(
      children: [
        for (var i = 0; i < invoices.length; i++) ...[
          if (i > 0) SizedBox(height: AppSpacing.cardGap.h),
          _RecentInvoiceTile(
            invoice: invoices[i],
            onTap: () => onInvoiceTap(invoices[i]),
          ),
        ],
      ],
    );
  }
}

class _RecentInvoiceTile extends StatelessWidget {
  const _RecentInvoiceTile({required this.invoice, this.onTap});

  final DashboardRecentInvoice invoice;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
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
              color: AppColors.primarySubtle,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd.r),
            ),
            padding: EdgeInsets.only(left: 4.w,right: 4.w),
            child: CustomText(
              text: '#${invoice.billNumber}',
              style: AppTextStyles.label,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
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
                  color: AppColors.neutral900,
                  maxLines: 1,
                ),
                CustomText(
                  text: invoice.billDate,
                  fontSize: AppTextStyles.size2xs,
                  color: AppColors.neutral500,
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                text: invoice.formattedBillsTotal,
                style: AppTextStyles.label,
                fontWeight: FontWeight.w700,
                color: AppColors.neutral900,
              ),
              SizedBox(height: AppSpacing.s2xs.h),
              CustomChip(
                label: invoice.isPaid ? 'Paid' : 'Unpaid',
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

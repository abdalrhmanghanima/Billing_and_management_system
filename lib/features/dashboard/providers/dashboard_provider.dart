import 'package:billing_and_sales_management/core/translate/app_translate.dart';
import 'package:billing_and_sales_management/features/clients/providers/clients_notifier.dart';
import 'package:billing_and_sales_management/features/dashboard/models/dashboard_state.dart';
import 'package:billing_and_sales_management/features/items/providers/items_notifier.dart';
import 'package:billing_and_sales_management/features/invoices/providers/invoices_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardProvider = Provider<DashboardState>((ref) {
  final invoicesAsync = ref.watch(invoicesProvider);
  final clientsAsync = ref.watch(clientsProvider);
  final itemsAsync = ref.watch(itemsProvider);

  final isLoading =
      invoicesAsync.isLoading || clientsAsync.isLoading || itemsAsync.isLoading;

  if (isLoading) {
    return const DashboardState(isLoading: true);
  }

  final failedEntityKeys = <String>[];
  if (invoicesAsync.hasError) failedEntityKeys.add(AppTranslate.invoices);
  if (clientsAsync.hasError) failedEntityKeys.add(AppTranslate.clients);
  if (itemsAsync.hasError) failedEntityKeys.add(AppTranslate.items);

  if (failedEntityKeys.isNotEmpty) {
    return DashboardState(failedEntityKeys: failedEntityKeys);
  }

  final invoices = invoicesAsync.value ?? [];
  final clients = clientsAsync.value ?? [];
  final items = itemsAsync.value ?? [];

  final recentInvoices = invoices
      .take(5)
      .map(
        (inv) => DashboardRecentInvoice(
          billNumber: inv.billNumber,
          clientName: inv.clientName,
          billDate: inv.billDate,
          billsTotal: inv.billsTotal,
          isPaid: inv.isPaid,
          invoice: inv,
        ),
      )
      .toList();

  return DashboardState(
    invoiceCount: invoices.length,
    clientCount: clients.length,
    itemCount: items.length,
    recentInvoices: recentInvoices,
  );
});

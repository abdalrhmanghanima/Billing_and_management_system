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

  final errors = <String>[];
  if (invoicesAsync.hasError) errors.add('invoices');
  if (clientsAsync.hasError) errors.add('clients');
  if (itemsAsync.hasError) errors.add('items');

  if (errors.isNotEmpty) {
    return DashboardState(errorMessage: 'Failed to load ${errors.join(', ')}');
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

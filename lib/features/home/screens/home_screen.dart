import 'package:billing_and_sales_management/features/clients/screens/clients_screen.dart';
import 'package:billing_and_sales_management/features/dashboard/screens/dashboard_screen.dart';
import 'package:billing_and_sales_management/features/home/providers/selected_tab_provider.dart';
import 'package:billing_and_sales_management/features/invoices/screens/create_invoice_screen.dart';
import 'package:billing_and_sales_management/features/items/screens/items_screen.dart';
import 'package:billing_and_sales_management/features/more/screens/more_screen.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const List<Widget> _tabs = <Widget>[
    DashboardScreen(key: ValueKey<String>('dashboard')),
    ClientsScreen(key: ValueKey<String>('clients')),
    ItemsScreen(key: ValueKey<String>('items')),
    MoreScreen(key: ValueKey<String>('more')),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedTabProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: selectedIndex, children: _tabs),
      bottomNavigationBar: ResponsiveNavigation(
        items: const [
          ResponsiveNavigationItem(
            icon: Icons.home_outlined,
            label: 'Home',
            value: 0,
          ),
          ResponsiveNavigationItem(
            icon: Icons.people_outline,
            label: 'Clients',
            value: 1,
          ),
          ResponsiveNavigationItem(
            icon: Icons.inventory_2_outlined,
            label: 'Items',
            value: 2,
          ),
          ResponsiveNavigationItem(
            icon: Icons.more_horiz,
            label: 'More',
            value: 3,
          ),
        ],
        selectedIndex: selectedIndex,
        onSelected: (index) =>
            ref.read(selectedTabProvider.notifier).select(index),
        centerAction: ResponsiveNavigationItem(
          icon: Icons.add,
          label: 'Invoice',
          value: -1,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const CreateInvoiceScreen(),
            ),
          ),
        ),
      ),
    );
  }
}

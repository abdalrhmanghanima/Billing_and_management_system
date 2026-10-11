import 'package:billing_and_sales_management/features/dashboard/models/dashboard_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardNotifier extends Notifier<DashboardState> {
  @override
  DashboardState build() => const DashboardState();
}

final dashboardProvider = NotifierProvider<DashboardNotifier, DashboardState>(
  DashboardNotifier.new,
);

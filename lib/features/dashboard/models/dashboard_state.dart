import 'package:billing_and_sales_management/core/translate/app_translate.dart';
import 'package:billing_and_sales_management/domain/invoices/entities/sales_invoice.dart';
import 'package:easy_localization/easy_localization.dart';

class DashboardRecentInvoice {
  const DashboardRecentInvoice({
    required this.billNumber,
    required this.clientName,
    required this.billDate,
    required this.billsTotal,
    required this.isPaid,
    this.invoice,
  });

  final int billNumber;
  final String clientName;
  final String billDate;
  final double billsTotal;
  final bool isPaid;
  final SalesInvoice? invoice;

  String get formattedBillsTotal => DashboardAmountFormatter.format(billsTotal);
}

class DashboardState {
  const DashboardState({
    this.isLoading = false,
    this.failedEntityKeys,
    this.invoiceCount = 0,
    this.clientCount = 0,
    this.itemCount = 0,
    this.recentInvoices = const <DashboardRecentInvoice>[],
  });

  final bool isLoading;
  final List<String>? failedEntityKeys;
  final int invoiceCount;
  final int clientCount;
  final int itemCount;
  final List<DashboardRecentInvoice> recentInvoices;

  String? get errorMessage {
    final keys = failedEntityKeys;
    if (keys == null) return null;
    return AppTranslate.failedToLoadEntities.tr(
      namedArgs: {'entities': keys.map((key) => key.tr()).join(', ')},
    );
  }
}

class DashboardAmountFormatter {
  DashboardAmountFormatter._();

  static String format(double amount) {
    final negative = amount < 0;
    final fixed = amount.abs().toStringAsFixed(2);
    final parts = fixed.split('.');
    var decimals = parts[1];
    if (decimals.endsWith('00')) {
      decimals = '';
    } else if (decimals.endsWith('0')) {
      decimals = decimals.substring(0, 1);
    }

    final digits = parts[0];
    final grouped = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        grouped.write(',');
      }
      grouped.write(digits[i]);
    }

    final suffix = decimals.isEmpty ? '' : '.$decimals';
    final sign = negative ? '-' : '';
    return AppTranslate.amountEgp.tr(
      namedArgs: {'amount': '$sign$grouped$suffix'},
    );
  }
}

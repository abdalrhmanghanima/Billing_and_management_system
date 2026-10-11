class DashboardRecentInvoice {
  const DashboardRecentInvoice({
    required this.billNumber,
    required this.clientName,
    required this.billDate,
    required this.billsTotal,
    required this.isPaid,
  });

  final int billNumber;
  final String clientName;
  final String billDate;
  final double billsTotal;
  final bool isPaid;

  String get formattedBillsTotal => DashboardAmountFormatter.format(billsTotal);
}

class DashboardState {
  const DashboardState({
    this.invoiceCount = 0,
    this.clientCount = 0,
    this.itemCount = 0,
    this.recentInvoices = const <DashboardRecentInvoice>[],
  });

  final int invoiceCount;
  final int clientCount;
  final int itemCount;
  final List<DashboardRecentInvoice> recentInvoices;
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
    return 'EGP $sign$grouped$suffix';
  }
}

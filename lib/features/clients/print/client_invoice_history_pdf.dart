import 'dart:typed_data';

import 'package:billing_and_sales_management/domain/clients/entities/client.dart';
import 'package:billing_and_sales_management/domain/invoices/entities/sales_invoice.dart';
import 'package:billing_and_sales_management/features/dashboard/models/dashboard_state.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ClientInvoiceHistoryReportLabels {
  const ClientInvoiceHistoryReportLabels({
    required this.title,
    required this.period,
    required this.clientNumber,
    required this.clientName,
    required this.phone,
    required this.address,
    required this.invoiceNumber,
    required this.date,
    required this.netTotal,
    required this.paidAmount,
    required this.remainingAmount,
    required this.status,
    required this.paid,
    required this.unpaid,
    required this.totals,
  });

  final String title;
  final String period;
  final String clientNumber;
  final String clientName;
  final String phone;
  final String address;
  final String invoiceNumber;
  final String date;
  final String netTotal;
  final String paidAmount;
  final String remainingAmount;
  final String status;
  final String paid;
  final String unpaid;
  final String totals;
}

class ClientInvoiceHistoryPdf {
  ClientInvoiceHistoryPdf._();

  static const String _regularFontPath = 'assets/fonts/Tajawal-Regular.ttf';
  static const String _boldFontPath = 'assets/fonts/Tajawal-Bold.ttf';

  static Future<Uint8List> build({
    required Client client,
    required List<SalesInvoice> invoices,
    required bool isRtl,
    required ClientInvoiceHistoryReportLabels labels,
  }) async {
    final regularFont = pw.Font.ttf(await rootBundle.load(_regularFontPath));
    final boldFont = pw.Font.ttf(await rootBundle.load(_boldFontPath));

    var totalNet = 0.0;
    var totalPaid = 0.0;
    var totalRemaining = 0.0;

    for (final invoice in invoices) {
      totalNet += invoice.theNet;
      totalPaid += invoice.paidUp;
      totalRemaining += invoice.theRest;
    }

    final document = pw.Document();

    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: isRtl ? pw.TextDirection.rtl : pw.TextDirection.ltr,
        theme: pw.ThemeData.withFont(base: regularFont, bold: boldFont),
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Text(
            labels.title,
            style: pw.TextStyle(font: boldFont, fontSize: 18),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            labels.period,
            style: pw.TextStyle(font: regularFont, fontSize: 12),
          ),
          pw.SizedBox(height: 16),
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _infoRow(
                  labels.clientNumber,
                  '#${client.number}',
                  regularFont,
                  boldFont,
                ),
                pw.SizedBox(height: 4),
                _infoRow(labels.clientName, client.name, regularFont, boldFont),
                pw.SizedBox(height: 4),
                _infoRow(labels.phone, client.phone, regularFont, boldFont),
                pw.SizedBox(height: 4),
                _infoRow(labels.address, client.address, regularFont, boldFont),
              ],
            ),
          ),
          pw.SizedBox(height: 16),
          _invoiceTable(
            invoices: invoices,
            labels: labels,
            regularFont: regularFont,
            boldFont: boldFont,
            totalNet: totalNet,
            totalPaid: totalPaid,
            totalRemaining: totalRemaining,
          ),
        ],
      ),
    );

    return document.save();
  }

  static pw.Widget _infoRow(
    String label,
    String value,
    pw.Font regularFont,
    pw.Font boldFont,
  ) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('$label: ', style: pw.TextStyle(font: boldFont, fontSize: 10)),
        pw.Expanded(
          child: pw.Text(
            value,
            style: pw.TextStyle(font: regularFont, fontSize: 10),
          ),
        ),
      ],
    );
  }

  static pw.Widget _cell(
    String text, {
    required pw.Font font,
    double fontSize = 9,
    pw.TextAlign align = pw.TextAlign.start,
    PdfColor? color,
  }) {
    return pw.Expanded(
      child: pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 5),
        child: pw.Text(
          text,
          textAlign: align,
          style: pw.TextStyle(font: font, fontSize: fontSize, color: color),
        ),
      ),
    );
  }

  static pw.Widget _headerCell(
    String text, {
    required pw.Font font,
    pw.TextAlign align = pw.TextAlign.start,
  }) {
    return _cell(
      text,
      font: font,
      fontSize: 9,
      align: align,
      color: PdfColors.white,
    );
  }

  static pw.Widget _invoiceTable({
    required List<SalesInvoice> invoices,
    required ClientInvoiceHistoryReportLabels labels,
    required pw.Font regularFont,
    required pw.Font boldFont,
    required double totalNet,
    required double totalPaid,
    required double totalRemaining,
  }) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.teal700),
          children: [
            _headerCell(labels.invoiceNumber, font: boldFont),
            _headerCell(labels.date, font: boldFont),
            _headerCell(
              labels.netTotal,
              font: boldFont,
              align: pw.TextAlign.end,
            ),
            _headerCell(
              labels.paidAmount,
              font: boldFont,
              align: pw.TextAlign.end,
            ),
            _headerCell(
              labels.remainingAmount,
              font: boldFont,
              align: pw.TextAlign.end,
            ),
            _headerCell(
              labels.status,
              font: boldFont,
              align: pw.TextAlign.center,
            ),
          ],
        ),
        for (final invoice in invoices)
          pw.TableRow(
            children: [
              _cell('#${invoice.billNumber}', font: boldFont),
              _cell(invoice.billDate, font: regularFont),
              _cell(
                DashboardAmountFormatter.format(invoice.theNet),
                font: regularFont,
                align: pw.TextAlign.end,
              ),
              _cell(
                DashboardAmountFormatter.format(invoice.paidUp),
                font: regularFont,
                align: pw.TextAlign.end,
              ),
              _cell(
                DashboardAmountFormatter.format(invoice.theRest),
                font: regularFont,
                align: pw.TextAlign.end,
              ),
              _cell(
                invoice.isPaid ? labels.paid : labels.unpaid,
                font: regularFont,
                align: pw.TextAlign.center,
                color: invoice.isPaid
                    ? PdfColors.green800
                    : PdfColors.orange800,
              ),
            ],
          ),
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _cell(labels.totals, font: boldFont),
            _cell('', font: regularFont),
            _cell(
              DashboardAmountFormatter.format(totalNet),
              font: boldFont,
              align: pw.TextAlign.end,
            ),
            _cell(
              DashboardAmountFormatter.format(totalPaid),
              font: boldFont,
              align: pw.TextAlign.end,
            ),
            _cell(
              DashboardAmountFormatter.format(totalRemaining),
              font: boldFont,
              align: pw.TextAlign.end,
            ),
            _cell('', font: regularFont),
          ],
        ),
      ],
    );
  }
}

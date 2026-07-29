import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../models/order_model.dart';

class InvoiceService {
  static const String shopName = "ARIHANT BIKE & SCOOTY SPARE";
  static const String phone = "8178478220";
  static const String website = "www.absspares.in";
  static const String address = "Madhu Vihar, I.P. Extension, Delhi";

  Future<pw.MemoryImage?> _loadLogo() async {
    try {
      final data = await rootBundle.load(
        "assets/images/logo.png",
      );

      return pw.MemoryImage(
        data.buffer.asUint8List(),
      );
    } catch (_) {
      return null;
    }
  }

  String invoiceNumber(OrderModel order) {
    if (order.id == null || order.id!.isEmpty) {
      return "ABS-${DateTime.now().millisecondsSinceEpoch}";
    }

    final id = order.id!;

    return id.length > 6
        ? "ABS-${id.substring(0, 6).toUpperCase()}"
        : "ABS-${id.toUpperCase()}";
  }

  Future<void> generateAndShareInvoice(
    OrderModel order,
  ) async {
    final pdf = pw.Document();

    final logo = await _loadLogo();

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(20),
        ),
        build: (context) {
          return [
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.red700,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  if (logo != null)
                    pw.Container(
                      width: 55,
                      height: 55,
                      decoration: pw.BoxDecoration(
                        color: PdfColors.white,
                        borderRadius: pw.BorderRadius.circular(8),
                      ),
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Image(logo),
                    ),
                  if (logo != null) pw.SizedBox(width: 12),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          shopName,
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          address,
                          style: const pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 10,
                          ),
                        ),
                        pw.Text(
                          "Mobile : $phone",
                          style: const pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 10,
                          ),
                        ),
                        pw.Text(
                          website,
                          style: const pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(
                  color: PdfColors.grey400,
                ),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    "INVOICE",
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        "Invoice No : ${invoiceNumber(order)}",
                      ),
                      pw.Text(
                        "Date : ${order.orderDate}",
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 15),
                  pw.Text(
                    "Customer Details",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    "Name : ${order.customerName}",
                  ),
                  pw.Text(
                    "Mobile : ${order.mobile}",
                  ),
                  pw.Text(
                    "Address : ${order.address}",
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(
                color: PdfColors.grey500,
              ),
              columnWidths: {
                0: const pw.FixedColumnWidth(35),
                1: const pw.FlexColumnWidth(),
                2: const pw.FixedColumnWidth(45),
                3: const pw.FixedColumnWidth(65),
                4: const pw.FixedColumnWidth(70),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.red100,
                  ),
                  children: [
                    _cell("S.No.", true),
                    _cell("Product", true),
                    _cell("Qty", true),
                    _cell("Rate", true),
                    _cell("Total", true),
                  ],
                ),
                ...List.generate(
                  order.items.length,
                  (index) {
                    final item = order.items[index];

                    final qty = item["quantity"] ?? 0;

                    final price = (item["price"] ?? 0).toDouble();

                    final total = (item["total"] ?? 0).toDouble();

                    return pw.TableRow(
                      children: [
                        _cell("${index + 1}", false),
                        _cell(
                          item["name"] ?? "",
                          false,
                        ),
                        _cell("$qty", false),
                        _cell(
                          "₹${price.toStringAsFixed(2)}",
                          false,
                        ),
                        _cell(
                          "₹${total.toStringAsFixed(2)}",
                          false,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Container(
                width: 220,
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColors.green100,
                  borderRadius: pw.BorderRadius.circular(6),
                  border: pw.Border.all(color: PdfColors.green),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "Total Items : ${order.items.length}",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(
                      "Grand Total : ₹${order.totalAmount.toStringAsFixed(2)}",
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.green900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            pw.SizedBox(height: 30),
            pw.Divider(),
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    "Thank You For Your Purchase!",
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text("Visit Again"),
                  pw.Text(shopName),
                  pw.Text("Mobile : $phone"),
                  pw.Text(website),
                ],
              ),
            ),
          ];
        },
      ),
    );

    final directory = await getTemporaryDirectory();
    final file = File(
      "${directory.path}/Invoice_${invoiceNumber(order)}.pdf",
    );

    await file.writeAsBytes(await pdf.save());

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text: "Invoice - ${invoiceNumber(order)}",
      ),
    );
  }

  pw.Widget _cell(
    String text,
    bool heading,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          fontSize: heading ? 11 : 10,
          fontWeight: heading ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }
}

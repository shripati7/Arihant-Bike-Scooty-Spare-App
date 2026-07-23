import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../models/cart_item.dart';

class InvoiceService {
  static Future<File> generateInvoice({
    required String invoiceNo,
    required String customerName,
    required String customerMobile,
    required String customerAddress,
    required List<CartItem> items,
    required double grandTotal,
  }) async {
    final pdf = pw.Document();

    pw.MemoryImage? logo;

    try {
      final logoBytes = await rootBundle.load(
        'assets/images/logo.png',
      );

      logo = pw.MemoryImage(
        logoBytes.buffer.asUint8List(),
      );
    } catch (_) {
      logo = null;
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (context) {
          return [
            ///==========================
            /// HEADER
            ///==========================

            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (logo != null)
                  pw.Container(
                    width: 70,
                    height: 70,
                    child: pw.Image(logo),
                  ),
                if (logo != null) pw.SizedBox(width: 15),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "ARIHANT BIKE & SCOOTY SPARE",
                        style: pw.TextStyle(
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        "Madhu Vihar, Delhi",
                      ),
                      pw.Text(
                        "Phone : +91-XXXXXXXXXX",
                      ),
                      pw.Text(
                        "Email : support@absspares.in",
                      ),
                    ],
                  ),
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Text(
                        "INVOICE",
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        "Invoice No",
                      ),
                      pw.Text(invoiceNo),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        "Date",
                      ),
                      pw.Text(
                        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                      ),
                    ],
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 25),

            ///==========================
            /// CUSTOMER DETAILS
            ///==========================

            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    "Customer Details",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    "Name : $customerName",
                  ),
                  pw.Text(
                    "Mobile : $customerMobile",
                  ),
                  pw.Text(
                    "Address :",
                  ),
                  pw.Text(customerAddress),
                ],
              ),
            ),

            pw.SizedBox(height: 25),

            ///==========================
            /// PRODUCT TABLE
            ///==========================

            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {
                0: const pw.FlexColumnWidth(4),
                1: const pw.FlexColumnWidth(1),
                2: const pw.FlexColumnWidth(2),
                3: const pw.FlexColumnWidth(2),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.grey300,
                  ),
                  children: [
                    _cell("Product", true),
                    _cell("Qty", true),
                    _cell("Rate", true),
                    _cell("Amount", true),
                  ],
                ),
                ...items.map(
                  (item) => pw.TableRow(
                    children: [
                      _cell(item.name, false),
                      _cell(
                        item.quantity.toString(),
                        false,
                      ),
                      _cell(
                        "₹${item.price.toStringAsFixed(0)}",
                        false,
                      ),
                      _cell(
                        "₹${item.total.toStringAsFixed(0)}",
                        false,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 25),

            ///==========================
            /// TOTAL
            ///==========================

            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Container(
                width: 220,
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Column(
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          "Grand Total",
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        pw.Text(
                          "₹${grandTotal.toStringAsFixed(0)}",
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            pw.SizedBox(height: 40),

            pw.Divider(),

            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    "Thank You For Shopping!",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    "Visit Again",
                  ),
                  pw.Text(
                    "Arihant Bike & Scooty Spare",
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();

    final file = File(
      "${directory.path}/$invoiceNo.pdf",
    );

    await file.writeAsBytes(
      await pdf.save(),
    );

    return file;
  }

  static Future<void> printInvoice(
    File file,
  ) async {
    await Printing.layoutPdf(
      onLayout: (format) async => file.readAsBytes(),
    );
  }

  static Future<void> shareInvoice(
    File file,
  ) async {
    await Share.shareXFiles(
      [
        XFile(file.path),
      ],
      text: "Invoice",
    );
  }

  static pw.Widget _cell(
    String text,
    bool header,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          fontSize: 11,
          fontWeight: header ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }
}

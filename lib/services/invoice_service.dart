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
            //==========================
            // HEADER
            //==========================

            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (logo != null)
                  pw.Container(
                    width: 75,
                    height: 75,
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
                      pw.SizedBox(height: 6),
                      pw.Text(
                        "E-44, Street No. 15",
                        style: const pw.TextStyle(
                          fontSize: 10,
                        ),
                      ),
                      pw.Text(
                        "Madhu Vihar, I.P. Extension",
                        style: const pw.TextStyle(
                          fontSize: 10,
                        ),
                      ),
                      pw.Text(
                        "Patparganj, Delhi - 110092",
                        style: const pw.TextStyle(
                          fontSize: 10,
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        "Phone : 8178478220",
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: pw.BorderRadius.circular(6),
                    border: pw.Border.all(
                      color: PdfColors.amber700,
                      width: 1.5,
                    ),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Text(
                        "INVOICE",
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.amber800,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        "Invoice No",
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(invoiceNo),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        "Date",
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                        ),
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

            //==========================
            // CUSTOMER DETAILS
            //==========================

            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(6),
                border: pw.Border.all(
                  color: PdfColors.grey500,
                ),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    "CUSTOMER DETAILS",
                    style: pw.TextStyle(
                      fontSize: 15,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue900,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    "Name : $customerName",
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    "Mobile : $customerMobile",
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    "Address :",
                  ),
                  pw.Text(customerAddress),
                ],
              ),
            ),

            pw.SizedBox(height: 25),

            //==========================
            // PRODUCT TABLE
            //==========================

            pw.Table(
              border: pw.TableBorder.all(
                color: PdfColors.grey600,
              ),
              columnWidths: {
                0: const pw.FlexColumnWidth(4),
                1: const pw.FlexColumnWidth(1),
                2: const pw.FlexColumnWidth(2),
                3: const pw.FlexColumnWidth(2),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.amber200,
                  ),
                  children: [
                    _cell(
                      "Product",
                      true,
                    ),
                    _cell(
                      "Qty",
                      true,
                    ),
                    _cell(
                      "Rate",
                      true,
                    ),
                    _cell(
                      "Amount",
                      true,
                    ),
                  ],
                ),
                ...items.map(
                  (item) => pw.TableRow(
                    children: [
                      _cell(
                        item.name,
                        false,
                      ),
                      _cell(
                        item.quantity.toString(),
                        false,
                      ),
                      _cell(
                        "Rs. ${item.price.toStringAsFixed(2)}",
                        false,
                      ),
                      _cell(
                        "Rs. ${item.total.toStringAsFixed(2)}",
                        false,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 25),
            //==========================
            // GRAND TOTAL
            //==========================

            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Container(
                width: 230,
                padding: const pw.EdgeInsets.all(14),
                decoration: pw.BoxDecoration(
                  color: PdfColors.amber100,
                  borderRadius: pw.BorderRadius.circular(8),
                  border: pw.Border.all(
                    color: PdfColors.amber700,
                    width: 1.5,
                  ),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "Grand Total",
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      "Rs. ${grandTotal.toStringAsFixed(2)}",
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.green800,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            pw.SizedBox(height: 40),

            pw.Divider(),

            pw.SizedBox(height: 15),

            //==========================
            // FOOTER
            //==========================

            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    "Thank You For Your Business!",
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.amber800,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    "We appreciate your trust and support.",
                  ),
                  pw.Text(
                    "Visit Again",
                  ),
                  pw.SizedBox(height: 25),
                  pw.Container(
                    width: 180,
                    child: pw.Divider(),
                  ),
                  pw.Text(
                    "Authorized Signature",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    "Arihant Bike & Scooty Spare",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
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
    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile(file.path),
        ],
        text: "Invoice from Arihant Bike & Scooty Spare",
      ),
    );
  }

  static pw.Widget _cell(
    String text,
    bool header,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 6,
      ),
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

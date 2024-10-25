import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:prods/features/control_panel/models/invoice_detail_model.dart';
import 'package:prods/features/control_panel/models/invoice_model.dart';
import 'package:pdf/widgets.dart' as pw;

getFormatedDate(DateTime date) => DateFormat('h:mma  d/M/yyyy').format(date);

Future<File?> generateInvoiceFromInvoiceModels({required List<InvoiceDetailModel> ivd, required InvoiceModel invoice}) async {
  final pdf = pw.Document();

  // تحميل الخط
  final fontData = await rootBundle.load("assets/fonts/amiri/Amiri-Regular.ttf");
  final ttf = pw.Font.ttf(fontData);

  pdf.addPage(
    pw.Page(
      pageFormat: const PdfPageFormat(8.5 * PdfPageFormat.cm, 20 * PdfPageFormat.cm, marginAll: 1 * PdfPageFormat.cm),
      build: (pw.Context context) {
        return pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: <pw.Widget>[
              pw.Text("متجر عصصيدة الروزي", style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold, fontSize: 8)),
              pw.Text(getFormatedDate(invoice.createdAt.toDate()), style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold, fontSize: 8)),
              pw.SizedBox(height: 8),
              pw.Divider(),
              if (invoice.customerName.isNotEmpty)
                pw.Column(
                  children: [
                    pw.Text("العميل", style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold, fontSize: 8)),
                    pw.Text(invoice.customerName, style: pw.TextStyle(font: ttf, fontSize: 8)),
                    pw.SizedBox(height: 8),
                    pw.Divider(),
                  ],
                ),

              pw.ListView.separated(
                itemBuilder: (context, index) => pw.Row(
                  children: [
                    pw.Text(ivd[index].productName ?? "", style: pw.TextStyle(font: ttf, fontSize: 8)),
                    Spacer(),
                    pw.Text("${ivd[index].priceAfterDiscount *ivd[index].quantity}" , style: pw.TextStyle(font: ttf, fontSize: 8)),
                    Spacer(),
                    pw.Text(ivd[index].quantity.toString(), style: pw.TextStyle(font: ttf, fontSize: 8)),
                    pw.Spacer(),
                    pw.Text("${ivd[index].priceAfterDiscount}", style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold, fontSize: 8)),
                  ],
                ),
                separatorBuilder: (context, index) => pw.Divider(),
                itemCount: ivd.length,
              ),
              pw.SizedBox(height: 8),
              pw.Text("المجموع ", style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold, fontSize: 8)),
              pw.Text("${invoice.totalPrice}", style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold, fontSize: 8)),
              pw.Stack(
                children: [
                  pw.Text("خصم ${invoice.discount}", style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold, fontSize: 8)),
                  pw.Positioned(
                    top: 7, // ضبط الموضع العمودي للخط
                    child: pw.Container(
                      width: 80, // ضبط عرض الخط
                      height: 1, // ضبط سماكة الخط
                      color: PdfColors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );

  try {
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/invoice.pdf");
    await file.writeAsBytes(await pdf.save());

    // فتح ملف الـ PDF بعد إنشائه
    await OpenFile.open(file.path);

    return file;
  } catch (e) {
    print("Error generating PDF: $e");
    return null;
  }

}

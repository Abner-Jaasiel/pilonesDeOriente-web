import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReceiptPrinter {
  static Future<void> printReceipt(Map<String, dynamic> datos) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll57,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                'Pilones De Oriente',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text('Ciudad: ${datos['ciudad']}',
                  style: pw.TextStyle(fontSize: 10)),
              pw.Text('Teléfono: ${datos['telefono']}',
                  style: pw.TextStyle(fontSize: 10)),
              pw.Divider(thickness: 1),
              pw.SizedBox(height: 5),
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text('Factura a nombre de:',
                    style: pw.TextStyle(
                        fontSize: 10, fontWeight: pw.FontWeight.bold)),
              ),
              pw.Text('${datos['nombre']}', style: pw.TextStyle(fontSize: 12)),
              pw.SizedBox(height: 5),
              pw.Divider(thickness: 1),
              pw.SizedBox(height: 5),
              pw.Text('Total Facturado:',
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold)),
              pw.Text('\$${datos['precioTotal']}',
                  style: pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 10),
              pw.Text('Gracias por su compra',
                  style: pw.TextStyle(
                      fontSize: 10, fontStyle: pw.FontStyle.italic)),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class ReceiptPrinter {
  static String _formatCurrency(double value) {
    final formatter = NumberFormat("#,##0.00", "en_US");
    return formatter.format(value);
  }

  static Future<void> printReceipt(Map<String, dynamic> datos) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();

    try {
      // Cargar imagen desde assets
      final ByteData logoData = await rootBundle.load('assets/images/icon.png');
      final Uint8List logoBytes = logoData.buffer.asUint8List();
      final pw.ImageProvider logo = pw.MemoryImage(logoBytes);

      // Verificar que los datos necesarios no sean nulos
      final precioVenta = datos['precioVenta'] ?? 0.0;
      final precioGerminacion = datos['precioGerminacion'] ?? 0.0;
      final precioManual = datos['precioManual'] ?? 0.0;
      final deuda = datos['deuda'] ?? 0.0;
      final precioTotal = datos['precioTotal'] ?? 0.0;

      final pageFormat =
          PdfPageFormat(58 * PdfPageFormat.mm, PdfPageFormat.a4.height);
      pdf.addPage(
        pw.Page(
          pageFormat: pageFormat,
          margin: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                // Logo
                pw.Image(logo, height: 40),
                pw.SizedBox(height: 5),

                // Encabezado
                pw.Text('Pilones De Oriente',
                    style: pw.TextStyle(font: fontBold, fontSize: 12)),
                pw.Text(datos['ciudad'] ?? 'Ciudad no disponible',
                    style: pw.TextStyle(font: font, fontSize: 8)),
                pw.Text('Tel: ${datos['telefono'] ?? 'N/A'}',
                    style: pw.TextStyle(font: font, fontSize: 8)),
                pw.Text('Vendedor: ${datos['vendedor'] ?? 'N/A'}',
                    style: pw.TextStyle(font: font, fontSize: 8)),
                pw.Divider(thickness: 1),

                // Datos del cliente
                pw.Row(
                  children: [
                    pw.Text('Factura a:',
                        style: pw.TextStyle(font: fontBold, fontSize: 9)),
                    pw.SizedBox(width: 5),
                    pw.Expanded(
                      child: pw.Text(datos['nombre'] ?? 'Nombre no disponible',
                          style: pw.TextStyle(font: font, fontSize: 9)),
                    ),
                  ],
                ),
                pw.SizedBox(height: 5),

                // Detalles de la transacción
                pw.Text('Fecha: ${datos['fecha'] ?? 'N/A'}',
                    style: pw.TextStyle(font: font, fontSize: 8)),
                pw.Divider(thickness: 1),

                pw.Text(
                    "Cantidad de ${datos['cantidad'] == 1 ? 'semilla' : 'semillas'}: ${NumberFormat("#,##0").format(int.tryParse(datos['cantidad'].toString()) ?? 0)}",
                    style: pw.TextStyle(font: font, fontSize: 8)),
                pw.Text('Tipo: ${datos["cultivo"]} ${datos['tipo'] ?? 'N/A'}',
                    style: pw.TextStyle(font: font, fontSize: 8)),

                // Detalles del pago
                pw.Text('Método de pago: ${datos['metodoPago'] ?? 'N/A'}',
                    style: pw.TextStyle(font: font, fontSize: 8)),
                if (datos['metodoPago'] == 'Banco')
                  pw.Text('Banco: ${datos['banco'] ?? 'N/A'}',
                      style: pw.TextStyle(font: font, fontSize: 8)),
                pw.Divider(thickness: 1),

                // Totales
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Precio de Venta:',
                        style: pw.TextStyle(font: fontBold, fontSize: 10)),
                    pw.Text('L. ${_formatCurrency(precioVenta)}',
                        style: pw.TextStyle(font: font, fontSize: 10)),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Precio Germinación:',
                        style: pw.TextStyle(font: fontBold, fontSize: 10)),
                    pw.Text('L. ${_formatCurrency(precioGerminacion)}',
                        style: pw.TextStyle(font: font, fontSize: 10)),
                  ],
                ),
                if (precioManual > 0)
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Precio Manual:',
                          style: pw.TextStyle(font: fontBold, fontSize: 10)),
                      pw.Text('L. ${_formatCurrency(precioManual)}',
                          style: pw.TextStyle(font: font, fontSize: 10)),
                    ],
                  ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Monto Recibido:',
                        style: pw.TextStyle(font: fontBold, fontSize: 10)),
                    pw.Text(
                        'L. ${_formatCurrency(datos['montoRecibido'] ?? 0.0)}',
                        style: pw.TextStyle(font: font, fontSize: 10)),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Deuda:',
                        style: pw.TextStyle(font: fontBold, fontSize: 10)),
                    pw.Text('L. ${_formatCurrency(deuda)}',
                        style: pw.TextStyle(
                            font: font,
                            fontSize: 10,
                            color:
                                deuda > 0 ? PdfColors.red : PdfColors.green)),
                  ],
                ),
                pw.Divider(thickness: 1),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('TOTAL:',
                        style: pw.TextStyle(font: fontBold, fontSize: 12)),
                    pw.Text('L. ${_formatCurrency(precioTotal)}',
                        style: pw.TextStyle(font: fontBold, fontSize: 12)),
                  ],
                ),
                pw.SizedBox(height: 10),

                // Pie de página
                pw.Text('Gracias por su compra!',
                    style: pw.TextStyle(fontSize: 10)),
                pw.Text('Sistema de facturación electrónica',
                    style: pw.TextStyle(font: font, fontSize: 6)),
                pw.Text('Conserve su recibo como garantía',
                    style: pw.TextStyle(font: font, fontSize: 8)),
              ],
            );
          },
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      print('Error al generar el recibo: $e');
    }
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pdf/pdf.dart';
import 'package:pilones_de_oriente/service/firebase_service.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> reports = [];
  Map<String, List<Map<String, dynamic>>> groupedReports = {};
  String _groupingType = 'day';
  String _filterType = 'all';
  final List<String> _groupingOptions = ['Día', 'Mes', 'Año'];
  final List<String> _filterOptions = ['Todos', 'Entregados', 'Pendientes'];

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  void _loadReports() {
    _dbRef.child('forms').onValue.listen((event) {
      var data = event.snapshot.value as Map?;
      if (data != null) {
        List<Map<String, dynamic>> loadedReports = [];
        data.forEach((key, value) {
          loadedReports.add({
            'nombre': value['nombre']?.toString() ?? 'No disponible',
            'ventasDiarias':
                int.tryParse(value['ventasDiarias']?.toString() ?? '') ?? 0,
            'cantidadCultivos':
                int.tryParse(value['cantidad']?.toString() ?? '') ?? 0,
            'variedadCultivos': value['cultivo']?.toString() ?? 'No disponible',
            'fecha': value['fecha']?.toString() ?? 'No disponible',
            'tipoGerminacionVenta':
                value['tipoGerminacionVenta']?.toString() ?? 'No disponible',
            'fechaEntrega': value['fechaEntrega']?.toString() ?? '',
            'fechaSiembra':
                value['fechaSiembra']?.toString() ?? 'No disponible',
            'semillaSobrante':
                value['semillaSobrante']?.toString() ?? 'No definida',
            'dividirPrecio': value['dividirPrecio'] as bool? ?? false,
            'banco': value['banco']?.toString(),
            'esCredito': value['esCredito'] as bool? ?? false,
          });
        });
        _groupReports(loadedReports);
      }
    });
  }

  void _groupReports(List<Map<String, dynamic>> reports) {
    final Map<String, List<Map<String, dynamic>>> tempGrouped = {};
    for (var report in reports) {
      final groupKey = _getGroupKey(report['fecha']);
      if (!tempGrouped.containsKey(groupKey)) {
        tempGrouped[groupKey] = [];
      }
      tempGrouped[groupKey]!.add(report);
    }

    setState(() {
      this.reports = reports;
      groupedReports = _filterGroupedReports(tempGrouped);
    });
  }

  Map<String, List<Map<String, dynamic>>> _filterGroupedReports(
      Map<String, List<Map<String, dynamic>>> allReports) {
    if (_filterType == 'all') return allReports;

    final Map<String, List<Map<String, dynamic>>> filtered = {};
    allReports.forEach((key, value) {
      final filteredList = value
          .where((report) => _filterType == 'delivered'
              ? report['fechaEntrega'].isNotEmpty
              : report['fechaEntrega'].isEmpty)
          .toList();
      if (filteredList.isNotEmpty) {
        filtered[key] = filteredList;
      }
    });
    return filtered;
  }

  String _getGroupKey(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      switch (_groupingType) {
        case 'month':
          return DateFormat('MM/yyyy').format(date);
        case 'year':
          return DateFormat('yyyy').format(date);
        case 'day':
        default:
          return DateFormat('dd/MM/yyyy').format(date);
      }
    } catch (e) {
      return dateString;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _getGroupTitle(String groupKey) {
    switch (_groupingType) {
      case 'month':
        return 'Mes: $groupKey';
      case 'year':
        return 'Año: $groupKey';
      case 'day':
      default:
        return 'Día: $groupKey';
    }
  }

  Future<void> _printReport(List<Map<String, dynamic>> reports) async {
    final pdf = pw.Document();
    final totalCultivos = reports.fold(
        0, (sum, report) => sum + (report['cantidadCultivos'] as int));

    Map<String, int> cropTotals = {};
    for (var report in reports) {
      String cropType = report['variedadCultivos'];
      int quantity = report['cantidadCultivos'];
      cropTotals[cropType] = (cropTotals[cropType] ?? 0) + quantity;
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) => [
          pw.Header(
            level: 0,
            child: pw.Text(_getGroupTitle(_getGroupKey(reports.first['fecha'])),
                style:
                    pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 10),
          pw.Table.fromTextArray(
            headerStyle:
                pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            cellStyle: const pw.TextStyle(fontSize: 8),
            cellPadding: const pw.EdgeInsets.all(5),
            headers: [
              'Cliente',
              'Cultivo',
              'Tipo',
              'Cantidad',
              'Semilla Sobrante',
              'Fecha',
              'Fecha Entrega',
              '50% Precio',
              'Banco',
              'Crédito',
            ],
            data: reports
                .map((report) => [
                      report['nombre'],
                      report['variedadCultivos'],
                      report['tipoGerminacionVenta'],
                      report['cantidadCultivos'].toString(),
                      report['semillaSobrante'],
                      _formatDate(report['fecha']),
                      report['fechaEntrega'].isEmpty
                          ? 'Pendiente'
                          : _formatDate(report['fechaEntrega']),
                      report['dividirPrecio'] ? 'Sí' : 'No',
                      report['banco'] ?? 'N/A',
                      report['esCredito'] ? 'Sí' : 'No',
                    ])
                .toList(),
            columnWidths: {
              0: const pw.FlexColumnWidth(2),
              1: const pw.FlexColumnWidth(2),
              2: const pw.FlexColumnWidth(1.5),
              3: const pw.FlexColumnWidth(1),
              4: const pw.FlexColumnWidth(1.5),
              5: const pw.FlexColumnWidth(2),
              6: const pw.FlexColumnWidth(2),
              7: const pw.FlexColumnWidth(1),
              8: const pw.FlexColumnWidth(2),
              9: const pw.FlexColumnWidth(1),
            },
            cellAlignment: pw.Alignment.centerLeft,
          ),
          pw.SizedBox(height: 20),
          pw.Text('Total Cultivos: $totalCultivos',
              style:
                  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Text('Total por tipo de cultivo:',
              style:
                  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          ...cropTotals.entries.map((entry) => pw.Padding(
                padding: const pw.EdgeInsets.only(left: 10, top: 5),
                child: pw.Text('${entry.key}: ${entry.value}',
                    style: const pw.TextStyle(fontSize: 10)),
              )),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  Widget _buildSummaryRow(
      List<Map<String, dynamic>> reports, double screenWidth) {
    final totalCultivos = reports.fold(
        0, (sum, report) => sum + (report['cantidadCultivos'] as int));
    final totalVentas =
        reports.where((r) => r['tipoGerminacionVenta'] == 'Venta').length;
    final totalGerminaciones =
        reports.where((r) => r['tipoGerminacionVenta'] == 'Germinacion').length;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildSummaryChip(
            'Total Cultivos: $totalCultivos', Colors.green, screenWidth),
        _buildSummaryChip('Ventas: $totalVentas', Colors.blue, screenWidth),
        _buildSummaryChip(
            'Germinaciones: $totalGerminaciones', Colors.orange, screenWidth),
      ],
    );
  }

  Widget _buildCropTotals(List<Map<String, dynamic>> reports, double fontSize) {
    Map<String, int> cropTotals = {};
    for (var report in reports) {
      String cropType = report['variedadCultivos'];
      int quantity = report['cantidadCultivos'];
      cropTotals[cropType] = (cropTotals[cropType] ?? 0) + quantity;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Total por tipo de cultivo:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)),
        ...cropTotals.entries.map((entry) => Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 4.0),
              child: Text('${entry.key}: ${entry.value}',
                  style: TextStyle(fontSize: fontSize - 2)),
            )),
      ],
    );
  }

  Widget _buildSummaryChip(String text, Color color, double screenWidth) {
    return Chip(
      label: Text(text,
          style: TextStyle(
              color: Colors.white, fontSize: screenWidth < 600 ? 12 : 14)),
      backgroundColor: color,
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth < 600 ? 8 : 12,
          vertical: screenWidth < 600 ? 4 : 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Reportes de Ventas',
            style: TextStyle(fontSize: isSmallScreen ? 18 : 22)),
        actions: [
          DropdownButton<String>(
            value: _groupingOptions[_groupingType == 'day'
                ? 0
                : _groupingType == 'month'
                    ? 1
                    : 2],
            items: _groupingOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value,
                    style: TextStyle(fontSize: isSmallScreen ? 14 : 16)),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                if (newValue == 'Mes') {
                  _groupingType = 'month';
                } else if (newValue == 'Año') {
                  _groupingType = 'year';
                } else {
                  _groupingType = 'day';
                }
                _groupReports(reports);
              });
            },
            dropdownColor: Colors.white,
            icon: Icon(Icons.calendar_today,
                color: Colors.white, size: isSmallScreen ? 24 : 28),
          ),
          SizedBox(width: 8),
          DropdownButton<String>(
            value: _filterOptions[_filterType == 'all'
                ? 0
                : _filterType == 'delivered'
                    ? 1
                    : 2],
            items: _filterOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value,
                    style: TextStyle(fontSize: isSmallScreen ? 14 : 16)),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                if (newValue == 'Entregados') {
                  _filterType = 'delivered';
                } else if (newValue == 'Pendientes') {
                  _filterType = 'pending';
                } else {
                  _filterType = 'all';
                }
                _groupReports(reports);
              });
            },
            dropdownColor: Colors.white,
            icon: Icon(Icons.filter_alt,
                color: Colors.white, size: isSmallScreen ? 24 : 28),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: FutureBuilder(
        future: FirebaseService().getCurrentUserRole(),
        builder: (context, snapshot) {
          final String role = dotenv.env['ROLE_REPORTS'] ?? 'reports';
          if (snapshot.data == role || snapshot.data == 'admin') {
            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(isSmallScreen ? 8.0 : 16.0),
                    child: Column(
                      children:
                          groupedReports.entries.toList().reversed.map((entry) {
                        final groupKey = entry.key;
                        final groupReports = entry.value;

                        return Card(
                          margin: EdgeInsets.symmetric(
                              vertical: isSmallScreen ? 5 : 10),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ExpansionTile(
                            title: Text(_getGroupTitle(groupKey)),
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                    maxWidth: constraints.maxWidth),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    columnSpacing: isSmallScreen ? 10 : 20,
                                    dataRowMaxHeight: isSmallScreen ? 50 : 60,
                                    headingRowHeight: isSmallScreen ? 40 : 50,
                                    columns: [
                                      DataColumn(
                                          label: Text('ID',
                                              style: TextStyle(
                                                  fontSize: isSmallScreen
                                                      ? 14
                                                      : 18))),
                                      DataColumn(
                                          label: Text('Cliente',
                                              style: TextStyle(
                                                  fontSize: isSmallScreen
                                                      ? 14
                                                      : 18))),
                                      DataColumn(
                                          label: Text('Cultivo',
                                              style: TextStyle(
                                                  fontSize: isSmallScreen
                                                      ? 14
                                                      : 18))),
                                      DataColumn(
                                          label: Text('Tipo',
                                              style: TextStyle(
                                                  fontSize: isSmallScreen
                                                      ? 14
                                                      : 18))),
                                      DataColumn(
                                          label: Text('Cantidad',
                                              style: TextStyle(
                                                  fontSize: isSmallScreen
                                                      ? 14
                                                      : 18))),
                                      DataColumn(
                                          label: Text('Semilla Sobrante',
                                              style: TextStyle(
                                                  fontSize: isSmallScreen
                                                      ? 14
                                                      : 18))),
                                      DataColumn(
                                          label: Text('Fecha',
                                              style: TextStyle(
                                                  fontSize: isSmallScreen
                                                      ? 14
                                                      : 18))),
                                      DataColumn(
                                          label: Text('Fecha Entrega',
                                              style: TextStyle(
                                                  fontSize: isSmallScreen
                                                      ? 14
                                                      : 18))),
                                      DataColumn(
                                          label: Text('50% Precio',
                                              style: TextStyle(
                                                  fontSize: isSmallScreen
                                                      ? 14
                                                      : 18))),
                                      DataColumn(
                                          label: Text('Banco',
                                              style: TextStyle(
                                                  fontSize: isSmallScreen
                                                      ? 14
                                                      : 18))),
                                      DataColumn(
                                          label: Text('Crédito',
                                              style: TextStyle(
                                                  fontSize: isSmallScreen
                                                      ? 14
                                                      : 18))),
                                    ],
                                    rows: groupReports
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      final index = entry.key;
                                      final report = entry.value;

                                      return DataRow(
                                        color: WidgetStateProperty.resolveWith<
                                            Color?>((Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.selected)) {
                                            return Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(0.08);
                                          }
                                          return index.isEven
                                              ? Colors.grey[100]
                                              : null;
                                        }),
                                        cells: [
                                          DataCell(Text(index.toString(),
                                              style: TextStyle(
                                                  fontSize: isSmallScreen
                                                      ? 12
                                                      : 16))),
                                          DataCell(Text(report['nombre'],
                                              style: TextStyle(
                                                  fontSize: isSmallScreen
                                                      ? 12
                                                      : 16))),
                                          DataCell(Text(
                                              report['variedadCultivos'],
                                              style: TextStyle(
                                                  fontSize: isSmallScreen
                                                      ? 12
                                                      : 16))),
                                          DataCell(Text(
                                              report['tipoGerminacionVenta'],
                                              style: TextStyle(
                                                  fontSize: isSmallScreen
                                                      ? 12
                                                      : 16))),
                                          DataCell(Text(
                                              report['cantidadCultivos']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: isSmallScreen
                                                      ? 12
                                                      : 16))),
                                          DataCell(Text(
                                              report['semillaSobrante'],
                                              style: TextStyle(
                                                  fontSize: isSmallScreen
                                                      ? 12
                                                      : 16))),
                                          DataCell(Text(
                                              _formatDate(report['fecha']),
                                              style: TextStyle(
                                                  fontSize: isSmallScreen
                                                      ? 12
                                                      : 16))),
                                          DataCell(Text(
                                              report['fechaEntrega'].isEmpty
                                                  ? 'Pendiente'
                                                  : _formatDate(
                                                      report['fechaEntrega']),
                                              style: TextStyle(
                                                  fontSize: isSmallScreen
                                                      ? 12
                                                      : 16))),
                                          DataCell(Text(
                                              report['dividirPrecio']
                                                  ? 'Sí'
                                                  : 'No',
                                              style: TextStyle(
                                                  fontSize: isSmallScreen
                                                      ? 12
                                                      : 16))),
                                          DataCell(Text(
                                              report['banco'] ?? 'N/A',
                                              style: TextStyle(
                                                  fontSize: isSmallScreen
                                                      ? 12
                                                      : 16))),
                                          DataCell(Text(
                                              report['esCredito'] ? 'Sí' : 'No',
                                              style: TextStyle(
                                                  fontSize: isSmallScreen
                                                      ? 12
                                                      : 16))),
                                        ],
                                      );
                                    }).toList(),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.grey[50],
                                    ),
                                    headingRowColor: WidgetStateProperty.all(
                                        Colors.blue[50]),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.all(isSmallScreen ? 8.0 : 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: isSmallScreen ? 8 : 16),
                                    _buildSummaryRow(groupReports, screenWidth),
                                    SizedBox(height: isSmallScreen ? 8 : 16),
                                    _buildCropTotals(
                                        groupReports, isSmallScreen ? 14 : 16),
                                    SizedBox(height: isSmallScreen ? 8 : 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.print,
                                              size: isSmallScreen ? 24 : 28),
                                          onPressed: () =>
                                              _printReport(groupReports),
                                          color: Colors.blue,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}

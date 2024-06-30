import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // Ensure you have this for date formatting
import 'package:ezamjena_desktop/model/trade.dart';
import 'package:ezamjena_desktop/providers/exchange_provider.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class RequestHistoryPage extends StatefulWidget {
  static const routeName = '/exchangeHistory';
  const RequestHistoryPage({super.key});

  @override
  _RequestHistoryPageState createState() => _RequestHistoryPageState();
}

class _RequestHistoryPageState extends State<RequestHistoryPage> {
  List<Trade> trades = [];
  DateTime? dateFrom;
  DateTime? dateTo;
  ExchangeProvider? _exchangeProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _exchangeProvider = Provider.of<ExchangeProvider>(context, listen: false);
      _loadTrades();
    });
  }

  Future<void> _loadTrades() async {
    try {
      Map<String, dynamic> searchQuery = {};
      if (dateFrom != null) {
        searchQuery['DatumOd'] =
            DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateFrom!) + 'Z';
      }
      if (dateTo != null) {
        searchQuery['DatumDo'] =
            DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTo!) + 'Z';
      }

      print("Search query: $searchQuery");

      var loadedTrades = await _exchangeProvider?.get(searchQuery);
      print("Loaded Trades: $loadedTrades");

      if (loadedTrades != null) {
        setState(() {
          trades = loadedTrades;
        });
      }
    } catch (e) {
      print("Failed to load trades: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Od:'),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _selectDate(context, true),
                    child: Text(dateFrom != null
                        ? DateFormat('yyyy-MM-dd').format(dateFrom!)
                        : 'Izaberite datum'),
                  ),
                  SizedBox(width: 20),
                  Text('Do:'),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _selectDate(context, false),
                    child: Text(dateTo != null
                        ? DateFormat('yyyy-MM-dd').format(dateTo!)
                        : 'Izaberite datum'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection:
                    Axis.vertical, // Ensures only vertical scrolling
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(label: Text('Korisnik')),
                    DataColumn(label: Text('Proizvod1')),
                    DataColumn(label: Text('Korisnik2')),
                    DataColumn(label: Text('Proizvod2')),
                    DataColumn(label: Text('Datum razmjene')),
                  ],
                  rows: trades
                      .map<DataRow>((Trade trade) => DataRow(cells: [
                            DataCell(Text(trade.korisnik1 ?? 'Unknown')),
                            DataCell(
                                Text(trade.proizvod1Naziv ?? 'No product')),
                            DataCell(Text(trade.korisnik2 ?? 'Unknown')),
                            DataCell(
                                Text(trade.proizvod2Naziv ?? 'No product')),
                            DataCell(Text(trade.datum != null
                                ? DateFormat('yyyy-MM-dd').format(trade.datum!)
                                : 'No date')),
                          ]))
                      .toList(),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 90.0),
              child: ElevatedButton(
                onPressed: generateReport,
                child: Text('Kreiraj izvještaj'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (isStartDate ? dateFrom : dateTo) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != (isStartDate ? dateFrom : dateTo)) {
      setState(() {
        if (isStartDate) {
          dateFrom = picked;
        } else {
          dateTo = picked;
        }
        _loadTrades(); // Reload trades with the new date filter
      });
    }
  }

  Future<void> generateReport() async {
    final pdf = pw.Document();

    // Load the font
    final fontData =
        await rootBundle.load('assets/fonts/NotoSans_Condensed-Regular.ttf');
    final byteData = fontData.buffer
        .asByteData(); // This converts the buffer directly to ByteData

    final ttf = pw.Font.ttf(byteData);

    // Prepare the title
    String title = 'Request History Report';
    if (dateFrom != null && dateTo != null) {
      title +=
          ' from ${DateFormat('yyyy-MM-dd').format(dateFrom!)} to ${DateFormat('yyyy-MM-dd').format(dateTo!)}';
    } else if (dateFrom != null) {
      title += ' from ${DateFormat('yyyy-MM-dd').format(dateFrom!)}';
    } else if (dateTo != null) {
      title += ' until ${DateFormat('yyyy-MM-dd').format(dateTo!)}';
    }

    // Add a page to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          children: [
            pw.Text(title, style: pw.TextStyle(font: ttf, fontSize: 24)),
            pw.Divider(),
            pw.ListView.builder(
              itemCount: trades.length,
              itemBuilder: (context, index) {
                final trade = trades[index];
                return pw.Column(
                  children: [
                    pw.Text("User 1: ${trade.korisnik1Id ?? 'Unknown'}",
                        style: pw.TextStyle(font: ttf)),
                    pw.Text(
                        "Product 1: ${trade.proizvod1Naziv ?? 'No product'}",
                        style: pw.TextStyle(font: ttf)),
                    pw.Text("User 2: ${trade.korisnik2Id ?? 'Unknown'}",
                        style: pw.TextStyle(font: ttf)),
                    pw.Text(
                        "Product 2: ${trade.proizvod2Naziv ?? 'No product'}",
                        style: pw.TextStyle(font: ttf)),
                    pw.Text(
                        "Date: ${trade.datum != null ? DateFormat('yyyy-MM-dd').format(trade.datum!) : 'No date'}",
                        style: pw.TextStyle(font: ttf)),
                    pw.Divider(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );

    // Save and share the document
    await Printing.sharePdf(
        bytes: await pdf.save(), filename: 'request_history_report.pdf');
  }
}

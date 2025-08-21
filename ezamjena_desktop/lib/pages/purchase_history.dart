import 'package:ezamjena_desktop/model/buy.dart';
import 'package:ezamjena_desktop/providers/buy_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // Ensure you have this for date formatting
import 'package:ezamjena_desktop/model/trade.dart';
import 'package:ezamjena_desktop/providers/exchange_provider.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PurchaseHistoryPage extends StatefulWidget {
  static const routeName = '/purchaseHistory';
  const PurchaseHistoryPage({super.key});

  @override
  _PurchaseHistoryPageState createState() => _PurchaseHistoryPageState();
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  List<Buy> purchases = [];
  DateTime? dateFrom;
  DateTime? dateTo;
  BuyProvider? _buyProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _buyProvider = Provider.of<BuyProvider>(context, listen: false);
      _loadPurchases();
    });
  }

  Future<void> _loadPurchases() async {
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

      var loadedPurchases = await _buyProvider?.get(searchQuery);
      print("Loaded Purchases: $loadedPurchases");

      if (loadedPurchases != null) {
        setState(() {
          purchases = loadedPurchases;
        });
      }
    } catch (e) {
      print("Failed to load purchases: $e");
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
                  const Text('Od:'),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _selectDate(context, true),
                    child: Text(
                      dateFrom != null
                          ? DateFormat('yyyy-MM-dd').format(dateFrom!)
                          : 'Izaberite datum',
                    ),
                  ),
                  if (dateFrom != null) ...[
                    const SizedBox(width: 6),
                    Tooltip(
                      message: 'Ukloni „Od”',
                      child: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearFrom,
                        splashRadius: 18,
                      ),
                    ),
                  ],
                  const SizedBox(width: 20),
                  const Text('Do:'),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _selectDate(context, false),
                    child: Text(
                      dateTo != null
                          ? DateFormat('yyyy-MM-dd').format(dateTo!)
                          : 'Izaberite datum',
                    ),
                  ),
                  if (dateTo != null) ...[
                    const SizedBox(width: 6),
                    Tooltip(
                      message: 'Ukloni „Do”',
                      child: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearTo,
                        splashRadius: 18,
                      ),
                    ),
                  ],
                  if (dateFrom != null || dateTo != null) ...[
                    const SizedBox(width: 16),
                    TextButton.icon(
                      icon: const Icon(Icons.filter_alt_off),
                      label: const Text('Prikaži sve'),
                      onPressed: _clearAll,
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: purchases.isEmpty
                  ? Center(child: Text('Trenutno nemate kupovina u historiji'))
                  : SingleChildScrollView(
                      scrollDirection:
                          Axis.vertical, // Ensures only vertical scrolling
                      child: DataTable(
                        columns: const <DataColumn>[
                          DataColumn(label: Text('Korisnik')),
                          DataColumn(label: Text('Proizvod')),
                          DataColumn(label: Text('Cijena')),
                          DataColumn(label: Text('Datum kupovine')),
                        ],
                        rows: purchases
                            .map<DataRow>((Buy buy) => DataRow(cells: [
                                  DataCell(
                                      Text(buy.nazivKorisnika ?? 'Unknown')),
                                  DataCell(
                                      Text(buy.nazivProizvoda ?? 'No product')),
                                  DataCell(Text(
                                      buy.cijena?.toString() ?? 'No price')),
                                  DataCell(Text(buy.datum != null
                                      ? DateFormat('yyyy-MM-dd')
                                          .format(buy.datum!)
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
        _loadPurchases(); // Reload trades with the new date filter
      });
    }
  }

  void _clearFrom() {
    setState(() => dateFrom = null);
    _loadPurchases();
  }

  void _clearTo() {
    setState(() => dateTo = null);
    _loadPurchases();
  }

  void _clearAll() {
    setState(() {
      dateFrom = null;
      dateTo = null;
    });
    _loadPurchases();
  }

  Future<void> generateReport() async {
    final fontData =
        await rootBundle.load('assets/fonts/NotoSans_Condensed-Regular.ttf');
    final byteData = ByteData.sublistView(fontData.buffer.asUint8List());
    final ttf = pw.Font.ttf(byteData);

    final pdf = pw.Document();
    String title = 'Purchase Report';
    if (dateFrom != null && dateTo != null) {
      title +=
          ' from ${DateFormat('yyyy-MM-dd').format(dateFrom!)} to ${DateFormat('yyyy-MM-dd').format(dateTo!)}';
    } else if (dateFrom != null) {
      title += ' from ${DateFormat('yyyy-MM-dd').format(dateFrom!)}';
    } else if (dateTo != null) {
      title += ' until ${DateFormat('yyyy-MM-dd').format(dateTo!)}';
    }

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          children: [
            pw.Text(title, style: pw.TextStyle(fontSize: 24)),
            pw.Divider(),
            pw.ListView.builder(
              itemCount: purchases.length,
              itemBuilder: (context, index) {
                final purchase = purchases[index];
                return pw.Column(
                  children: [
                    pw.Text("User: ${purchase.nazivKorisnika ?? 'Unknown'}",
                        style: pw.TextStyle(font: ttf)),
                    pw.Text(
                        "Product: ${purchase.nazivProizvoda ?? 'No product'}",
                        style: pw.TextStyle(font: ttf)),
                    pw.Text(
                        "Price: ${purchase.cijena?.toString() ?? 'No price'}",
                        style: pw.TextStyle(font: ttf)),
                    pw.Text(
                        "Date: ${DateFormat('yyyy-MM-dd').format(purchase.datum!)}",
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
        bytes: await pdf.save(), filename: 'purchase_report.pdf');
  }

  Future<pw.Document> generatePdf() async {
    final fontData =
        await rootBundle.load('assets/fonts/NotoSans_Condensed-Regular.ttf');
    final ttf = pw.Font.ttf(fontData.buffer.asUint8List() as ByteData);

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Center(
            child: pw.Text('Hello, world!',
                style: pw.TextStyle(font: ttf, fontSize: 40)),
          );
        },
      ),
    );

    return pdf;
  }
}

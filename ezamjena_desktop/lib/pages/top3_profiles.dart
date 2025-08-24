import 'package:ezamjena_desktop/providers/city_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ezamjena_desktop/model/user.dart';
import 'package:ezamjena_desktop/providers/user_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:ezamjena_desktop/main.dart';

class TopThreeProfilesPage extends StatefulWidget {
  static const String routeName = '/top3Profiles';
  const TopThreeProfilesPage({Key? key}) : super(key: key);

  @override
  _TopThreeProfilesPageState createState() => _TopThreeProfilesPageState();
}

class _TopThreeProfilesPageState extends State<TopThreeProfilesPage>
    with RouteAware {
  List<User> topUsers = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTopUsers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _loadTopUsers();
  }

  Future<void> _loadTopUsers() async {
    setState(() => isLoading = true);

    try {
      final userProv = context.read<UserProvider>();
      final cityProv = context.read<CityProvider>();

      final gradovi = await cityProv.get();
      final gradNazivMap = {for (var g in gradovi) g.id: g.naziv};

      final sviKorisnici = await userProv.get();

      for (var k in sviKorisnici) {
        k.nazivGrada ??= gradNazivMap[k.gradId] ?? 'N/A';
      }

      final sortirani = sviKorisnici
          .where((k) => k.brojKupovina != null && k.brojRazmjena != null)
          .toList()
        ..sort((a, b) => (b.brojKupovina! + b.brojRazmjena!)
            .compareTo(a.brojKupovina! + a.brojRazmjena!));

      setState(() => topUsers = sortirani.take(3).toList());
    } catch (e) {
      debugPrint('Greška pri učitavanju top korisnika: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> generateReport() async {
    final pdf = pw.Document();
    final title = 'Top 3 User Report';

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          pw.Header(
              level: 0,
              child: pw.Text(title, style: pw.TextStyle(fontSize: 18))),
          pw.Table.fromTextArray(
            context: context,
            data: <List<String>>[
              <String>[
                'Username',
                'City',
                'Phone',
                'Email',
                'Exchanges',
                'Purchases',
                'Active Items'
              ],
              ...topUsers.map((user) => [
                    user.korisnickoIme ?? 'N/A',
                    user.nazivGrada ?? 'N/A',
                    user.telefon ?? 'N/A',
                    user.email ?? 'N/A',
                    user.brojRazmjena.toString(),
                    user.brojKupovina.toString(),
                    user.brojAktivnihArtikala.toString(),
                  ])
            ],
          ),
        ],
      ),
    );

    // Save the PDF file and share it
    final bytes = await pdf.save();
    await Printing.sharePdf(bytes: bytes, filename: 'top_3_user_report.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                  vertical: MediaQuery.of(context).size.height * 0.05),
              child: Column(
                children: [
                  Expanded(
                    child: isLoading
                        ? Center(child: CircularProgressIndicator())
                        : topUsers.isEmpty
                            ? Center(
                                child:
                                    Text('Trenutno nemate aktivnih korisnika'))
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columns: const <DataColumn>[
                                    DataColumn(label: Text('Korisničko ime')),
                                    DataColumn(label: Text('Grad')),
                                    DataColumn(label: Text('Broj telefona')),
                                    DataColumn(label: Text('Email')),
                                    DataColumn(label: Text('Broj razmjena')),
                                    DataColumn(label: Text('Broj kupovina')),
                                    DataColumn(
                                        label: Text('Broj aktivnih artikala')),
                                  ],
                                  rows: topUsers.map<DataRow>((user) {
                                    return DataRow(cells: [
                                      DataCell(
                                          Text(user.korisnickoIme ?? 'N/A')),
                                      DataCell(Text(user.nazivGrada ?? 'N/A')),
                                      DataCell(Text(user.telefon ?? 'N/A')),
                                      DataCell(Text(user.email ?? 'N/A')),
                                      DataCell(
                                          Text(user.brojRazmjena.toString())),
                                      DataCell(
                                          Text(user.brojKupovina.toString())),
                                      DataCell(Text(user.brojAktivnihArtikala
                                          .toString())),
                                    ]);
                                  }).toList(),
                                ),
                              ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: () {
                          generateReport();
                        },
                        child: Text('Kreiraj izvještaj'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:ezamjena_desktop/model/report.dart';
import 'package:ezamjena_desktop/providers/report_provider.dart';

class ReportsPage extends StatefulWidget {
  static const routeName = '/reports';
  const ReportsPage({super.key});
  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final _reasonCtl = TextEditingController();
  final List<Report> _items = [];
  ReportProvider? _reportProvider;
  bool _loading = true;
  final _hCtrl = ScrollController();
  final _vCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _reportProvider = context.read<ReportProvider>();
      _reportProvider!.addListener(_onProviderRefresh);
      _load();
    });
  }

  void _onProviderRefresh() {
    _load(razlog: _reasonCtl.text);
  }

  Future<void> _load({String? razlog}) async {
    setState(() => _loading = true);
    final search = <String, dynamic>{};
    if (razlog != null && razlog.trim().isNotEmpty) {
      search['razlog'] = razlog.trim(); // backend: query param “razlog”
    }

    final res = await _reportProvider!.get(search);
    if (!mounted) return;
    setState(() {
      _items
        ..clear()
        ..addAll(res);
      _loading = false;
    });
  }

  @override
  void dispose() {
    _reportProvider?.removeListener(_onProviderRefresh);
    _reasonCtl.dispose();
    _hCtrl.dispose();
    _vCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
              child: Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    const Text('Filtriraj po razlogu:'),
                    SizedBox(
                      width: 320,
                      child: TextField(
                        controller: _reasonCtl,
                        decoration: const InputDecoration(
                          hintText: 'npr. lažan oglas',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        onSubmitted: (v) => _load(razlog: v),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _load(razlog: _reasonCtl.text),
                      child: const Text('Pretraži'),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        _reasonCtl.clear();
                        _load();
                      },
                      child: const Text('Prikaži sve'),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _items.isEmpty
                        ? const Center(child: Text('Nema prijava.'))
                        : Scrollbar(
                            controller: _hCtrl, // ⇐ daje scroll position
                            thumbVisibility: true,
                            notificationPredicate: (notif) =>
                                notif.metrics.axis ==
                                Axis.horizontal, // ⇐ ovaj scrollbar sluša H
                            child: SingleChildScrollView(
                              controller: _hCtrl, // ⇐ isti kontroler
                              scrollDirection: Axis.horizontal,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: MediaQuery.of(context).size.width,
                                ),
                                child: Scrollbar(
                                  controller: _vCtrl, // ⇐ drugi scrollbar za V
                                  thumbVisibility: true,
                                  notificationPredicate: (notif) =>
                                      notif.metrics.axis ==
                                      Axis.vertical, // ⇐ sluša V
                                  child: SingleChildScrollView(
                                    controller: _vCtrl, // ⇐ isti kontroler
                                    scrollDirection: Axis.vertical,
                                    child: DataTable(
                                      columns: const [
                                        DataColumn(label: Text('Proizvod')),
                                        DataColumn(label: Text('Prijavio')),
                                        DataColumn(label: Text('Razlog')),
                                        DataColumn(label: Text('Poruka')),
                                        DataColumn(label: Text('Datum')),
                                      ],
                                      rows: _items.map((r) {
                                        final dt = r.datum != null
                                            ? DateFormat('yyyy-MM-dd HH:mm')
                                                .format(r.datum!)
                                            : '';
                                        return DataRow(cells: [
                                          DataCell(Text(r.proizvodNaziv ??
                                              (r.proizvodId?.toString() ??
                                                  ''))),
                                          DataCell(Text(
                                            r.prijavioKorisnik ??
                                                (r.prijavioKorisnikId
                                                        ?.toString() ??
                                                    ''),
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                          DataCell(Text(r.razlog ?? '')),
                                          DataCell(SizedBox(
                                            width: 300,
                                            child: Text(
                                              (r.poruka == null ||
                                                      r.poruka!.trim().isEmpty)
                                                  ? 'Nema poruke'
                                                  : r.poruka!,
                                              overflow: TextOverflow.ellipsis,
                                              style: (r.poruka == null ||
                                                      r.poruka!.trim().isEmpty)
                                                  ? const TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      color: Colors.grey)
                                                  : null,
                                            ),
                                          )),
                                          DataCell(Text(dt)),
                                        ]);
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ))
          ],
        ),
      ),
    );
  }
}

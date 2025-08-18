import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../widets/master_page.dart';
import '../../utils/logged_in_usser.dart';
import '../../model/product_notification.dart';
import '../../providers/product_notification_provider.dart';

class NotificationsPage extends StatefulWidget {
  static const routeName = '/notifications';
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final _items = <ProductNotification>[];
  late ProductNotificationProvider _provider;
  bool _loading = true;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _provider = context.read<ProductNotificationProvider>();
    _load();
  }

  Future<void> _load({String? dateFilter}) async {
    setState(() => _loading = true);

    // Ako backend podržava query parametre (preporučeno):
    final search = <String, dynamic>{
      'korisnikId': LoggedInUser.userId,
      if (dateFilter != null) 'datum': dateFilter,
    };

    final res = await _provider.get(search.isEmpty ? null : search);

    // Ako backend još nema filter – fallback klijentski:
    final filtered = res.where((n) =>
        n.korisnikId == LoggedInUser.userId &&
        (dateFilter == null ||
            DateFormat('yyyy-MM-dd').format(n.vrijemeKreiranja!) ==
                dateFilter));

    if (!mounted) return;
    setState(() {
      _items
        ..clear()
        ..addAll(filtered);
      _items.sort((a, b) => (b.vrijemeKreiranja ?? DateTime(0))
          .compareTo(a.vrijemeKreiranja ?? DateTime(0)));
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;

    return MasterPageWidget(
      child: _loading
          ? Center(child: SpinKitFadingCircle(color: purple, size: 60))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(),
                  const SizedBox(height: 12),
                  _dateFilterCard(purple),
                  const SizedBox(height: 16),
                  _items.isEmpty ? _emptyCard() : _list(purple),
                ],
              ),
            ),
    );
  }

  // UI helpers
  Widget _header() => Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 2),
        child: Center(
          child: Text(
            'Notifikacije',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      );

  Widget _dateFilterCard(Color purple) => Center(
        child: Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Filtriraj po datumu:',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.calendar_month_outlined),
                  label: const Text('Odaberi datum'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: purple,
                    side: BorderSide(color: purple),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22)),
                  ),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      _selectedDate = picked;
                      await _load(
                        dateFilter: DateFormat('yyyy-MM-dd').format(picked),
                      );
                    }
                  },
                ),
                if (_selectedDate != null) ...[
                  const SizedBox(height: 8),
                  TextButton.icon(
                    icon: const Icon(Icons.clear, size: 18),
                    label: const Text('Prikaži sve',
                        style: TextStyle(fontSize: 14)),
                    onPressed: () async {
                      _selectedDate = null;
                      await _load();
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      );

  Widget _emptyCard() => Card(
        margin: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Nemate notifikacija.',
              style: TextStyle(fontWeight: FontWeight.w600)),
        ),
      );

  Widget _list(Color purple) => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _items.length,
        itemBuilder: (_, i) => _itemCard(_items[i], purple),
      );

  Widget _itemCard(ProductNotification n, Color purple) => Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(Icons.notifications_none, color: purple, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    n.poruka ?? 'Obavijest',
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              if (n.proizvodNaziv != null)
                Row(children: [
                  Icon(Icons.shopping_bag_outlined, color: purple, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text('Proizvod: ${n.proizvodNaziv}',
                        style: const TextStyle(fontSize: 14)),
                  ),
                ]),
              const SizedBox(height: 6),
              Row(children: [
                Icon(Icons.access_time, color: purple, size: 16),
                const SizedBox(width: 6),
                Text(
                  n.vrijemeKreiranja != null
                      ? DateFormat('dd.MM.yyyy • HH:mm')
                          .format(n.vrijemeKreiranja!)
                      : '',
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ]),
            ],
          ),
        ),
      );
}

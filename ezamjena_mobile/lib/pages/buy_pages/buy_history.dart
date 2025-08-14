import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/single_child_widget.dart';

import 'package:ezamjena_mobile/widets/master_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/buy.dart';
import '../../model/product.dart';
import '../../model/trade.dart';
import '../../providers/buy_provider.dart';
import '../../providers/exchange_provider.dart';
import '../../providers/products_provider.dart';
import '../../utils/logged_in_usser.dart';
import '../../utils/utils.dart';
import '../../widets/alert_dialog_widet.dart';

class BuyHistoryPage extends StatefulWidget {
  static const String routeName = '/buy_history';
  const BuyHistoryPage({Key? key}) : super(key: key);

  @override
  State<BuyHistoryPage> createState() => _BuyHistoryPageState();
}

class _BuyHistoryPageState extends State<BuyHistoryPage> {
  final List<Buy> _buys = [];
  BuyProvider? _buyProvider;
  bool _loading = true;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _buyProvider = context.read<BuyProvider>();
    _loadData();
  }

  Future<void> _loadData({String? dateFilter}) async {
    setState(() => _loading = true);

    final tmp = await _buyProvider?.get(
      dateFilter == null ? null : {'datum': dateFilter},
    );

    if (mounted && tmp != null) {
      _buys
        ..clear()
        ..addAll(tmp.where((b) => b.korisnikId == LoggedInUser.userId));

      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;

    return MasterPageWidget(
      child: _loading
          ? Center(
              child: SpinKitFadingCircle(color: purple, size: 60),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(),
                  const SizedBox(height: 12),
                  _dateFilterCard(purple),
                  const SizedBox(height: 16),
                  _buys.isEmpty
                      ? _emptyCard()
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _buys.length,
                          itemBuilder: (_, i) => _buyCard(_buys[i], purple),
                        ),
                ],
              ),
            ),
    );
  }

  // ─────────────────── widgets ───────────────────
  Widget _header() => Container(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      child: Text(
        'Historija kupovina',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: Colors.grey.shade600,
        ),
      ));

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
                const Text(
                  'Filtriraj po datumu:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
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
                      await _loadData(
                          dateFilter: DateFormat('yyyy-MM-dd').format(picked));
                    }
                  },
                ),
                if (_selectedDate != null) ...[
                  const SizedBox(height: 8),
                  TextButton.icon(
                    icon: const Icon(Icons.clear, size: 18),
                    label: const Text(
                      'Prikaži sve',
                      style: TextStyle(fontSize: 14),
                    ),
                    onPressed: () async {
                      _selectedDate = null;
                      await _loadData();
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
          child: Text(
            'Trenutno nemate nijednu kupovinu u historiji.',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      );

  Widget _buyCard(Buy b, Color purple) => Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ❶ Ikona + naslov
              Row(
                children: [
                  Icon(Icons.shopping_bag_outlined, color: purple, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style:
                            const TextStyle(fontSize: 15, color: Colors.black),
                        children: [
                          const TextSpan(
                              text: 'Naziv kupljenog proizvoda ',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          TextSpan(
                              text: '(${b.nazivProizvoda})',
                              style: TextStyle(color: purple)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text('Cijena: ${b.cijena} KM',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              // ❷ Ikona + datum
              Row(
                children: [
                  Icon(Icons.calendar_month_outlined, color: purple, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'Datum kupovine: '
                    '${DateFormat('dd.MM.yyyy • HH:mm').format(b.datum!)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}

import 'package:provider/single_child_widget.dart';

import 'package:ezamjena_mobile/widets/master_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/product.dart';
import '../../model/trade.dart';
import '../../providers/exchange_provider.dart';
import '../../providers/products_provider.dart';
import '../../utils/logged_in_usser.dart';
import '../../utils/utils.dart';
import '../../widets/alert_dialog_widet.dart';
import 'package:intl/intl.dart';

class ExchangeHistoryPage extends StatefulWidget {
  static const String routeName = "/exchange_history";

  const ExchangeHistoryPage({super.key});

  @override
  State<ExchangeHistoryPage> createState() => _ExchangeHistoryPageState();
}

class _ExchangeHistoryPageState extends State<ExchangeHistoryPage> {
  List<Trade> trades = [];
  ExchangeProvider? _exchangeProvider = null;
  bool _isLoading = true;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _exchangeProvider = context.read<ExchangeProvider>();
    loadData();
  }

  Future loadData() async {
    setState(() {
      _isLoading = true;
    });
    var tempData = await _exchangeProvider?.get(null);
    if (mounted && tempData != null) {
      setState(() {
        trades = tempData
                .where((trade) =>
                    (trade.korisnik1Id == LoggedInUser.userId ||
                        trade.korisnik2Id == LoggedInUser.userId) &&
                    trade.statusRazmjeneId == 2)
                .toList() ??
            [];
        _isLoading = false;
      });
    }
    print('Data loaded successfully.');
  }

  @override
  Widget build(BuildContext context) {
    return MasterPageWidget(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              _buildHeader(),
              buildDateTimeSearch(),
              _isLoading
                  ? CircularProgressIndicator()
                  : buildExchangeList(trades),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        "Historija razmjena",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 40,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget buildDateTimeSearch() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Text(
            "Filtriraj po datumu:",
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );

              if (selectedDate != null) {
                _selectedDate = selectedDate;
                var dateFormatter = DateFormat('yyyy-MM-dd');
                var formattedDate = dateFormatter.format(selectedDate);
                print("ovo je formatirani datum : " + formattedDate);
                var tmpData =
                    await _exchangeProvider?.get({'datum': formattedDate});
                print("ovo je tmpData razmjena: " + tmpData!.length.toString());
                setState(() {
                  trades = tmpData
                      .where((trade) =>
                          (trade.korisnik1Id == LoggedInUser.userId ||
                              trade.korisnik2Id == LoggedInUser.userId) &&
                          trade.statusRazmjeneId == 2)
                      .toList();
                });
              }
            },
            child: Text("Odaberi datum"),
          ),
          const SizedBox(width: 10),
          if (_selectedDate != null)
            OutlinedButton.icon(
              icon: const Icon(Icons.clear),
              label: const Text("Prikaži sve"),
              onPressed: () async {
                _selectedDate = null;
                await loadData();
              },
            ),
        ],
      ),
    );
  }

  Widget buildExchangeList(List<Trade> trades) {
    if (trades.isEmpty) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          "Trenutno nemate nijednu razmjenu u historiji razmjena",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: trades.length,
      itemBuilder: (context, index) {
        Trade trade = trades[index];

        return Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Razmijenjen proizvod (${trade.proizvod1Naziv}) za proizvod (${trade.proizvod2Naziv})",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text("Datum razmjene: ${trade.datum}"),
            ],
          ),
        );
      },
    );
  }
}

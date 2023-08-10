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
  static const String routeName = "/buy_history";

  const BuyHistoryPage({super.key});

  @override
  State<BuyHistoryPage> createState() => _BuyHistoryPageState();
}

class _BuyHistoryPageState extends State<BuyHistoryPage> {
  List<Buy> buys = [];
  BuyProvider? _buyProvider = null;

  @override
  void initState() {
    super.initState();
    _buyProvider = context.read<BuyProvider>();
    loadData();
  }
//   @override
// void didChangeDependencies() {
//   super.didChangeDependencies();
//   _buyProvider = context.watch<BuyProvider>();
//   loadData();
// }

  Future loadData() async {
    var tempData = await _buyProvider?.get(null);
    if (mounted && tempData != null) {
      setState(() {
        print('Setirano stanje istorije kupovina.');
        buys = tempData;
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
              buildExchangeList(buys),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Buy>> _loadData() async {
    var tempData = await _buyProvider?.get(null);
    return tempData!;
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        "Historija kupovina",
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
                var dateFormatter = DateFormat('yyyy-MM-dd');
                var formattedDate = dateFormatter.format(selectedDate);
                var tmpData =
                    await _buyProvider?.get({'datum': formattedDate});
                print("ovo je tmpData razmjena: " + tmpData!.length.toString());
                setState(() {
                  buys = tmpData.where((buy) => buy.korisnikId == LoggedInUser.userId )
            .toList();
                });
              }
            },
            child: Text("Odaberi datum"),
          ),
        ],
      ),
    );
  }

  Widget buildExchangeList(List<Buy> buys) {
    if (buys.isEmpty) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          "Trenutno nemate nijednu kupovinu u istoriji kupovina",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: buys.length,
      itemBuilder: (context, index) {
        Buy buy = buys[index];

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
                "Naziv kupljeno proizvoda: (${buy.proizvodId})",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "Cijena: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text("Datum kupovine: ${buy.datum}"),
            ],
          ),
        );
      },
    );
  }
}

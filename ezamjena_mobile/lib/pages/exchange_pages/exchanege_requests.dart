import 'dart:convert';

import 'package:ezamjena_mobile/utils/logged_in_usser.dart';
import 'package:ezamjena_mobile/widets/master_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/trade.dart';
import '../../providers/exchange_provider.dart';
import '../../utils/utils.dart'; // Pretpostavljam da imaš nešto slično za obradu slika

class ExchangeRequestsPage extends StatefulWidget {
  static const String routeName = "/exchange_requests";

  const ExchangeRequestsPage({Key? key}) : super(key: key);

  @override
  State<ExchangeRequestsPage> createState() => _ExchangeRequestsPageState();
}

class _ExchangeRequestsPageState extends State<ExchangeRequestsPage> {
  List<Trade> requests = [];
  ExchangeProvider? _exchangeProvider;

  @override
  void initState() {
    super.initState();
    _exchangeProvider = context.read<ExchangeProvider>();
    loadRequests();
  }

  Future loadRequests() async {
    var tempData = await _exchangeProvider?.get(null);
    if (mounted && tempData != null) {
      setState(() {
        requests = tempData
            .where((trade) =>
                trade.proizvod2?.korisnikId == LoggedInUser.userId &&
                trade.statusRazmjeneId == 1)
            .toList();
        print(
            'Loaded requests: $requests'); // This will print the data to the console.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterPageWidget(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              _buildHeader(),
              buildRequestsGrid(), // Ovo mijenjamo u grid prikaz
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        "Zahtjevi za razmjenu",
        style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget buildRequestsGrid() {
    if (requests.isEmpty) {
      // If there are no requests, display a message.
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "Trenutno nemate zahtjeve za razmjenu.",
            style: TextStyle(fontSize: 18, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    // Koristimo GridView.builder umjesto ListView.builder
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Dva elementa u redu
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1 / 1, // Odnos visine i širine za svaki element
      ),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        Trade trade = requests[index];
        return buildRequestCard(trade);
      },
    );
  }

  Widget buildRequestCard(Trade trade) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: trade.proizvod2?.slika != null
                ? Image.memory(
                    base64Decode(trade.proizvod2!
                        .slika!), // Korištenje ! jer smo već provjerili da nije null
                    fit: BoxFit.cover,
                  )
                : Placeholder(), // Ili neki drugi widget za slučaj da nema slike
          ),
          Text(trade.proizvod2?.naziv ?? 'Nepoznat proizvod',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
              'Kategorija:${trade.proizvod2?.kategorijaProizvoda?.naziv}'), // Ovdje trebaš mapirati ID na naziv kategorije trade.proizvod2?.nazivKategorijeProizvoda
          Text(
              'Procjenjena cijena:${trade.proizvod2?.cijena} '), //trade.proizvod2?.cijena
          Text(
              'Stanje:${trade.proizvod2?.stanjeNovo ?? false ? 'Novo' : 'Polovno'}'), //   ${} trade.proizvod2?.stanjeNovo ?? false ? 'Novo' : 'Polovno'
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  // Logika za odbijanje pojedinog zahtjeva
                },
              ),
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () async {
                  // Update the trade request status
                  trade.statusRazmjeneId = 2;
                  var request = {
                    "statusRazmjeneId": 2,
                    "datum": DateTime.now().toIso8601String(),
                    "proizvod1Id": trade.proizvod1Id,
                    "proizvod2Id": trade.proizvod2Id,
                  };

                  var updateResult =
                      await _exchangeProvider!.update(trade.id, request);

                  // If the update is successful, reload the requests
                  await loadRequests();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Zahtjev je uspješno prihvaćen.")));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

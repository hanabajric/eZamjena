import 'package:ezamjena_mobile/widets/master_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/product.dart';
import '../../model/trade.dart';
import '../../providers/buy_provider.dart';
import '../../providers/exchange_provider.dart';
import '../../providers/proba_provider.dart';
import '../../providers/products_provider.dart';
import '../../utils/logged_in_usser.dart';
import '../../utils/utils.dart';
import '../../widets/alert_dialog_widet.dart';

class ProductDetailsPage extends StatefulWidget {
  static const String routeName = "/product_details";
  final String id;
  //Product? data;
  const ProductDetailsPage(this.id, {Key? key}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  ProductProvider? _productProvider = null;
  late String id;
  Product? data;
  List<Product> list = [];
  Product? selectedProduct;
  ExchangeProvider? _exchangeProvider = null;
  ProbaProvider? _probaProvider = null;
  Trade trade = Trade();

  @override
  void initState() {
    super.initState();
    id = widget.id;
    _productProvider = context.read<ProductProvider>();
    //_exchangeProvider = context.read<ExchangeProvider>();
    id = widget.id;
    loadData();
  }

  Future loadData() async {
    print('Loading data...');
    final tempData = await _productProvider?.getById(int.parse(id));
    print('Temp data: $tempData');

    final tempList = await _productProvider?.get(null);
    print('Temp list: $tempList');

    //final tempBuy = await _buyProvider?.get(null);
    //print('Temp list of buys: $tempBuy');

    list = tempList!
        .where((product) => product.korisnikId == LoggedInUser.userId)
        .toList();
    if (mounted && tempData != null) {
      setState(() {
        data = tempData;

        selectedProduct = list.isNotEmpty ? list[0] : null;
        // list = tempList;
      });
    }

    print('Data loaded successfully.');
  }

  @override
  Widget build(BuildContext context) {
    return MasterPageWidget(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            productInfoWidget(),
            SizedBox(height: 20),
            RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Odaberite vaš predmet za ',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  TextSpan(
                    text: 'zamjenu',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' (preporučeno ite ili slične procjenjene cijene):',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                list.isNotEmpty
                    ? DropdownButton<Product>(
                        value: selectedProduct,
                        onChanged: (product) {
                          setState(() {
                            selectedProduct = product;
                          });
                        },
                        items: list.map((product) {
                          return DropdownMenuItem<Product>(
                            value: product,
                            child: Text(product.naziv ?? ""),
                          );
                        }).toList(),
                      )
                    : Text('Trenutno nemate proizvode'),
                Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    // _tradeProvider = context.read<TradeProvider>();
                    trade.datum = DateTime.now();
                    trade.proizvod1Id = selectedProduct?.id;
                    trade.proizvod2Id = data?.id;
                    trade.statusRazmjeneId = 1;
                    _exchangeProvider = context.read<ExchangeProvider>();
                    var response =
                        await _exchangeProvider?.insert(trade.toJson());
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialogWidget(
                        title: "Zahtjev poslan",
                        message: response.toString(),
                        //message:
                        //'Uspješno ste poslali zahtjev za proizvod ${data?.naziv ?? ""} ',
                        context: context,
                      ),
                    );
                  },
                  child: Text('Pošaljite zahtjev'),
                ),
              ],
            ),
            SizedBox(height: 20),
            RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Ili izvršite ',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  TextSpan(
                    text: 'kupovinu',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' proizvoda:',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Ovdje postavite logiku za klik na prvo dugme
                  },
                  child: Text('Odustani'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 213, 71, 60),
                    ),
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    // Ovdje postavite logiku za klik na drugo dugme
                  },
                  child: Text('Kupi'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // void sendTradeRequest(
  //     Product? selectedProduct, String id, TradeProvider tradeProvider) async {
  //   if (selectedProduct != null) {
  //     // Kreiranje objekta razmjene
  //     Trade trade = Trade(
  //       datum: DateTime.now().toString(),
  //       proizvod1Id: selectedProduct.id,
  //       proizvod2Id: int.parse(id),
  //       statusRazmjeneId: 1,
  //     );

  //     // Slanje zahtjeva za razmjenu
  //     await tradeProvider.insert(trade);
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) => AlertDialogWidget(
  //         title: "Zahtjev poslan",
  //         message:
  //             'Uspješno ste poslali zahtjev za proizvod ${data?.naziv ?? ""} ',
  //         context: context,
  //       ),
  //     );

  //     // Dodajte odgovarajuću logiku nakon slanja zahtjeva (npr. prikaz poruke o uspješnom slanju)
  //   } else {
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) => AlertDialogWidget(
  //         title: "Upozorenje",
  //         message: "Trenutno nemate proizvod da ponudite za razmjenu.",
  //         context: context,
  //       ),
  //     );
  //   }
  // }

  Widget productInfoWidget() {
    // if (data == null) {
    //   return Center(child: CircularProgressIndicator());
    // } else {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informacije o proizvodu - ${data?.naziv ?? ''}',
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Container(
              width: 200,
              height: 200,
              color: Colors.grey, // Ovdje možete postaviti boju pozadine slike
              child: data != null
                  ? imageFromBase64String(data?.slika)
                  : Container(),
            ),
            SizedBox(width: 30),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Naziv: ${data?.naziv ?? ''}',
                      style: TextStyle(fontSize: 15)),
                  SizedBox(height: 15),
                  Text('Kategorija: ${data?.nazivKategorijeProizvoda ?? ''}',
                      style: TextStyle(fontSize: 15)),
                  SizedBox(height: 15),
                  Text('Procjenjena cijena: ${data?.cijena ?? ''}',
                      style: TextStyle(fontSize: 15)),
                  SizedBox(height: 15),
                  Text('Korisnik: ${data?.nazivKorisnika ?? ''}',
                      style: TextStyle(fontSize: 15)),
                  SizedBox(height: 15),
                  Text('Stanje: ${data?.stanjeNovo ?? ''}',
                      style: TextStyle(fontSize: 15)),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Text(
          'Opis proizvoda:  ${data?.opis ?? ''}',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 10),
        Container(
          height: 1,
          color: Colors.grey[300], // Ovdje možete postaviti boju linije
        ),
      ],
    );
  }
  //}
}

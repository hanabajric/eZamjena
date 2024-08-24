import 'package:ezamjena_mobile/pages/payment/payment_page.dart';
import 'package:ezamjena_mobile/widets/master_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/product.dart';
import '../../providers/products_provider.dart';
import '../../utils/logged_in_usser.dart';
import '../../utils/utils.dart';
import '../../widets/alert_dialog_widet.dart';

class MyProductDetailsPage extends StatefulWidget {
  static const String routeName = "/my_product_details";
  final String id;

  const MyProductDetailsPage(this.id, {Key? key}) : super(key: key);

  @override
  State<MyProductDetailsPage> createState() => _MyProductDetailsPageState();
}

class _MyProductDetailsPageState extends State<MyProductDetailsPage> {
  ProductProvider? _productProvider = null;
  late String id;
  Product? data;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    _productProvider = context.read<ProductProvider>();
    loadData();
  }

  Future loadData() async {
    print('Loading data...');
    final tempData = await _productProvider?.getById(int.parse(id));
    if (mounted && tempData != null) {
      setState(() {
        data = tempData;
      });
    }
    print('Data loaded successfully.');
  }

  @override
  Widget build(BuildContext context) {
    return MasterPageWidget(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  BackButton(), // Povratak na prethodnu stranicu
                  Expanded(
                    child: Text(
                      'nazad',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              productInfoWidget(),
              SizedBox(height: 20),
              Text(
                'Opis proizvoda: ${data?.opis ?? ''}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget productInfoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informacije o proizvodu - ${data?.naziv ?? ''}',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Container(
              width: 200,
              height: 150,
              color: Colors.grey, // Placeholder za sliku
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
                  Text(
                      'Stanje: ${data?.stanjeNovo == true ? 'Novo' : 'Polovno'}',
                      style: TextStyle(fontSize: 15)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

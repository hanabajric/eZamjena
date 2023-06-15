import 'package:ezamjena_mobile/widets/master_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/product.dart';
import '../../providers/products_provider.dart';
import '../../utils/utils.dart';

class ProductDetailsPage extends StatefulWidget {
  static const String routeName = "/product_details";
  final String id;
  //Product? data;
  ProductDetailsPage(this.id, {Key? key}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late ProductProvider _productProvider;
  late String id;
  Product? data;

  @override
  void initState() {
    super.initState();
    _productProvider = context.read<ProductProvider>();

    id = widget.id;
    loadData();
  }

  Future<void> loadData() async {
    var tempData = await _productProvider.getById(int.parse(id), null);
    setState(() {
      data = tempData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterPageWidget(
      child: Container(
        padding:EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: productInfoWidget(),
            ),
          ],
        ),
      ),
    );
  }

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
              child: data != null ? imageFromBase64String(data?.slika) : Container(),
            ),
            SizedBox(width: 30),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Naziv: ${data?.naziv ?? ''}', style: TextStyle(fontSize: 15)),
                  SizedBox(height: 15),
                  Text('Kategorija: ${data?.nazivKategorijeProizvoda ?? ''}', style: TextStyle(fontSize: 15)),
                  SizedBox(height: 15),
                  Text('Procjenjena cijena: ${data?.cijena ?? ''}', style: TextStyle(fontSize: 15)),
                  SizedBox(height: 15),
                  Text('Korisnik: ${data?.nazivKorisnika ?? ''}', style: TextStyle(fontSize: 15)),
                  SizedBox(height: 15),
                  Text('Stanje: ${data?.stanjeNovo ?? ''}', style: TextStyle(fontSize: 15)),
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

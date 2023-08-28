import 'package:ezamjena_mobile/widets/master_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/product.dart';
import '../../model/product_category.dart';
import '../../model/trade.dart';
import '../../providers/buy_provider.dart';
import '../../providers/exchange_provider.dart';
import '../../providers/product_category_provider.dart';
import '../../providers/products_provider.dart';
import '../../utils/logged_in_usser.dart';
import '../../utils/utils.dart';
import '../../widets/alert_dialog_widet.dart';

class NewProductPage extends StatefulWidget {
  static const String routeName = "/new_product";

  const NewProductPage({super.key});

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  ProductProvider? _productProvider = null;
  Product? data;
  List<Product> list = [];
  Product? selectedProduct;
  ExchangeProvider? _exchangeProvider = null;
  List<ProductCategory> categories = [];
  ProductCategoryProvider? _productCategoryProvider = null;

  @override
  void initState() {
    super.initState();
      _productCategoryProvider = context.read<ProductCategoryProvider>();
    //id = widget.id;
    loadData();
  }

  Future loadData() async {
     var tmpData = await _productCategoryProvider?.get(null);
    setState(() {
      if (tmpData != null) {
        categories = tmpData;
      }
    });
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


  Widget productInfoWidget() {
    // if (data == null) {
    //   return Center(child: CircularProgressIndicator());
    // } else {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dodavanje novog proizvoda ',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Naziv: ',
                      style: TextStyle(fontSize: 15)),
                  SizedBox(height: 30),
                  Text('Kategorija: ',
                      style: TextStyle(fontSize: 15)),
                  SizedBox(height: 30),
                  Text('Procjenjena cijena: ',
                      style: TextStyle(fontSize: 15)),
                  SizedBox(height: 30),
                  Text('Stanje:',
                      style: TextStyle(fontSize: 15)),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 40),
        Text(
          'Opis proizvoda:  ',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 20),
         Container(
        height: 200, // Možete prilagoditi visinu prema potrebi
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: TextField(
          maxLines: null, // Dozvoljava više redova
          decoration: InputDecoration.collapsed(
            hintText: 'Unesite opis...',
          ),
        ),
      ),
      ],
    );
  }
  //}
}

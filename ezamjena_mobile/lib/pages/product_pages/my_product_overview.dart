import 'dart:convert';

import 'package:ezamjena_mobile/key.dart';
import 'package:ezamjena_mobile/pages/product_pages/my_product_details.dart';
import 'package:ezamjena_mobile/pages/product_pages/product_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/product.dart';
import '../../providers/products_provider.dart';
import '../../utils/logged_in_usser.dart';
import '../../utils/utils.dart';
import '../../widets/alert_dialog_widet.dart';
import '../../widets/master_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyProductListPage extends StatefulWidget {
  static const String routeName = "/myproducts";
  const MyProductListPage({super.key});

  @override
  State<MyProductListPage> createState() => _MyProductListPage();
}

class _MyProductListPage extends State<MyProductListPage> {
  ProductProvider?
      _productProvider; // prvo pokretanje null dok se ne izvrši initState
  List<Product> data = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _productProvider = context.read<ProductProvider>();
    loadData();
  }

  Future loadData() async {
    setState(() {
      _isLoading = true;
    });
    var tempData = await _productProvider?.get(null);
    if (mounted && tempData != null) {
      setState(() {
        data = tempData
            .where((product) =>
                product.korisnikId == LoggedInUser.userId &&
                product.statusProizvodaId == 1)
            .toList();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;

    return MasterPageWidget(
      child: _isLoading
          ? Center(
              child: SpinKitFadingCircle(
                color: purple,
                size: 60,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildProductGrid(),
                ],
              ),
            ),
    );
  }

  Widget _buildProductGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        childAspectRatio: 2 / 3.5,
        crossAxisSpacing: 20,
        mainAxisSpacing: 35,
        physics: NeverScrollableScrollPhysics(),
        children: _buildProductCardList(),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        "Moji proizvodi",
        style: TextStyle(
            color: Colors.grey, fontSize: 40, fontWeight: FontWeight.w600),
      ),
    );
  }

  List<Widget> _buildProductCardList() {
    if (data.length == 0) {
      return [
        Center(
            child: Text("Trenutno nemate proizvoda.",
                style: TextStyle(fontSize: 20)))
      ];
    }
    return data
        .map((x) => Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context,
                            "${MyProductDetailsPage.routeName}/${x.id}");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: MemoryImage(base64Decode(x.slika!)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Flexible(
                    child: Text(
                      x.naziv ?? "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                              context: navigatorKey.currentContext!,
                              builder: (BuildContext context) => AlertDialog(
                                    title: Text("Brisanje proizvoda"),
                                    content: Text(
                                        'Da li ste sigurni da želite obrisati proizvod ${x.naziv ?? ""} '),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          var response = await _productProvider
                                              ?.delete(x.id!);
                                          showDialog(
                                            context: navigatorKey
                                                .currentState!.overlay!.context,
                                            builder: (BuildContext context) =>
                                                AlertDialogWidget(
                                              title: "Brisanje uspješno",
                                              message:
                                                  "Uspješno ste obrisali proizvod ${x.naziv ?? " "}",
                                              context: context,
                                            ),
                                          );
                                          setState(() {
                                            loadData();
                                          });
                                        },
                                        child: Text("DA"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("NE"),
                                      ),
                                    ],
                                  ));
                        },
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ))
        .toList();
  }
}

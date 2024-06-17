import 'package:ezamjena_mobile/pages/product_pages/product_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/product.dart';
import '../../providers/products_provider.dart';
import '../../utils/logged_in_usser.dart';
import '../../utils/utils.dart';
import '../../widets/alert_dialog_widet.dart';
import '../../widets/master_page.dart';

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
  //late BuildContext _context; // Dodajte varijablu za BuildContext

  @override
  void initState() {
    super.initState();
    _productProvider = context.read<ProductProvider>();
    loadData();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   _productProvider = context.watch<ProductProvider>();
  // loadData();
  // }

  Future loadData() async {
    var tempData = await _productProvider?.get(null);
    if (mounted && tempData != null) {
      setState(() {
        data = tempData
            .where((product) => product.korisnikId == LoggedInUser.userId)
            .toList();
      });
    }
  }

@override
Widget build(BuildContext context) {
  return MasterPageWidget(
    child: SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(),
          SizedBox(height: 40),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              shrinkWrap: true, // Makes the GridView take the size of its children
              crossAxisCount: 2,
              childAspectRatio: 2 / 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 30,
              physics: NeverScrollableScrollPhysics(), // Ensures the GridView does not scroll separately
              children: _buildProductCardList(),
            ),
          )
        ],
      ),
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
    if (data?.length == 0) {
      return [
        Center(
          child: Text(
            "Trenutno nemate proizvoda.",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ];
    }
    List<Widget> list = data
        .map((x) => Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, "${ProductDetailsPage.routeName}/${x.id}");
                      },
                      child: Container(
                        child: imageFromBase64String(x.slika),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(x.naziv ?? ""),
                  // SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
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
                                            context: context,
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
        .cast<Widget>()
        .toList();

    return list;
  }
}

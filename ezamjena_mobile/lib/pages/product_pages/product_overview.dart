import 'package:ezamjena_mobile/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ezamjena_mobile/utils/utils.dart';

import '../../model/product.dart';

class ProductListPage extends StatefulWidget {
  static const String routeName = "/products";
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPagetState();
}

class _ProductListPagetState extends State<ProductListPage> {
  ProductProvider? _productProvider =null; // prvo pokretanje null dok se ne izvrši initState
  List<Product> data = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _productProvider = context.read<ProductProvider>();
    loadData();
  }

  Future loadData() async {
    var tempData = await _productProvider?.get(null);
    setState(() {
      data = tempData!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
        child: Container(
          
            child: Column(
             // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // _buildHeader(),
            SizedBox(height: 40),
           Container(
             height: 800,
             child:GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3/4,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 30),
              scrollDirection: Axis.vertical,
              children: _buildProductCardList(),
            )
           )
          ],
        )),
      ),
      )
    );
  }

Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text("Products", style: TextStyle(color: Colors.grey, fontSize: 40, fontWeight: FontWeight.w600),),
    );
  }

  List<Widget> _buildProductCardList() {
    if (data.length == 0) {
      return [Text("Trenutno nema proizvoda.")];
    }
    List<Widget> list = data
        .map((x) => Container(
              height: 200,
              width: 200,
              child:Column(children: [
                Container(
                  child:imageFromBase64String(x.slika!)
                  ),
              Text(x.naziv  ?? ""),
              ],)
               
            ))
        .cast<Widget>()
        .toList();

    return list;
  }
}

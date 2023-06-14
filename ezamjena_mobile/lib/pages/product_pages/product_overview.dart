import 'package:ezamjena_mobile/pages/product_pages/product_details.dart';
import 'package:ezamjena_mobile/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ezamjena_mobile/utils/utils.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../model/product.dart';
import '../../widets/ezamjena_drawer.dart';
import '../../widets/master_page.dart';

class ProductListPage extends StatefulWidget {
  static const String routeName = "/products";
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPagetState();
}

class _ProductListPagetState extends State<ProductListPage> {
  ProductProvider? _productProvider =
      null; // prvo pokretanje null dok se ne izvrši initState
  List<Product> data = [];
  TextEditingController _searchController = TextEditingController();
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
     return MasterPageWidget(
          child: SingleChildScrollView(
            child: Container(
                child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildProductSearch(),
                SizedBox(height: 40),
                Container(
                    height: 800,
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: GridView(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 3 / 4,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 30),
                          scrollDirection: Axis.vertical,
                          children: _buildProductCardList(),
                        )))
              ],
            )),
          ),
        );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        "Products",
        style: TextStyle(
            color: Colors.grey, fontSize: 40, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildProductSearch() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: 20, vertical: 5), // Prilagodite padding za visinu
          child: TextField(
            controller: _searchController,
            onSubmitted: (value) async {
              var tmpData = await _productProvider?.get({'naziv': value});
              setState(() {
                data = tmpData!;
              });
            },
            decoration: InputDecoration(
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey),
              ),
              contentPadding: EdgeInsets.symmetric(
                  vertical: 5), // Prilagodite padding za visinu
            ),
          ),
        ),
        // Dodajte dodatne widgete ispod Search Box-a ovdje
      ],
    );
  }

  List<Widget> _buildProductCardList() {
    if (data.length == 0) {
      return [Text("Trenutno nema proizvoda.")];
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
                        Navigator.pushNamed(context, "${ProductDetailsPage.routeName}/${x.id}");
                      },
                      child: Container(
                        child: imageFromBase64String(x.slika!),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(x.naziv ?? ""),
                  SizedBox(height: 8),
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemSize: 20,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    onRatingUpdate: (rating) {
                      // Ovdje možete dodati logiku za ažuriranje ocjene proizvoda
                      print(rating);
                    },
                  ),
                ],
              ),
            ))
        .cast<Widget>()
        .toList();

    return list;
  }
}

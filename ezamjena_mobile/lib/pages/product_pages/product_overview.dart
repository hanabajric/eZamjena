import 'package:ezamjena_mobile/pages/product_pages/product_details.dart';
import 'package:ezamjena_mobile/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ezamjena_mobile/utils/utils.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../model/product.dart';
import '../../model/product_category.dart';
import '../../providers/product_category_provider.dart';
import '../../utils/logged_in_usser.dart';
import '../../widets/ezamjena_drawer.dart';
import '../../widets/master_page.dart';

class ProductListPage extends StatefulWidget {
  static const String routeName = "/products";
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPagetState();
}

class _ProductListPagetState extends State<ProductListPage> {
  ProductProvider?
      _productProvider; // prvo pokretanje null dok se ne izvrši initState
  List<Product> data = [];
  List<ProductCategory> categories = [];
  ProductCategoryProvider? _productCategoryProvider = null;
  //late TradeProvider _tradeProvider;
  String _selectedCategory = "Sve kategorije";
  String _selectedCondition = "Svi proizvodi";

  TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _productProvider = context.read<ProductProvider>();
    _productCategoryProvider = context.read<ProductCategoryProvider>();
    //_tradeProvider=context.read<TradeProvider>();
    loadData();
    _loadCategories();
  }

  Future loadData() async {
    var tempData = await _productProvider?.get(null);
    //var tradeList = await _tradeProvider?.get(null); // Poziv get metode TradeProvider-a
    //print('Trade list: $tradeList');
    print('Temp data cijela: $tempData');
    if (mounted && tempData != null) {
      setState(() {
        if (tempData != null) {
          data = tempData
              .where((product) => product.korisnikId != LoggedInUser.userId)
              .toList();
        }
        print('Setirano stanje proizovda.');
      });
    }
  }

  Future<void> _loadCategories() async {
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
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: TextField(
            controller: _searchController,
            onSubmitted: (value) async {
              await _applyFilters();
            },
            onChanged: (value) async {
              await _applyFilters();
            },
            decoration: InputDecoration(
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 5,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  onChanged: (newValue) async {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                    await _applyFilters();
                  },
                  items: _buildCategoryDropdownItems(),
                  icon: Icon(
                      Icons.arrow_drop_down), // Dodaje ikonu padajućeg menija
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: DropdownButton<String>(
                  value: _selectedCondition,
                  onChanged: (newValue) async {
                    setState(() {
                      _selectedCondition = newValue!;
                    });
                    await _applyFilters();
                  },
                  items: _buildConditionDropdownItems(),
                  icon: Icon(Icons.arrow_drop_down),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Future<void> _applyFilters() async {
    var searchRequest = {
      'naziv': _searchController.text,
      'nazivKategorije': _selectedCategory == "Sve kategorije" ? null : _selectedCategory,
      'novo': _selectedCondition == "Svi proizvodi"
          ? null
          : _selectedCondition == "Novo",
    };
    var tmpData = await _productProvider?.get(searchRequest);
    setState(() {
      data = tmpData!
          .where((product) => product.korisnikId != LoggedInUser.userId)
          .toList();
    });
  }

  List<DropdownMenuItem<String>> _buildCategoryDropdownItems() {
    List<DropdownMenuItem<String>> items = [];

    items.add(DropdownMenuItem<String>(
      value: "Sve kategorije",
      child: Text("Sve kategorije"),
    ));
      for (var category in categories) {
        items.add(DropdownMenuItem<String>(
          value: category
              .naziv, 
          child: Text(category.naziv!),
        ));
      }
    

    return items;
  }

  List<DropdownMenuItem<String>> _buildConditionDropdownItems() {
    List<String> conditions = ["Svi proizvodi", "Novo", "Polovno"];
    return conditions.map((condition) {
      return DropdownMenuItem<String>(
        value: condition,
        child: Text(condition),
      );
    }).toList();
  }

  List<Widget> _buildProductCardList() {
    if (data.length == 0) {
      return [Text("Trenutno nema proizvoda.")];
    }
    List<Widget> list = data
        .map((x) {
          final imageWidget =
              x.slika != null ? imageFromBase64String(x.slika!) : Container();
          return Padding(
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
                      child: imageWidget, //imageFromBase64String(x.slika),
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
          );
        })
        .cast<Widget>()
        .toList();

    return list;
  }
}

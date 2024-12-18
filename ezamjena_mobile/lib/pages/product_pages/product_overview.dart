import 'package:ezamjena_mobile/model/rating.dart';
import 'package:ezamjena_mobile/pages/product_pages/product_details.dart';
import 'package:ezamjena_mobile/providers/products_provider.dart';
import 'package:ezamjena_mobile/providers/rating_provider.dart';
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
  RatingProvider? _ratingProvider = null;
  //late TradeProvider _tradeProvider;
  String _selectedCategory = "Sve kategorije";
  String _selectedCondition = "Svi proizvodi";
  bool _isLoading = true;

  TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _productProvider = context.read<ProductProvider>();
    _productCategoryProvider = context.read<ProductCategoryProvider>();
    _ratingProvider = context.read<RatingProvider>();
    //_tradeProvider=context.read<TradeProvider>();
    loadData();
    _loadCategories();
  }

  Future<void> loadData() async {
    if (LoggedInUser.userId == null) {
      print("UserId is null. Ensure user is logged in.");
      return; // Stop further execution if user is not logged in.
    }

    setState(() {
      _isLoading = true; // Indicate that data is being loaded
    });

    try {
      // Fetch user-specific products, including recommendations
      var products =
          await _productProvider?.getUserSpecificProducts(LoggedInUser.userId);

      if (mounted) {
        setState(() {
          data = products ?? [];
          _isLoading = false; // Data has been loaded
        });
      }
    } catch (e, stacktrace) {
      print('Error loading data: $e');
      print('Stacktrace: $stacktrace'); // Provides more details about the error
      setState(() {
        _isLoading = false;
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
        child: Column(
          children: [
            _buildHeader(),
            _buildProductSearch(),
            SizedBox(height: 40),
            _isLoading
                ? Center(
                    child:
                        CircularProgressIndicator()) // Ako se podaci učitavaju, prikažite spinner
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 4.5,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 35,
                      physics: NeverScrollableScrollPhysics(),
                      children: _buildProductCardList(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        "Proizvodi",
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
      'nazivKategorije':
          _selectedCategory == "Sve kategorije" ? null : _selectedCategory,
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
        value: category.naziv,
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
      return [
        Text(
          "Trenutno nema proizvoda.",
          style: TextStyle(fontSize: 20),
        )
      ];
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
                  onRatingUpdate: (rating) async {
                    // Ovdje možete dodati logiku za ažuriranje ocjene proizvoda
                    print("Ocjena: $rating");
                    await submitRating(rating, x.id!);

                    /* if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ocjena uspješno zabilježena!"))
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Došlo je do greške prilikom zabilježavanja ocjene."))
      );
    }*/
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

  Future<void> submitRating(double rating, int productId) async {
    print(
        "Attempting to submit rating for product ID: $productId"); // Debug log
    print("Rating provider is initialized: ${_ratingProvider != null}");
    try {
      var response = await _ratingProvider?.insert({
        'ocjena1': rating.round(), // Ensure this matches the expected type
        'datum': DateTime.now().toIso8601String(),
        'proizvodId': productId,
        'korisnikId': LoggedInUser.userId,
      });
      if (response != null) {
        print("Rating submitted successfully.");
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Ocjena je uspješno zabilježena!")));
      } else {
        print("Response was null, indicating failure on the server.");
        throw Exception('Failed to submit rating');
      }
    } catch (e) {
      print("Failed to submit rating: $e"); // More detailed error logging
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text("Došlo je do greške prilikom zabilježavanja ocjene: $e")));
    }
  }
}

import 'package:ezamjena_mobile/model/rating.dart';
import 'package:ezamjena_mobile/model/wishlist.dart';
import 'package:ezamjena_mobile/model/wishlist_item.dart';
import 'package:ezamjena_mobile/pages/product_pages/product_details.dart';
import 'package:ezamjena_mobile/providers/products_provider.dart';
import 'package:ezamjena_mobile/providers/rating_provider.dart';
import 'package:ezamjena_mobile/providers/wishlist_provider.dart';
import 'package:ezamjena_mobile/providers/wishlistproduct_provider.dart';
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
  WishlistProvider? _wishlistProvider = null;
  String _selectedCategory = "Sve kategorije";
  String _selectedCondition = "Svi proizvodi";
  bool _isLoading = true;
  List<int> favoriteProductIds = [];
  int? hoveredProductId;

  TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _productProvider = context.read<ProductProvider>();
    _productCategoryProvider = context.read<ProductCategoryProvider>();
    _ratingProvider = context.read<RatingProvider>();
    _wishlistProvider = context.read<WishlistProvider>();

    loadData();
    _loadCategories();
    _loadWishlistProducts();
  }

  Future<void> loadData() async {
    if (LoggedInUser.userId == null) {
      print("UserId is null. Ensure user is logged in.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var products =
          await _productProvider?.getUserSpecificProducts(LoggedInUser.userId);

      if (mounted) {
        setState(() {
          data = products ?? [];
          _isLoading = false;
        });
      }
    } catch (e, stacktrace) {
      print('Error loading data: $e');
      print('Stacktrace: $stacktrace');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void toggleFavorite(Product product) async {
    final userId = LoggedInUser.userId;

    if (userId == null) {
      print("[ERROR] Korisnik nije prijavljen!");
      return;
    }

    final wishlistProductProvider =
        Provider.of<WishlistProductProvider>(context, listen: false);

    print("[INFO] Ovo je proizvod ${product.id} .");

    try {
      // ✅ **Prvo provjeri da li korisnik već ima listu želja**
      final existingWishlists =
          await _wishlistProvider?.get({'korisnikId': userId});

      Wishlist? wishlist;

      if (existingWishlists != null && existingWishlists.isNotEmpty) {
        wishlist = existingWishlists.first;
        print("[INFO] Postojeća lista želja ID: ${wishlist.id}");
      } else {
        wishlist = await _wishlistProvider?.insert({
          'korisnikId': userId,
          'createdAt': DateTime.now().toIso8601String(),
        });

        if (wishlist == null) {
          print("[ERROR] Neuspješno umetanje liste želja.");
          return;
        }
        print("[INFO] Kreirana nova lista želja ID: ${wishlist.id}");
      }

      if (wishlist == null) {
        print("[ERROR] Lista želja je null nakon provjere.");
        return;
      }

      if (favoriteProductIds.contains(product.id)) {
        setState(() {
          favoriteProductIds.remove(product.id);
        });

        print("[DEBUG] Šaljem zahtjev za uklanjanje proizvoda:");
        print("Proizvod ID: ${product.id}");
        // Pronađi WishlistItem koji sadrži product.id
        final wishlistItem = wishlistProductProvider.wishlistProducts
            .firstWhere((item) => item.proizvodId == product.id);

        if (wishlistItem != null) {
          print(
              "[INFO] Brišem proizvod iz wishlist-e sa ID: ${wishlistItem.id}");
          await wishlistProductProvider.delete(wishlistItem.id);
        }
      } else {
        setState(() {
          favoriteProductIds.add(product.id!);
        });

        print("[INFO] Dodajem proizvod ID: ${product.id} u listu želja.");

        final response = await wishlistProductProvider.insert({
          'listaZeljaId': wishlist.id,
          'proizvodId': product.id!,
          'vrijemeDodavanja': DateTime.now().toIso8601String(),
          'korisnikId': userId
        });

        print("[DEBUG] Odgovor API-ja: $response");

        if (response == null) {
          print(
              "[ERROR] API je vratio null! Proizvod nije dodat u listu želja.");
          return;
        }
      }
    } catch (e, stacktrace) {
      print("[ERROR] Greška prilikom umetanja liste želja: $e");
      print("[STACKTRACE] $stacktrace");
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

  Future<void> _loadWishlistProducts() async {
    final userId = LoggedInUser.userId;
    if (userId == null) return;

    try {
      final wishlistProvider =
          Provider.of<WishlistProvider>(context, listen: false);
      final wishlistProductProvider =
          Provider.of<WishlistProductProvider>(context, listen: false);

      final wishlist = await wishlistProvider.getOrCreateWishlist(userId);
      if (wishlist != null && wishlist.id != null) {
        await wishlistProductProvider.fetchWishlistProducts(wishlist.id);

        setState(() {
          favoriteProductIds = wishlistProductProvider.wishlistProducts
              .map((item) => item.proizvodId)
              .toList();
        });
      }
    } catch (e) {
      print("[ERROR] Greška pri učitavanju wishlist proizvoda: $e");
    }
  }

  List<Widget> _buildProductCardList() {
    if (data.isEmpty) {
      return [
        Text(
          "Trenutno nema proizvoda.",
          style: TextStyle(fontSize: 20),
        )
      ];
    }

    return data.map((product) {
      final imageWidget = product.slika != null
          ? imageFromBase64String(product.slika!)
          : Container();

      final isFavorite = favoriteProductIds.contains(product.id);

      return Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context,
                          "${ProductDetailsPage.routeName}/${product.id}");
                    },
                    child: Container(
                      child: imageWidget,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: MouseRegion(
                    onEnter: (_) => setState(() {
                      hoveredProductId = product.id;
                    }),
                    onExit: (_) => setState(() {
                      hoveredProductId = null;
                    }),
                    child: GestureDetector(
                      onTap: () {
                        toggleFavorite(product);
                      },
                      child: Container(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.favorite_border,
                              color: Colors.black,
                              size: 28,
                            ),
                            Icon(
                              Icons.favorite,
                              color: favoriteProductIds.contains(product.id)
                                  ? Colors.red
                                  : (hoveredProductId == product.id
                                      ? Colors.red
                                      : Colors.white),
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(product.naziv ?? ""),
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
                await submitRating(rating, product.id!);
              },
            ),
          ],
        ),
      );
    }).toList();
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

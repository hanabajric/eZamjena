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
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../model/product.dart';
import '../../model/product_category.dart';
import '../../providers/product_category_provider.dart';
import '../../utils/logged_in_usser.dart';
import '../../widets/master_page.dart';
import '../../widets/empty_state.dart';

class ProductListPage extends StatefulWidget {
  static const String routeName = "/products";
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPagetState();
}

class _ProductListPagetState extends State<ProductListPage> {
  ProductProvider? _productProvider;
  List<Product> data = [];
  List<ProductCategory> categories = [];
  ProductCategoryProvider? _productCategoryProvider;
  RatingProvider? _ratingProvider;
  WishlistProvider? _wishlistProvider;

  String _selectedCategory = "Sve kategorije";
  String _selectedCondition = "Svi proizvodi";
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();

  bool get _hasActiveFilters =>
      _searchController.text.trim().isNotEmpty ||
      _selectedCategory != 'Sve kategorije' ||
      _selectedCondition != 'Svi proizvodi';

  @override
  void initState() {
    super.initState();
    _productProvider = context.read<ProductProvider>();
    _productCategoryProvider = context.read<ProductCategoryProvider>();
    _ratingProvider = context.read<RatingProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WishlistProductProvider>().ensureWishlistExists(context);
    });

    loadData();
    _loadCategories();
  }

  Future<void> loadData() async {
    if (LoggedInUser.userId == null) {
      debugPrint("UserId is null. Ensure user is logged in.");
      return;
    }
    setState(() => _isLoading = true);

    try {
      // Ako API podržava, bolje je server-side:
      // final products = await _productProvider?.get({'statusProizvodaId': 1, 'excludeUserId': LoggedInUser.userId});
      final products =
          await _productProvider?.getUserSpecificProducts(LoggedInUser.userId);

      if (!mounted) return;
      setState(() {
        data = _excludeMyProducts(products)
            .where((p) => p.statusProizvodaId == 1)
            .toList();
        _isLoading = false;
      });
    } catch (e, stacktrace) {
      debugPrint('Error loading data: $e\n$stacktrace');
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  List<Product> _excludeMyProducts(List<Product>? src) {
    final myId = LoggedInUser.userId;
    if (src == null || myId == null) return src ?? <Product>[];

    final myIdStr = myId.toString();
    return src.where((p) => p.korisnikId?.toString() != myIdStr).toList();
  }

  Future<void> _resetFilters() async {
    setState(() {
      _searchController.clear();
      _selectedCategory = 'Sve kategorije';
      _selectedCondition = 'Svi proizvodi';
      _isLoading = true;
    });
    await _applyFilters();
  }

  void toggleFavorite(Product p) async {
    final wlp = context.read<WishlistProductProvider>();
    if (wlp.containsProduct(p.id!)) {
      await wlp.removeFromWishlistByProductId(p.id!);
    } else {
      await wlp.addToWishlist(context, p.id!);
    }
  }

  Future<void> _loadCategories() async {
    final tmpData = await _productCategoryProvider?.get(null);
    setState(() {
      if (tmpData != null) categories = tmpData;
    });
  }

  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;

    return MasterPageWidget(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildProductSearch(),
            const SizedBox(height: 40),
            if (_isLoading)
              Center(child: SpinKitFadingCircle(color: purple, size: 60))
            else if (data.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: EmptyState(
                  icon: Icons.inventory_2_outlined,
                  title: 'Trenutno nema proizvoda.',
                  subtitle: _hasActiveFilters
                      ? 'Nijedan proizvod ne odgovara odabranim filtrima.'
                      : 'Dodajte prvi artikal da bi bio prikazan ovdje.',
                  actionText: _hasActiveFilters ? 'Prikaži sve' : null,
                  onAction: _hasActiveFilters ? _resetFilters : null,
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 4.5,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 35,
                  physics: const NeverScrollableScrollPhysics(),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        "Proizvodi",
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 40,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildProductSearch() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: TextField(
            controller: _searchController,
            onSubmitted: (_) async => _applyFilters(),
            onChanged: (_) async => _applyFilters(),
            decoration: InputDecoration(
              hintText: "Search",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 5),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  onChanged: (newValue) async {
                    setState(() => _selectedCategory = newValue!);
                    await _applyFilters();
                  },
                  items: _buildCategoryDropdownItems(),
                  icon: const Icon(Icons.arrow_drop_down),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: DropdownButton<String>(
                  value: _selectedCondition,
                  onChanged: (newValue) async {
                    setState(() => _selectedCondition = newValue!);
                    await _applyFilters();
                  },
                  items: _buildConditionDropdownItems(),
                  icon: const Icon(Icons.arrow_drop_down),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Future<void> _applyFilters() async {
    setState(() => _isLoading = true);

    final Map<String, dynamic> params = {'statusProizvodaId': 1};
    final naziv = _searchController.text.trim();
    if (naziv.isNotEmpty) params['naziv'] = naziv;
    if (_selectedCategory != 'Sve kategorije')
      params['nazivKategorije'] = _selectedCategory;
    if (_selectedCondition != 'Svi proizvodi')
      params['novo'] = _selectedCondition == 'Novo';

    try {
      final tmp = await _productProvider?.get(params);
      if (!mounted) return;

      final filtered = _excludeMyProducts(tmp);
      setState(() {
        data = filtered;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      debugPrint('Apply filters failed: $e');
    }
  }

  List<DropdownMenuItem<String>> _buildCategoryDropdownItems() {
    final items = <DropdownMenuItem<String>>[
      const DropdownMenuItem<String>(
        value: "Sve kategorije",
        child: Text("Sve kategorije"),
      ),
    ];
    for (var category in categories) {
      items.add(DropdownMenuItem<String>(
        value: category.naziv,
        child: Text(category.naziv!),
      ));
    }
    return items;
  }

  List<DropdownMenuItem<String>> _buildConditionDropdownItems() {
    const conditions = ["Svi proizvodi", "Novo", "Polovno"];
    return conditions
        .map((c) => DropdownMenuItem<String>(value: c, child: Text(c)))
        .toList();
  }

  List<Widget> _buildProductCardList() {
    final wlp = context.watch<WishlistProductProvider>();
    return data.map((product) {
      final imageWidget = product.slika != null
          ? imageFromBase64String(product.slika!)
          : const SizedBox.shrink();

      final isFav = wlp.containsProduct(product.id!);

      return Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(
                      context,
                      "${ProductDetailsPage.routeName}/${product.id}",
                    ),
                    child: imageWidget,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => toggleFavorite(product),
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.grey.shade700,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(product.naziv ?? ''),
            const SizedBox(height: 8),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemSize: 20,
              itemBuilder: (_, __) =>
                  const Icon(Icons.star, color: Colors.yellow),
              onRatingUpdate: (r) => submitRating(r, product.id!),
            ),
          ],
        ),
      );
    }).toList();
  }

  Future<void> submitRating(double rating, int productId) async {
    try {
      final response = await _ratingProvider?.insert({
        'ocjena1': rating.round(),
        'datum': DateTime.now().toIso8601String(),
        'proizvodId': productId,
        'korisnikId': LoggedInUser.userId,
      });
      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ocjena je uspješno zabilježena!")),
        );
      } else {
        throw Exception('Failed to submit rating');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text("Došlo je do greške prilikom zabilježavanja ocjene: $e"),
        ),
      );
    }
  }
}

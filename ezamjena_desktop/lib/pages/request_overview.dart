import 'dart:convert';
import 'dart:io';

import 'package:ezamjena_desktop/model/product.dart';
import 'package:ezamjena_desktop/model/product_category.dart';
import 'package:ezamjena_desktop/model/user.dart';
import 'package:ezamjena_desktop/providers/product_category_provider.dart';
import 'package:ezamjena_desktop/providers/products_provider.dart';
import 'package:ezamjena_desktop/providers/user_provider.dart';
import 'package:ezamjena_desktop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:collection/collection.dart';

class RequestOverviewPage extends StatefulWidget {
  static const routeName = '/requestOverview';

  const RequestOverviewPage({super.key});
  @override
  _RequestOverviewPageState createState() => _RequestOverviewPageState();
}

class _RequestOverviewPageState extends State<RequestOverviewPage> {
  late List<bool> _selectedCategories;
  List<Product> products = [];
  List<ProductCategory> categories = [];
  ProductCategoryProvider? _productCategoryProvider = null;
  ProductProvider? _productProvider;
  bool _isNovo = true; // Example state for 'new' toggle
  bool? isNew; // Initial state set in dialog setup
  String _searchQuery = ""; // State to hold the search text
  final ImagePicker _imagePicker = ImagePicker();
  @override
  void initState() {
    super.initState();

    _productProvider = context.read<ProductProvider>();
    _productCategoryProvider = context.read<ProductCategoryProvider>();

    _loadCategories();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false)
          .addListener(_loadProducts);
      _loadProducts(); // Inicijalno učitavanje podataka
    });
  }

  Future<void> _loadCategories() async {
    var tmpData = await _productCategoryProvider?.get(null);
    if (tmpData != null) {
      setState(() {
        categories = tmpData;
        _selectedCategories = List<bool>.filled(categories.length, false);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _productProvider = context.watch<ProductProvider>();
    _loadProducts();
  }

  void refreshPage() {
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    if (_productProvider == null) {
      print("ProductProvider not initialized");
      return;
    }

    try {
      // Učitavanje svih proizvoda bez filtriranja
      List<Product> allProducts = await _productProvider!.get();

      // Filtriranje proizvoda na klijentskoj strani
      List<Product> filteredProducts = allProducts.where((product) {
        // Proverava da li je neka kategorija izabrana
        bool isAnyCategorySelected =
            _selectedCategories.any((selected) => selected);
        // Filtriranje po kategoriji
        bool categoryMatch = !isAnyCategorySelected ||
            _selectedCategories.asMap().entries.any((entry) {
              int index = entry.key;
              bool selected = entry.value;
              return selected &&
                  categories[index].naziv == product.kategorijaProizvoda?.naziv;
            });
        // Filtriranje po novom/polovnom
        bool conditionMatch =
            (_isNovo == null || product.stanjeNovo == _isNovo);
        // Filtriranje po imenu
        bool nameMatch = _searchQuery.isEmpty ||
            product.naziv!.toLowerCase().contains(_searchQuery.toLowerCase());
        return categoryMatch && conditionMatch && nameMatch;
      }).toList();

      setState(() {
        products =
            filteredProducts.where((p) => p.statusProizvodaId == 3).toList();
      });
    } catch (e) {
      print("Error loading products: $e");
    }
  }

  void updateFilters({bool? isNovo, String? searchQuery}) {
    if (isNovo != null) _isNovo = isNovo;
    if (searchQuery != null) _searchQuery = searchQuery;
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          TextField(
            onChanged: (value) => updateFilters(searchQuery: value),
            decoration: InputDecoration(
              labelText: 'Pretraži po nazivu',
              suffixIcon: Icon(Icons.search),
            ),
          ),
          Wrap(
            children: List<Widget>.generate(categories.length, (int index) {
              return ChoiceChip(
                label: Text(categories[index].naziv!),
                selected: _selectedCategories[index],
                onSelected: (bool selected) {
                  setState(() {
                    _selectedCategories[index] = selected;
                  });
                  _loadProducts();
                },
              );
            }),
          ),
          ToggleButtons(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Novo'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Polovno'),
              ),
            ],
            isSelected: [_isNovo, !_isNovo],
            onPressed: (int index) {
              updateFilters(isNovo: index == 0);
            },
          ),
          Align(
            alignment: Alignment
                .centerRight, // or Alignment.centerLeft for left alignment
            child: IconButton(
              icon: Icon(Icons.refresh),
              onPressed: refreshPage,
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                DataTable(
                  columns: const <DataColumn>[
                    DataColumn(label: Text('Naziv')),
                    DataColumn(label: Text('Kategorija')),
                    DataColumn(label: Text('Opis')),
                    DataColumn(label: Text('Cijena')),
                    DataColumn(label: Text('Fotografija')),
                    DataColumn(label: Text('Potvrdi')),
                    DataColumn(label: Text('Odbij')),
                  ],
                  rows: products.map<DataRow>((Product product) {
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(Text(product.naziv ?? '')),
                        DataCell(
                            Text(product.kategorijaProizvoda?.naziv ?? '')),
                        DataCell(Text(product.opis ?? '')),
                        DataCell(Text(product.cijena?.toString() ?? '')),
                        DataCell(product.slika != null
                            ? Container(
                                width: 100,
                                height: 50,
                                child: imageFromBase64String(product.slika),
                              )
                            : const Icon(Icons.image_not_supported)),
                        DataCell(
                          Center(
                              child: InkWell(
                                  child: Icon(Icons.check),
                                  onTap: () => _acceptProduct(product))),
                        ),
                        DataCell(
                          Icon(Icons.close),
                          onTap: () => _rejectProduct(product),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: _acceptAll, child: Text('Prihvati sve')),
                ElevatedButton(onPressed: _rejectAll, child: Text('Odbij sve')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _acceptProduct(Product product) async {
    var productProvider = Provider.of<ProductProvider>(context, listen: false);
    // Create a new map with the updated status
    var updateData = {
      ...product.toJson(), // Assuming Product class has toJson method
      'statusProizvodaId': 1 // Update status to '1' which means in sale
    };
    // Calling update method
    await productProvider.update(product.id, updateData);
    _loadProducts(); // Refresh the list to reflect changes
    productProvider.refreshProducts();
    await _updateUserActiveProducts(product.korisnikId!);
    _showDialog(
        'Proizvod ${product.naziv} je prihvaćen i u prodaji je.'); // Show confirmation dialog
  }

  void _rejectProduct(Product product) async {
    var productProvider = Provider.of<ProductProvider>(context, listen: false);
    await productProvider.delete(product.id!);
    _loadProducts(); // Refresh the list to reflect changes
    _showDialog(
        'Proizvod ${product.naziv} je odbijen za prodaju'); // Show rejection dialog
  }

  void _acceptAll() async {
    var productProvider = Provider.of<ProductProvider>(context, listen: false);
    for (var product in products) {
      var updateData = {...product.toJson(), 'statusProizvodaId': 1};
      await productProvider.update(product.id, updateData);
      await _updateUserActiveProducts(product.korisnikId!);
    }
    _loadProducts();

    productProvider.refreshProducts();
    _showDialog('Svi proizvodi su prihvaceni i u prodaji su');
  }

  void _rejectAll() async {
    var productProvider = Provider.of<ProductProvider>(context, listen: false);
    for (var product in products) {
      await productProvider.delete(product.id!);
    }
    _loadProducts();

    _showDialog('Svi proizvodi su odbijeni za prodaju');
  }

  // Method to update the number of active products for a user
  Future<void> _updateUserActiveProducts(int userId) async {
    var userProvider = Provider.of<UserProvider>(context, listen: false);

    // Retrieve current user data
    User? userData = await userProvider.getById(userId);
    var updatedActiveProducts =
        userData!.brojAktivnihArtikala! + 1; // Increment the count

    // Update the user data with the new count of active products
    var updateUser = {
      ...userData.toJson(), // Convert existing data to JSON
      'brojAktivnihArtikala': updatedActiveProducts
    };

    await userProvider.update(
        userId, updateUser); // Assuming you have such a method
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Notifikacija"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:ezamjena_desktop/model/product.dart';
import 'package:ezamjena_desktop/model/product_category.dart';
import 'package:ezamjena_desktop/providers/product_category_provider.dart';
import 'package:ezamjena_desktop/providers/products_provider.dart';
import 'package:ezamjena_desktop/utils/ez_search_field.dart';
import 'package:ezamjena_desktop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:collection/collection.dart';

class ProductOverviewPage extends StatefulWidget {
  static const String routeName = '/productOverview';

  const ProductOverviewPage({super.key});
  @override
  _ProductOverviewPageState createState() => _ProductOverviewPageState();
}

class _ProductOverviewPageState extends State<ProductOverviewPage>
    with SingleTickerProviderStateMixin {
  late List<bool> _selectedCategories;
  List<Product> products = [];
  List<ProductCategory> categories = [];
  ProductCategoryProvider? _productCategoryProvider = null;
  late ProductProvider _productProvider;
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
    _productProvider.addListener(_loadProducts);

    _loadProducts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _productProvider = context.watch<ProductProvider>();
    _loadProducts();
  }

  @override
  void dispose() {
    _productProvider.removeListener(_loadProducts);
    super.dispose();
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

  Future<void> _loadProducts() async {
    if (_productProvider == null) {
      print("ProductProvider not initialized");
      return;
    }

    try {
      // Učitavanje svih proizvoda bez filtriranja
      List<Product> allProducts = await _productProvider!.get();

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
                  categories[index].naziv == product.nazivKategorijeProizvoda;
            });
        // Filtriranje po novom/polovnom
        bool conditionMatch =
            (_isNovo == null || product.stanjeNovo == _isNovo);
        // Filtriranje po imenu
        bool nameMatch = _searchQuery.isEmpty ||
            product.naziv!.toLowerCase().contains(_searchQuery.toLowerCase());
        bool statusMatch = product.statusProizvodaId == 1;
        return categoryMatch && conditionMatch && nameMatch && statusMatch;
      }).toList();

      setState(() {
        products = filteredProducts;
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

  Future<void> _addPicture(Product product) async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final fileBytes = await File(pickedFile.path).readAsBytes();
      final String base64String = base64Encode(fileBytes);

      setState(() {
        product.slika = base64String;
      });
    } else {
      // Optionally handle the case when the user cancels the image picker.
      print("No image selected.");
    }
  }

  Future<void> _showEditProductDialog(Product product) async {
    // Form key za validaciju
    final _formKey = GlobalKey<FormState>();

    TextEditingController nameController =
        TextEditingController(text: product.naziv);
    TextEditingController priceController =
        TextEditingController(text: product.cijena?.toString() ?? '');
    TextEditingController descriptionController =
        TextEditingController(text: product.opis);
    TextEditingController userController =
        TextEditingController(text: product.nazivKorisnika);

    String? selectedCategory = product.nazivKategorijeProizvoda;
    bool? isNew = product.stanjeNovo;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: StatefulBuilder(
              builder: (ctx, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ───────── Header ─────────
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Uredi artikal – ${product.naziv}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            splashRadius: 18,
                            onPressed: () => Navigator.pop(ctx),
                          )
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    // ───────── Body ─────────
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                        child: Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Slika
                                  InkWell(
                                    onTap: () async {
                                      await _addPicture(product);
                                      setState(() {});
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        width: 180,
                                        height: 220,
                                        color: Colors.grey.shade300,
                                        child: product.slika == null
                                            ? const Icon(Icons.add_a_photo,
                                                size: 36, color: Colors.white70)
                                            : imageFromBase64String(
                                                product.slika,
                                              ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 32),
                                  // Polja
                                  Expanded(
                                    child: Column(
                                      children: [
                                        _textField('Naziv *', nameController,
                                            validator: _required),
                                        const SizedBox(height: 16),
                                        _dropdown(
                                            context,
                                            'Kategorija *',
                                            selectedCategory,
                                            categories
                                                .map((c) => c.naziv!)
                                                .toList(),
                                            (v) => setState(
                                                () => selectedCategory = v)),
                                        const SizedBox(height: 16),
                                        _textField('Procijenjena cijena *',
                                            priceController,
                                            keyboard: TextInputType.number,
                                            validator: _priceValidator),
                                        const SizedBox(height: 16),
                                        _textField('Korisnik *', userController,
                                            validator: _required),
                                        const SizedBox(height: 16),
                                        CheckboxListTile(
                                          title: const Text(
                                            'Novo',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          value: isNew,
                                          dense: true,
                                          contentPadding: EdgeInsets.zero,
                                          onChanged: (v) =>
                                              setState(() => isNew = v),
                                        ),
                                        const SizedBox(height: 20),
                                        _textField('Opis proizvoda',
                                            descriptionController,
                                            maxLines: 3),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // ───────── Footer ─────────
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 12, 24, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Odustani'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) return;

                              final updateData = {
                                'naziv': nameController.text.trim(),
                                'cijena': double.tryParse(
                                        priceController.text.trim()) ??
                                    0.0,
                                'opis': descriptionController.text.trim(),
                                'slika': product.slika,
                                'korisnikId': product.korisnikId,
                                'kategorijaProizvodaId': categories
                                    .firstWhereOrNull(
                                        (c) => c.naziv == selectedCategory)
                                    ?.id,
                                'stanjeNovo': isNew,
                                'statusProizvodaId': 1,
                              };

                              await _productProvider.update(
                                  product.id, updateData);

                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Proizvod "${product.naziv}" je uspješno ažuriran!')),
                              );
                              _loadProducts();
                            },
                            child: const Text('Spremi'),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Obavezno polje' : null;

  String? _priceValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Obavezno polje';
    return double.tryParse(v) == null ? 'Unesite broj' : null;
  }

  Widget _textField(String label, TextEditingController c,
      {String? Function(String?)? validator,
      TextInputType keyboard = TextInputType.text,
      int maxLines = 1}) {
    return TextFormField(
      controller: c,
      maxLines: maxLines,
      keyboardType: keyboard,
      decoration: InputDecoration(labelText: label),
      validator: validator,
    );
  }

  Widget _dropdown(BuildContext ctx, String label, String? value,
      List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
      value: value,
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? 'Obavezno polje' : null,
    );
  }

  Future<void> _showSuccessDialog(String productName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Korisnik mora da pritisne dugme da zatvori dijalog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ažuriranje uspješno'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Uspješno ste uredili proizvod: $productName.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Zatvara dijalog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteConfirmationDialog(Product product) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Potvrda brisanja'),
          content: Text(
              'Da li ste sigurni da želite obrisati proizvod "${product.naziv}"?'),
          actions: <Widget>[
            TextButton(
              child: Text('Ne'),
              onPressed: () {
                Navigator.of(context).pop(); // Zatvara samo dijalog za potvrdu
              },
            ),
            TextButton(
              child: Text('Da'),
              onPressed: () async {
                Navigator.of(context).pop(); // Zatvara dijalog za potvrdu
                await _deleteProduct(product); // Poziva funkciju za brisanje
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProduct(Product product) async {
    await _productProvider!.delete(product.id!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Proizvod "${product.naziv}" je uspješno obrisan!'),
      ),
    );
    _loadProducts(); // Osvježava listu proizvoda nakon brisanja
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(height: 12),
          EzSearchField(
            onChanged: (v) => updateFilters(searchQuery: v),
          ),
          const SizedBox(height: 12),
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
          const SizedBox(height: 8),
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
          const SizedBox(height: 10),
          Expanded(
            child: products.isEmpty
                ? Center(child: Text('Trenutno nema aktivnih artikala'))
                : ListView(
                    children: <Widget>[
                      DataTable(
                        columns: const <DataColumn>[
                          DataColumn(label: Text('Naziv')),
                          DataColumn(label: Text('Kategorija')),
                          DataColumn(label: Text('Opis')),
                          DataColumn(label: Text('Cijena')),
                          DataColumn(label: Text('Fotografija')),
                          DataColumn(label: Text('Uredi')),
                          DataColumn(label: Text('Obriši')),
                        ],
                        rows: products.map<DataRow>((Product product) {
                          return DataRow(
                            cells: <DataCell>[
                              DataCell(Text(product.naziv ?? '')),
                              DataCell(Text(
                                  product.kategorijaProizvoda?.naziv ?? '')),
                              DataCell(Text(product.opis ?? '')),
                              DataCell(Text(product.cijena?.toString() ?? '')),
                              DataCell(product.slika != null
                                  ? Container(
                                      width: 100,
                                      height: 50,
                                      child:
                                          imageFromBase64String(product.slika),
                                    )
                                  : const Icon(Icons.image_not_supported)),
                              DataCell(
                                Center(
                                    child: InkWell(
                                  child: Icon(Icons.edit),
                                  onTap: () => _showEditProductDialog(product),
                                )),
                              ),
                              DataCell(
                                Icon(Icons.delete),
                                onTap: () =>
                                    _showDeleteConfirmationDialog(product),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

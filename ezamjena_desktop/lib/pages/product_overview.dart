import 'dart:convert';
import 'dart:io';

import 'package:ezamjena_desktop/model/product.dart';
import 'package:ezamjena_desktop/model/product_category.dart';
import 'package:ezamjena_desktop/providers/product_category_provider.dart';
import 'package:ezamjena_desktop/providers/products_provider.dart';
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

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                'Pregled/uređivanje podataka o artiklu - ${product.naziv}',
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  // Automatsko validiranje na temelju korisničke interakcije
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () async {
                              await _addPicture(product);
                              setState(() {});
                            },
                            child: Container(
                              width: 200,
                              height: 230,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                image: product.slika != null
                                    ? DecorationImage(
                                        image: MemoryImage(
                                            base64Decode(product.slika!)),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: product.slika == null
                                  ? Icon(Icons.camera_alt,
                                      color: Colors.white70)
                                  : imageFromBase64String(product.slika),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Naziv - obavezno polje
                                TextFormField(
                                  controller: nameController,
                                  decoration:
                                      InputDecoration(labelText: 'Naziv:'),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Naziv je obavezan';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20),
                                // Kategorija - obavezno polje
                                Text('Kategorija:'),
                                FormField<String>(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (selectedCategory == null ||
                                        selectedCategory!.isEmpty) {
                                      return 'Kategorija je obavezna';
                                    }
                                    return null;
                                  },
                                  builder: (FormFieldState<String> fieldState) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        DropdownButton<String>(
                                          isExpanded: true,
                                          value: selectedCategory,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedCategory = newValue;
                                            });
                                            fieldState.didChange(newValue);
                                          },
                                          items: categories
                                              .map<DropdownMenuItem<String>>(
                                                  (ProductCategory category) {
                                            return DropdownMenuItem<String>(
                                              value: category.naziv,
                                              child: Text(category.naziv!),
                                            );
                                          }).toList(),
                                        ),
                                        if (fieldState.hasError)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: Text(
                                              fieldState.errorText!,
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                                SizedBox(height: 20),
                                // Cijena - obavezno polje
                                TextFormField(
                                  controller: priceController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      labelText: 'Procenjena cena:'),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Cijena je obavezna';
                                    }
                                    if (double.tryParse(value) == null) {
                                      return 'Unesite ispravnu numeričku vrijednost';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20),
                                // Korisnik - obavezno polje
                                TextFormField(
                                  controller: userController,
                                  keyboardType: TextInputType.text,
                                  decoration:
                                      InputDecoration(labelText: 'Korisnik:'),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Korisnik je obavezan';
                                    }
                                    return null;
                                  },
                                ),
                                // Checkbox za stanje "Novo"
                                CheckboxListTile(
                                  title: Text('Novo'),
                                  value: isNew,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isNew = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Opis proizvoda (nije obavezno)
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: TextFormField(
                          controller: descriptionController,
                          decoration:
                              InputDecoration(labelText: 'Opis proizvoda:'),
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Odustani'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text('Spremi'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      var updateData = {
                        "naziv": nameController.text.trim(),
                        "cijena":
                            double.tryParse(priceController.text.trim()) ?? 0.0,
                        "opis": descriptionController.text.trim(),
                        "slika": product.slika,
                        "korisnikId": product.korisnikId,
                        "kategorijaProizvodaId": categories
                            .firstWhereOrNull(
                                (c) => c.naziv == selectedCategory)
                            ?.id,
                        "stanjeNovo": isNew,
                        "statusProizvodaId": 1
                      };

                      await _productProvider!.update(product.id, updateData);
                      Navigator.of(context).pop();
                      _showSuccessDialog(product.naziv!);
                      //_loadProducts(); // Osvježi listu proizvoda
                    } else {
                      print(
                          "Forma nije validna - popunite sva obavezna polja.");
                    }
                  },
                ),
              ],
            );
          },
        );
      },
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
    await _productProvider!
        .delete(product.id!); // Pretpostavljamo da postoji metoda delete
    _showSuccessDialog("Proizvod '${product.naziv}' je uspješno obrisan");
    _loadProducts(); // Osvježava listu proizvoda nakon brisanja
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

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../model/product.dart';
import '../../model/product_category.dart';
import '../../providers/product_category_provider.dart';
import '../../providers/products_provider.dart';
import '../../utils/logged_in_usser.dart';

class NewProductPage extends StatefulWidget {
  static const String routeName = "/new_product";

  const NewProductPage({super.key});

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  ProductProvider? _productProvider;
  Product? data;
  List<ProductCategory> categories = [];
  ProductCategory? selectedCategory;
  ProductCategoryProvider? _productCategoryProvider;
  bool isNew = false;

  final TextEditingController _nazivController = TextEditingController();
  final TextEditingController _procijenjenaCijenaController =
      TextEditingController();
  final TextEditingController _opisController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  bool _formValid = false;
  bool _pickingImage = false;
  AutovalidateMode _autoMode = AutovalidateMode.disabled;
  void _enableAutoValidate() =>
      setState(() => _autoMode = AutovalidateMode.onUserInteraction);

  @override
  void initState() {
    super.initState();
    _productCategoryProvider = context.read<ProductCategoryProvider>();
    _productProvider = context.read<ProductProvider>();
    loadData();
  }

  Future loadData() async {
    var tmpData = await _productCategoryProvider?.get(null);

    setState(() {
      if (tmpData != null) {
        categories = tmpData;
      }
    });
  }

  Future<void> _addPicture() async {
    if (_pickingImage) return;

    try {
      _pickingImage = true;
      final picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (picked == null) return;

      final bytes = await File(picked.path).readAsBytes();
      setState(() {
        data = (data ?? Product())..slika = base64Encode(bytes);
      });
    } on PlatformException catch (e) {
      debugPrint('⚠️ ImagePicker error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nije moguće otvoriti galeriju.')),
      );
    } finally {
      _pickingImage = false;
    }
  }

  Future<void> addProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    var newProductData = {
      "naziv": _nazivController.text,
      "cijena": double.parse(_procijenjenaCijenaController.text),
      "opis": _opisController.text,
      "stanjeNovo": isNew,
      "slika": data?.slika,
      "korisnikId": LoggedInUser.userId,
      "statusProizvodaId": 3, // na čekanju
      "kategorijaProizvodaId": selectedCategory!.id,
    };

    try {
      var result = await _productProvider!.insert(newProductData);
      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Proizvod je uspješno dodan.Molimo pričekajte da ga administrator odobri.')),
        );
        _nazivController.clear();
        _procijenjenaCijenaController.clear();
        _opisController.clear();

        setState(() {
          data = null;
          selectedCategory = null;
          isNew = false;
          _autoMode = AutovalidateMode.disabled;
        });
      } else {
        throw Exception('Failed to add the product');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Greška pri dodavanju proizvoda: ${e.toString()}')),
      );
    }
  }

  void _updateFormState() {
    final valid = _formKey.currentState?.validate() ?? false;
    setState(() => _formValid = valid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dodavanje novog proizvoda")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          autovalidateMode: _autoMode,
          onChanged: _updateFormState,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              productInfoWidget(),
              SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // cancel logic
                    },
                    child: const Text('Odustani'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD5473C), // crvena
                      foregroundColor: Colors.white, // bijeli tekst
                      // ako si još na Material 2:
                      // primary: Color(0xFFD5473C),
                      // onPrimary: Colors.white,
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    // ①  gasi dugme kad _formValid == false
                    onPressed: _formValid ? addProduct : null,

                    // ②  (opcionalno) prilagodi boje za enabled/disabled stanja
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _formValid ? Colors.deepPurple : Colors.grey.shade300,
                      foregroundColor:
                          _formValid ? Colors.white : Colors.grey.shade600,
                    ),
                    child: const Text('Dodaj'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget productInfoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dodavanje novog proizvoda',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _addPicture,
              child: Container(
                width: 200,
                height: 230,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  image: data != null && data!.slika != null
                      ? DecorationImage(
                          image: MemoryImage(base64Decode(data!.slika!)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: data != null && data!.slika == null
                    ? Icon(Icons.add_a_photo, color: Colors.white)
                    : null,
              ),
            ),
            SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Naziv:', style: TextStyle(fontSize: 15)),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: _nazivController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          hintText: 'Unesite naziv',
                          border: OutlineInputBorder(),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ovo polje je obavezno';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kategorija:', style: TextStyle(fontSize: 15)),
                      SizedBox(height: 5),
                      DropdownButtonFormField<ProductCategory>(
                        value: selectedCategory,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (category) {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                        items: categories.map((category) {
                          return DropdownMenuItem<ProductCategory>(
                            value: category,
                            child: Text(category.naziv ?? ""),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Ovo polje je obavezno';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Procijenjena cijena:',
                          style: TextStyle(fontSize: 15)),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: _procijenjenaCijenaController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          hintText: 'Unesite cijenu',
                          border: OutlineInputBorder(),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ovo polje je obavezno';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Unesite ispravnu cijenu';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text('Stanje:', style: TextStyle(fontSize: 15)),
                      Checkbox(
                        value: isNew,
                        onChanged: (value) {
                          setState(() {
                            isNew = value!;
                          });
                        },
                      ),
                      Text('Novo'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Text('Opis proizvoda:', style: TextStyle(fontSize: 20)),
        SizedBox(height: 5),
        Container(
          height: 150,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextField(
            controller: _opisController,
            maxLines: null,
            decoration: InputDecoration.collapsed(
              hintText: 'Unesite opis...',
            ),
          ),
        ),
      ],
    );
  }
}

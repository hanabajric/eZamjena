import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
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
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final fileBytes = await File(pickedFile.path).readAsBytes();
      final String base64String = base64Encode(fileBytes);

      setState(() {
        data = (data ?? Product())..slika = base64String;
      });
    } else {
      print("No image selected.");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dodavanje novog proizvoda")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey, // Use the GlobalKey here
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
                    child: Text('Odustani'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 213, 71, 60),
                      ),
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: addProduct,
                    child: Text('Dodaj'),
                  ),
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

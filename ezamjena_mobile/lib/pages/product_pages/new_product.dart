import 'dart:convert';
import 'dart:io';

import 'package:ezamjena_mobile/widets/master_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../model/product.dart';
import '../../model/product_category.dart';
import '../../model/trade.dart';
import '../../providers/buy_provider.dart';
import '../../providers/exchange_provider.dart';
import '../../providers/product_category_provider.dart';
import '../../providers/products_provider.dart';
import '../../utils/logged_in_usser.dart';
import '../../utils/utils.dart';
import '../../widets/alert_dialog_widet.dart';

class NewProductPage extends StatefulWidget {
  static const String routeName = "/new_product";

  const NewProductPage({super.key});

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  ProductProvider? _productProvider = null;
  Product? data;
  List<Product> list = [];
  Product? selectedProduct;
  List<ProductCategory> categories = [];
  ProductCategory? selectedCategory;
  ProductCategoryProvider? _productCategoryProvider = null;
  bool isNew = false;
  final TextEditingController _nazivController = TextEditingController();
  final TextEditingController _procijenjenaCijenaController =
      TextEditingController();
  final TextEditingController _opisController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _productCategoryProvider = context.read<ProductCategoryProvider>();
    _productProvider = context.read<ProductProvider>();
    //id = widget.id;
    loadData();
  }

  Future loadData() async {
    var tmpData = await _productCategoryProvider?.get(null);
    print('ovo je dodavanje proizvoda');

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
      // Optionally handle the case when the user cancels the image picker.
      print("No image selected.");
    }
  }

  Future<void> addProduct() async {
    if (_nazivController.text.isEmpty || selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields!')),
      );
      return;
    }

    var newProductData = {
      "naziv": _nazivController.text,
      "cijena": double.parse(_procijenjenaCijenaController.text),
      "opis": _opisController.text,
      "stanjeNovo": isNew,
      "slika": data?.slika, // Ensure this is base64 encoded if it's not null
      "korisnikId": LoggedInUser.userId,
      "statusProizvodaId": 1,
      "kategorijaProizvodaId": selectedCategory!.id,
    };

    try {
      var result = await _productProvider!.insert(newProductData);
      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Vaš proizvod ${_nazivController.text} je uspješno dodan')),
        );
        // Optionally reset the form or navigate the user away
      } else {
        throw Exception('Failed to add the product');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding product: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterPageWidget(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            productInfoWidget(),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Ovdje postavite logiku za klik na prvo dugme
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
                  onPressed: () {
                    addProduct();
                  },
                  child: Text('Dodaj'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget productInfoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dodavanje novog proizvoda ',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            GestureDetector(
              onTap: _addPicture, // Use method reference directly
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Naziv:', style: TextStyle(fontSize: 15)),
                      SizedBox(height: 5),
                      Container(
                        width: 150, // Prilagodite veličinu prema potrebi
                        height: 35, // Postavite željenu visinu
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextField(
                          controller: _nazivController,
                          // Add appropriate text field properties
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kategorija:', style: TextStyle(fontSize: 15)),
                      SizedBox(height: 5),
                      Container(
                        width: 150,
                        height: 35, // Postavite željenu visinu
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButton<ProductCategory>(
                          value: selectedCategory,
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
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Procjenjena cijena:',
                          style: TextStyle(fontSize: 15)),
                      SizedBox(height: 5),
                      Container(
                        width: 80,
                        height: 35, // Postavite željenu visinu
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: _procijenjenaCijenaController,
                          // Add appropriate text field properties
                        ),
                      ),
                    ],
                  ),
                  //SizedBox(height: 5),
                  Row(
                    children: [
                      Text('Stanje:', style: TextStyle(fontSize: 15)),
                      SizedBox(width: 10),
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
        SizedBox(height: 10),
        Text(
          'Opis proizvoda:',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 10),
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

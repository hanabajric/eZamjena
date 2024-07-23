import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:ezamjena_desktop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ezamjena_desktop/model/city.dart';
import 'package:ezamjena_desktop/model/user.dart';
import 'package:ezamjena_desktop/providers/city_provider.dart';
import 'package:ezamjena_desktop/providers/user_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UserProfilePage extends StatefulWidget {
  static const String routeName = '/allProfiles';
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String? selectedCityId;
  String filterByUsername = '';
  List<User> users = [];
  List<City> cities = [];
  bool isLoading = false;
  UserProvider? _userProvider = null;
  File? _imageFile; // To hold the picked image file
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _userProvider = context.read<UserProvider>();
    _loadCities();
    _loadUsers();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _loadCities() async {
    var cityProvider = Provider.of<CityProvider>(context, listen: false);
    var tmpData = await cityProvider.get();
    if (tmpData != null) {
      setState(() {
        cities = [City(id: null, naziv: "Svi gradovi")] + tmpData;
      });
    }
  }

  Future<void> _loadUsers() async {
    isLoading = true;
    try {
      Map<String, dynamic> searchQuery = {};
      if (filterByUsername.isNotEmpty) {
        searchQuery['KorisnickoIme'] = filterByUsername;
      }
      if (selectedCityId != null) {
        searchQuery['grad.Id'] = selectedCityId;
      }

      var tmpData = await _userProvider?.get(searchQuery);
      if (tmpData != null) {
        setState(() {
          users = tmpData;
        });
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context)
        .size
        .width; // Širina ekrana za dinamičko prilagođavanje

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05), // Dodavanje horizontalnog paddinga
        child: Column(
          children: <Widget>[
            SizedBox(height: 20), // Dodavanje malo prostora na vrhu
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 20), // Lokalni padding za red
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centriranje sadržaja reda
                children: <Widget>[
                  // Dropdown za gradove
                  Expanded(
                    flex: 3, // Manji dio za dropdown
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedCityId,
                      hint: Text("Odaberite grad"),
                      onChanged: (newValue) {
                        setState(() {
                          selectedCityId = newValue;
                          _loadUsers();
                        });
                      },
                      items: cities.map((City city) {
                        return DropdownMenuItem<String>(
                          value: city.id?.toString(),
                          child: Text(city.naziv ?? "N/A"),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(width: 30), // Razmak između elemenata
                  // Polje za pretraživanje
                  Expanded(
                    flex: 5, // Veći dio za polje za pretraživanje
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Pretraži po korisničkom imenu',
                        suffixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(30), // Zaobljeni uglovi
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal:
                                20), // Smanjena visina i dodat padding horizontalno
                      ),
                      onChanged: (value) {
                        setState(() {
                          filterByUsername = value;
                          _loadUsers();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? CircularProgressIndicator()
                  : SingleChildScrollView(
                      child: DataTable(
                        columns: const <DataColumn>[
                          DataColumn(label: Text('Korisničko ime')),
                          DataColumn(label: Text('Grad')),
                          DataColumn(label: Text('Broj telefona')),
                          DataColumn(label: Text('Email')),
                          DataColumn(label: Text('Broj razmjena')),
                          DataColumn(label: Text('Broj kupovina')),
                          DataColumn(label: Text('Uredi')),
                          DataColumn(label: Text('Obriši')),
                        ],
                        rows: users.map<DataRow>((user) {
                          return DataRow(cells: [
                            DataCell(Text(user.korisnickoIme ?? 'N/A')),
                            DataCell(Text(user.nazivGrada ?? 'N/A')),
                            DataCell(Text(user.telefon ?? 'N/A')),
                            DataCell(Text(user.email ?? 'N/A')),
                            DataCell(Text(user.brojRazmjena.toString())),
                            DataCell(Text(user.brojKupovina.toString())),
                            DataCell(IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () async {
                                if (_userProvider != null) {
                                  User? userDetails =
                                      await _userProvider?.getById(user.id);
                                  if (userDetails != null) {
                                    _showEditDialog(userDetails);
                                  } else {
                                    // Handle null userDetails, maybe show a message or log it
                                    print('User details not found');
                                  }
                                } else {
                                  // Handle the case when _userProvider is still null
                                  print('User provider not initialized');
                                }
                              },
                            )),
                            DataCell(Icon(Icons.delete)),
                          ]);
                        }).toList(),
                      ),
                    ),
            ),
            SizedBox(height: 20), // Dodavanje prostora na dnu
          ],
        ),
      ),
    );
  }

  void _showEditDialog(User user) {
    TextEditingController usernameController =
        TextEditingController(text: user.korisnickoIme);
    TextEditingController nameController =
        TextEditingController(text: user.ime);
    TextEditingController surnameController =
        TextEditingController(text: user.prezime);
    TextEditingController emailController =
        TextEditingController(text: user.email);
    TextEditingController phoneController =
        TextEditingController(text: user.telefon);
    TextEditingController addressController =
        TextEditingController(text: user.adresa);
    TextEditingController exchangeCountController =
        TextEditingController(text: user.brojRazmjena.toString());
    TextEditingController purchaseCountController =
        TextEditingController(text: user.brojKupovina.toString());
    TextEditingController activeArticleCountController =
        TextEditingController(text: user.brojAktivnihArtikala.toString());

    File? _imageFile;

    // Set initial selected city ID
    String? selectedCityId = user?.nazivGrada;

    Future<void> _pickImage(StateSetter setState) async {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() => _imageFile = File(image.path));
      }
    }

    Future<List<City>> fetchCities() async {
      var cityProvider = Provider.of<CityProvider>(context, listen: false);
      return await cityProvider.get();
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'Pregled/uređivanje podataka o korisniku - ${user.korisnickoIme}'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        await _pickImage(setState);
                      },
                      child: Container(
                        width: 200,
                        height: 230,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          image: _imageFile != null
                              ? DecorationImage(
                                  image: FileImage(_imageFile!),
                                  fit: BoxFit.cover)
                              : user.slika != null
                                  ? DecorationImage(
                                      image: MemoryImage(
                                          base64Decode(user.slika!)),
                                      fit: BoxFit.cover)
                                  : null,
                        ),
                        child: _imageFile == null && user.slika == null
                            ? Icon(Icons.camera_alt, color: Colors.white70)
                            : null,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                  labelText: 'Korisničko ime:')),
                          TextFormField(
                              controller: nameController,
                              decoration:
                                  InputDecoration(labelText: 'Ime i Prezime:')),
                          TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(labelText: 'Email:')),
                          TextFormField(
                              controller: phoneController,
                              decoration:
                                  InputDecoration(labelText: 'Broj telefona:')),
                          TextFormField(
                              controller: addressController,
                              decoration:
                                  InputDecoration(labelText: 'Adresa:')),
                          DropdownButton<String>(
                            isExpanded: true,
                            value: selectedCityId,
                            onChanged: (String? newValue) {
                              setState(() => selectedCityId = newValue);
                            },
                            items: cities
                                .map<DropdownMenuItem<String>>((City city) {
                              return DropdownMenuItem<String>(
                                value: city.naziv,
                                child: Text(city.naziv!),
                              );
                            }).toList(),
                          ),
                          TextFormField(
                              controller: exchangeCountController,
                              decoration:
                                  InputDecoration(labelText: 'Broj razmjena:')),
                          TextFormField(
                              controller: purchaseCountController,
                              decoration:
                                  InputDecoration(labelText: 'Broj kupovina:')),
                          TextFormField(
                              controller: activeArticleCountController,
                              decoration: InputDecoration(
                                  labelText: 'Broj aktivnih artikala:')),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Odustani'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Spremi'),
              onPressed: () async {
                Map<String, dynamic> updateData = {
                  'ime': nameController.text,
                  'prezime': surnameController.text,
                  'email': emailController.text,
                  'telefon': phoneController.text,
                  'adresa': addressController.text,
                  'gradId': cities
                      .firstWhereOrNull((c) => c.naziv == selectedCityId)
                      ?.id,
                  'brojRazmjena': int.tryParse(exchangeCountController.text),
                  'brojKupovina': int.tryParse(purchaseCountController.text),
                  'brojAktivnihArtikala':
                      int.tryParse(activeArticleCountController.text),
                  'slika': _imageFile != null
                      ? base64String(await _imageFile!.readAsBytes())
                      : user.slika
                };

                if (_userProvider != null) {
                  await _userProvider!.adminUpdate(user.id, updateData);

                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Podaci uspješno ažurirani!')));
                  _loadUsers();
                } else {
                  print('User provider not initialized');
                }
              },
            )
          ],
        );
      },
    );
  }
}
